% This Source Code Form is subject to the terms of the Mozilla Public
% License, v. 2.0. If a copy of the MPL was not distributed with this
% file, You can obtain one at http://mozilla.org/MPL/2.0/. */
%
%------ Copyright (C) 2018 University of Strathclyde and Authors ------
%--------------- e-mail: smart@strath.ac.uk ---------------------------
%------------------- Authors: SMART developers team -------------------
function [ub,lb]=getlimit_messenger()
% n=20;
a(1,1)=1900;b(1,1)=2300;
a(1,2)=2.5;b(1,2)=4.05;
a(1,3)=0;b(1,3)=1;
a(1,4)=0;b(1,4)=1;
a(1,5)=100;b(1,5)=500;
a(1,6)=100;b(1,6)=500;
a(1,7)=100;b(1,7)=500;
a(1,8)=100;b(1,8)=500;
a(1,9)=100;b(1,9)=500;
a(1,10)=100;b(1,10)=600;
a(1,11)=0.01;b(1,11)=0.99;
a(1,12)=0.01;b(1,12)=0.99;
a(1,13)=0.01;b(1,13)=0.99;
a(1,14)=0.01;b(1,14)=0.99;
a(1,15)=0.01;b(1,15)=0.99;
a(1,16)=0.01;b(1,16)=0.99;
a(1,17)=1.1;b(1,17)=6;
a(1,18)=1.1;b(1,18)=6;
a(1,19)=1.05;b(1,19)=6;
a(1,20)=1.05;b(1,20)=6;
a(1,21)=1.05;b(1,21)=6;
a(1,22)=-pi;b(1,22)=pi;
a(1,23)=-pi;b(1,23)=pi;
a(1,24)=-pi;b(1,24)=pi;
a(1,25)=-pi;b(1,25)=pi;
a(1,26)=-pi;b(1,26)=pi;

ub=b;
lb=a;
% for i=1:n
%     ub(i,:)=b(1,:);
%     lb(i,:)=a(1,:);
% end
% ub


