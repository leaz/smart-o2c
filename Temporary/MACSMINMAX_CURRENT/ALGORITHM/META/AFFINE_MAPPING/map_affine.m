function x_true = map_affine(x,map_info)
% assumes that the search space is the cartesian product of the intervals provided
% needs to be reimplemented for correlated variables to "prune out products"
% (e.g. include [1,2]x[1,2]U[3,4]x[3,4] but exclude [1,2]x[3,4])

dim=length(x);
x_aux = x;
lb = zeros(1,dim);
for d = 1:dim
    for int = 1:map_info.n_int{d}
        if (x(d)<=map_info.interval_indicator{d}(int))
            lb(d) = map_info.lb{d}(int);
            if (int>1)
                x_aux(d) = x(d) - map_info.interval_indicator{d}(int-1);
            end
            break
        end
    end
end

x_true = lb + x_aux.*map_info.scale;


return
