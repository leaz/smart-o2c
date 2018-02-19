% This Source Code Form is subject to the terms of the Mozilla Public
% License, v. 2.0. If a copy of the MPL was not distributed with this
% file, You can obtain one at http://mozilla.org/MPL/2.0/. */
%
%------ Copyright (C) 2018 University of Strathclyde and Authors ------
%--------------- e-mail: smart@strath.ac.uk ---------------------------
%------------------- Authors: SMART developers team -------------------
function [out] = TC_1(d, u, par)
%RECONSTRUCTIONNUMERICTESTCASE Summary of this function goes here
%   Detailed explanation goes here
f_1 = 10*u(1)^2 + abs(u(2))*u(5)^2 + u(6)^4/100 +d(1)*abs(d(2)); %+d(1)^2*abs(d(2));
f_2 = abs(u(3)) + u(4)^2*abs(u(5))/10 + u(6)^2 + abs(d(1));
out = f_1 + f_2;


global nfevalglobal;
nfevalglobal = nfevalglobal + 1;
end

