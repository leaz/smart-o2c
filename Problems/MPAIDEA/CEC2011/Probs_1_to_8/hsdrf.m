% This Source Code Form is subject to the terms of the Mozilla Public
% License, v. 2.0. If a copy of the MPL was not distributed with this
% file, You can obtain one at http://mozilla.org/MPL/2.0/. */
%
%------ Copyright (C) 2018 University of Strathclyde and Authors ------
%--------------- e-mail: smart@strath.ac.uk ---------------------------
%------------------- Authors: SMART developers team -------------------
% function f=hsdrf(pop11,pop22)
function f=hsdrf(pop)

ipp=pop(end,1);
iqq=pop(end,2);
pop11=pop(1:ipp,:);
pop22=pop(end-iqq-1:end-1,:);
[p11 w]=size(pop11);
[p22 w1]=size(pop22);
A=0;B=0;
for i=1:p11
    edis=squareform(pdist([pop11(i,:);pop22]));   
    ee=min(edis(2:end,1));
    A=A+ee;
end

for i=1:p22
    edis=squareform(pdist([pop22(i,:);pop11]));   
    ee=min(edis(2:end,1));
    B=B+ee;
end    
f=max(A,B);
