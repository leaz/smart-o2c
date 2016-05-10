close all
clear all
clc

%% DFET PROBLEM TRANSCRIPTION

% Equations, initial conditions and time span
a=4e-3;
f = @(x,u,t) [x(2); a*cos(x(5)); x(4); -0.0016+a*sin(x(5)); u(1)];
dfx = @(x,u,t) [0 1 0 0 0; 0 0 0 0 -a*sin(x(5)); 0 0 0 1 0; 0 0 0 0 a*cos(x(5)); 0 0 0 0 0];
dfu = @(x,u,t) [0; 0; 0; 0; 1];
dft = @(x,u,t) [0; 0; 0; 0; 0];

t_0 = 0;

x_0 = [0 0 0 0 0];

imposed_final_states = [0 0 1 1 0];   % mask vector with the variables on which a final condition is imposed
x_f = [0 0.1 10 0 0];                % vector of final conditions (size???)

% Discretisation settings

num_elems = 4;
state_order = 6;
control_order = 5;
DFET = 1;
state_distrib = 'Lobatto'; % or Cheby
control_distrib = 'Legendre';

integr_order = 2*state_order;%2*state_order-1;

num_eqs = length(x_0);
num_controls = 1;

% Make checks

test_order = state_order+(DFET==1);

if DFET==0

    total_num_equations = num_elems*(test_order+1)*num_eqs+sum(imposed_final_states);
    total_num_unknowns = num_elems*(state_order+1)*num_eqs+num_elems*(control_order+1)*num_controls;

else
   
    total_num_equations = ((test_order+1)+(test_order)*(num_elems-1))*num_eqs;
    total_num_unknowns = ((test_order)*num_elems)*num_eqs+num_elems*(control_order+1)*num_controls+sum(imposed_final_states==0);
    
end

if total_num_equations>total_num_unknowns
    
    error('Problem is over-constrained: either reduce number of final constraints, increase number of control variables, use higher order polynomials for control variables, or use more elements');
    
end

if total_num_equations==total_num_unknowns
    
    warning('Number of constraints equal to number of unknown control coefficients: optimal control is not possible, only constraints satisfaction');
    
end

% Transcribe constraints

structure = prepare_transcription(num_eqs,num_controls,num_elems,state_order,control_order,integr_order,DFET,state_distrib,control_distrib);

structure = impose_final_conditions(structure,imposed_final_states);

state_bounds = [-inf inf;-inf inf; -inf inf;-inf inf; -pi/2 pi/2];
control_bounds = [-10*pi 10*pi];

[vlb,vub] = transcribe_bounds(state_bounds,control_bounds,structure);

vlb = [100;-pi/2;vlb]';
vub = [250;pi/2;vub]';

tol_conv = 1e-6;
maxits = 10000;

fminconoptions = optimset('Display','off','MaxFunEvals',maxits,'Tolcon',tol_conv,'GradCon','on');

%% MACS PARAMETERS

opt.maxnfeval=10000;                                                       % maximum number of f evals 
opt.popsize=10;                                                             % popsize (for each archive)
opt.rhoini=1;                                                               % initial span of each local hypercube (1=full domain)
opt.F=0.9;                                                                    % F, the parameter for Differential Evolution
opt.CR=0.9;                                                                   % CR, crossover probability
opt.p_social=1;                                                           % popratio
opt.max_arch=10;                                                            % archive size
opt.coord_ratio=1;%/(sum(~isinf(vlb)));                                               
opt.contr_ratio=0.5;                                                        % contraction ratio
opt.draw_flag=0;                                                            % draw flag
opt.cp=0;                                                                   % constraints yes/no 
opt.MBHflag=0;                                                              % number of MBH steps
opt.cpat=0;                                                                 % pattern to DE
opt.explore_DE_strategy = 'rand';                                           % DE for exploring agents should pull towards the element with the best objective function value
opt.social_DE_strategy ='DE/current-to-rand/1';                             % DE for social agents
opt.explore_all = 1;                                                        % all agents should perform local search
opt.v = 1;
opt.int_arch_mult=1;
opt.dyn_pat_search = 1;
opt.upd_subproblems = 0;
opt.max_rho_contr = 5;
opt.pat_search_strategy = 'standard';
opt.optimal_control = 1;
opt.vars_to_opt = zeros(1,length(vub));
opt.vars_to_opt(1:2) = 1;
opt.vars_to_opt(38:41:end) = 1;
opt.vars_to_opt(39:41:end) = 1;
opt.vars_to_opt(40:41:end) = 1;
opt.vars_to_opt(41:41:end) = 1;
opt.vars_to_opt(42:41:end) = 1;
opt.vars_to_opt(43:41:end) = 1;
opt.oc.structure = structure;
opt.oc.f = f;
opt.oc.dfx = dfx;
opt.oc.dfu = dfu;
opt.oc.init_type = 'copy_ic';
opt.oc.init_cond = x_0;
opt.oc.state_vars = ~(opt.vars_to_opt);
opt.oc.control_vars = opt.vars_to_opt;
opt.oc.control_vars(1:2) = 0;

%% OPTIMISATION LOOP

for i=1:1
    
    memory=macs7v16OC(@fastest_climb_MACS_MOO_test,[],vlb,vub,opt,[],[],vlb,vub,f,structure,x_0,x_f,dfx,dfu,dft,fminconoptions);    
    
end

%% plot 

[~,b] = sort(memory(:,length(vlb)+1));

qq = memory(b,:);    %sort wrt t_f

for i = 10:10%size(qq,1)
    
    [x,u,xb] = extract_solution(qq(i,3:length(vlb)),structure,x_f);
    x_02 = x_0;
    x_02(end) = qq(i,2);
    plot_solution_vs_time(x,u,x_02,xb,t_0,qq(i,1),structure,i+1)
    subplot(2,1,1)
    axis([0 250 0 120])
    subplot(2,1,2)
    axis([0 250 -pi pi])
    drawnow
    
end
