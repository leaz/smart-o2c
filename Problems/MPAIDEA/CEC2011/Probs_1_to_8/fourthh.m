% This Source Code Form is subject to the terms of the Mozilla Public
% License, v. 2.0. If a copy of the MPL was not distributed with this
% file, You can obtain one at http://mozilla.org/MPL/2.0/. */
%
%------ Copyright (C) 2018 University of Strathclyde and Authors ------
%--------------- e-mail: smart@strath.ac.uk ---------------------------
%------------------- Authors: SMART developers team -------------------
tol=1.0e-08;
tspan=[0 0.78];
yo =[ 0.09 0.09 ]';
u=2;
options = odeset('RelTol',tol);
[T,Y] = ode45(@(t,y) rigid(t,y,u),tspan,yo,options);
j=sum(sum(Y.^2,2)+(0.1)*u*u)
