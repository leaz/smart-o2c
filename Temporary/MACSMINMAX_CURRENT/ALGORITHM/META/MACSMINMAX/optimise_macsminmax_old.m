function [d,fval,exitflag,output] = optimise_macsminmax(problem_minmax, algo_outer, algo_inner, par_minmax)

% _old because it does not have "clever validation" where you cross-check the non-dominated first and so

global nfevalglobal
% Rename inputs
n_d = problem_minmax.dim_d;
n_u = problem_minmax.dim_u;
n_obj = problem_minmax.n_obj;
sign_inner = problem_minmax.sign_inner; % 1 for minmax, -1 for minmin

nfevalmax = par_minmax.maxnfeval;

% local search flags, ADD SANITY CHECKS AND STUFF HERE
lsflag_validation = par_minmax.local_search_flags.validation; % run either local search or func eval in validation
lsflag_inner = par_minmax.local_search_flags.inner;           % run either local search or func eval in SO problem
lsflag_outer = par_minmax.local_search_flags.outer;           % run either local search or func eval in MO problem

% Build metaproblems
problem_max_u = build_metaproblem_macsminmax_inner(problem_minmax);
problem_min_d = build_metaproblem_macsminmax_outer(problem_max_u,lsflag_outer);

% Random initial guess for d
d_0 = lhsu(zeros(1,n_d),ones(1,n_d),1);

% Initialise archive d
d_record = [];

% Now the fun begins
nfeval = 0;

% Initialise archive u
u_record = cell(1,n_obj);
problem_max_u.par_objfun.d = d_0;                                                 % tell metaproblem what d to fix
for obj = 1:n_obj
    problem_max_u.par_objfun.objective = obj;                                     % tell metaproblem what objective to optimise
    [ umax, ~ , ~ , output_aux ] = algo_inner.optimise(problem_max_u,algo_inner.par); % optimise
    u_record{obj} = [u_record{obj}; umax];                                        % append result
    nfeval = nfeval + output_aux.nfeval;
end

% Main loop
size_u_record = n_obj;
stop = false;
while ~stop
    problem_min_d.par_objfun.u_record = u_record;
    % "OUTER" LOOP: Compute dmin(i) = arg min {max f1(d,ue1), max f2(d,ue2)}
    [dmin, f_outer, ~ , output_aux] = algo_outer.optimise(problem_min_d,algo_outer.par);

    nfeval = nfeval + (output_aux.nfeval+(n_obj>1))*(~lsflag_outer + lsflag_outer*20*problem_minmax.dim_u)*size_u_record; 
    % NOTE: the +1 is empirical
    % NOTE: 50*dim_u is hardcoded nfevalmax in local search but is too conservative and overestimates nfeval hence 20.
    
    dmin(dmin < 0) = 0;
    dmin(dmin > 1) = 1;

    
    % Remove solutions archived more than once (if any)
    [dmin,idx] = unique(dmin,'rows');
    f_outer = f_outer(idx,:);
    
    % "INNER" LOOP: Compute ue(i+1) = arg max f(dmin(i),u)
    for i = 1:size(dmin,1)
        problem_max_u.par_objfun.d = dmin(i,:);
        for obj = 1:n_obj
            problem_max_u.par_objfun.objective = obj;
            % Maximize subproblem to find umax = arg max f(dmin(i),u)
            [ umax, f_inner , ~ , output_aux] = algo_inner.optimise(problem_max_u,algo_inner.par);
            nfeval = nfeval + output_aux.nfeval;
            umax(umax < 0) = 0;
            umax(umax > 1) = 1;
            f_inner = -sign_inner*f_inner;
            
            % Archive best between umax and umax2 [in case IDEA failed]
            if sign_inner*f_inner > sign_inner*f_outer(i,obj)
                u_record{obj} = [u_record{obj}; umax];
                % If lsflag_inner = 0, the "else" step wastes evaluations and is
                % useless: It finds and archives a u that is already in the
                % archive, and is removed by the "unique" at line 96.
            else
                if lsflag_inner
                    % Evaluate subproblem to find umax2 = arg max f(dmin(i),ua)
                    [~,umax2,nfeval2] = u_validation(problem_max_u, dmin(i,:), u_record, lsflag_inner, obj);
                    nfeval = nfeval + nfeval2;
                    u_record{obj} = [u_record{obj}; umax2{obj}];
                end
            end
        end
    end
    
    % Archive dmin
    d_record = [d_record; dmin];
    
    % Remove solutions archived more than once (if any)
    d_record = unique(d_record,'rows');
    for obj = 1:n_obj
        u_record{obj} = unique(u_record{obj},'rows');
    end
    
    size_u_record = sum(cellfun('size',u_record,1));
    nfeval_loop = nfevalmax - size_u_record*size(d_record,1)*(~lsflag_validation + lsflag_validation*20*problem_minmax.dim_u);
    % NOTE: 50*dim_u is hardcoded nfevalmax in local search but is too conservative and overestimates nfeval_val hence 20.

    
    stop = nfeval >= nfeval_loop;
end

% Refine solutions that maximize the objectives. This step also associates a u vector to each d vector
[ fval, u_record, nfeval_val] = u_validation(problem_max_u, d_record, u_record, lsflag_validation, 1:n_obj);
nfeval = nfeval + nfeval_val;

%% Select non-dominated solutions and define outputs
sel = dominance(fval,0) == 0;

fval = fval(sel,:);
frontsize = size(fval,1);

d = d_record(sel,:).*repmat(problem_minmax.ub_d'-problem_minmax.lb_d',[frontsize,1]) + repmat(problem_minmax.lb_d',[frontsize,1]);
u = cell(1,n_obj);
for obj = 1:n_obj
    u_record{obj} = u_record{obj}(sel,:);
    map_info = problem_max_u.par_objfun.map_u_info{obj};
    for i = 1:frontsize
        u{obj}(i,:) = map_affine(u_record{obj}(i,:),map_info); %this can be easily vectorized
    end
end

output.u = u;
output.nfeval = nfeval;
exitflag = 0;

end

