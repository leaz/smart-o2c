function M = generate_fd1_deriv_ui(x0,u0,t0,xf,uf,tf,x,u,t,static,scales,constants,fun,h)

% This Source Code Form is subject to the terms of the Mozilla Public
% License, v. 2.0. If a copy of the MPL was not distributed with this
% file, You can obtain one at http://mozilla.org/MPL/2.0/. */
%
%------ Copyright (C) 2017 University of Strathclyde and Authors ------
%--------------- e-mail: lorenzo.ricciardi@strath.ac.uk----------------
%-------------------- Author: Lorenzo A. Ricciardi --------------------
%
% Auto generate forward finite difference approximation of the jacobian of 
% the definite integral over time of a given function wrt to controls u. 
% First order accuracy.

dx0 = fun(x0,u0,t0,xf,uf,tf,x,u,t,static,scales,constants);
dx0 = dx0(:,2);

M = zeros(length(dx0),length(u));

for jj = 1:length(u)
   
    u_temp = u;
    u_temp(jj) = u_temp(jj)+h;
  
    dutemp = fun(x0,u0,t0,xf,uf,tf,x,u_temp,t,static,scales,constants);
    dutemp = dutemp(:,2);
  
    M(:,jj) = (dutemp-dx0)/h;
    
end

end