% Downloaded from:
% http://web.mysites.ntu.edu.sg/epnsugan/PublicSite/Shared%20Documents/Forms/AllItems.aspx?RootFolder=%2fepnsugan%2fPublicSite%2fShared%20Documents%2fCEC%202011%2d%20RWP&FolderCTID=&View=%7bDAF31868%2d97D8%2d4779%2dAE49%2d9CEC4DC3F310%7d

clear all;
clc
format long e;
x =ones(30,2);
global initial_flag;
for i=1:28
   i 
   initial_flag = 0;
   [f,g,h]=CEC2017(x',i)
end
