close all
clear all
clc

%% load files

load('C:\Users\LA\Dropbox\MACS+DFET\WORKING\MO_control\Ascent\Drag\50k_funeval.mat')
    
mm = mem.memory;

%% extract non dominated front

dom=dominance(mm(:,end-3:end-2),0);
nondom = mm(dom==0,:);

%% select 5 uniformly distributed points

mins = min(nondom(:,end-3:end-2));
maxs = max(nondom(:,end-3:end-2));

[selection,dd,energy,ener2,mins,maxs]=arch_shrk6([],[],nondom(1:4,:),0,[],mins,maxs,size(nondom,2)-4,2,4);
[selection,dd,energy,ener2,mins,maxs]=arch_shrk6(selection,dd,nondom(5:end,:),energy,ener2,mins,maxs,size(nondom,2)-4,2,4);

%% sort chosen points

[~,b] = sort(selection(:,end-3));
 
qq = selection(b,:);    %sort wrt t_f

%% Plot Pareto front

% Change default axes fonts.
set(0,'DefaultAxesFontName', 'Times New Roman')
set(0,'DefaultAxesFontSize', 10)
set(0,'DefaultTextFontname', 'Times New Roman')
set(0,'DefaultTextFontSize', 10)

plot(nondom(:,end-3),nondom(:,end-2),'b.')
box on
set(gca,'LooseInset',get(gca,'TightInset')); 
hold on
plot(qq(:,end-3),qq(:,end-2),'r+','MarkerSize', 20)
xlabel('t_f')
ylabel('-v_x(t_f)')
text(qq(1,end-3)+2,qq(1,end-2)-0.02,'1')
text(qq(2,end-3)+2,qq(2,end-2)+0.02,'2')
text(qq(3,end-3)+2,qq(3,end-2)+0.02,'3')
text(qq(4,end-3),qq(4,end-2)+0.02,'4')
%text(qq(5,end-3),qq(5,end-2)+0.02,'5')

%% Compute metrics wrt Pareto front

% nonnorm = (nondom(:,end-3:end-2)-repmat(min(nondom(:,end-3:end-2)),size(nondom,1),1));%./repmat(max(nondom(:,end-3:end-2)),size(nondom,1),1);
% nonnorm = nonnorm./repmat(max(nonnorm(:,1:2)),size(nonnorm,1),1);
% 
% %fp = nondom(:,end-3:end-2);
% fp = nonnorm;
% xp = nondom(:,1:end-4);
% 
% M1 = zeros(30,1);
% M4 = M1;
% AveGDP = M1;
% AveIGDP = M1;
% AveHaus = M1;
% 
% weights = [1 1];
% 
% for j=1:30
%         
%     this = mm((j-1)*10+1:j*10,:);
%     
%     x = this(:,1:end-4);
%     f = this(:,end-3:end-2);
%     f = f-repmat(min(nondom(:,end-3:end-2)),size(f,1),1);
%     f = f./repmat(max(nondom(:,end-3:end-2))-min(nondom(:,end-3:end-2)),size(f,1),1);
%     
%     [M1(j),~,~,M4(j)] = ZDTmetrics(x,f,xp,fp,0,weights);
% 	[AveIGDP(j),AveGDP(j),AveHaus(j)]=AveHausMetrics(x,f,xp,fp,inf);
% 
% end
% 
% M1mean = mean(M1);
% M1var = var(M1);
% M4mean = mean(M4);
% M4var = var(M4);
% AveIGDPmean = mean(AveIGDP);
% AveIGDPvar = var(AveIGDP);
% AveGDPmean = mean(AveGDP);
% AveGDPvar = var(AveGDP);
% AveHausmean = mean(AveHaus);
% AveHausvar = var(AveHaus);

%% DFET PROBLEM TRANSCRIPTION

% Equations, initial conditions and time span
g = 0.0016; 
T = 4e-3;
rho0 = 0.1;
S = 1;
Cd = 1;
c = 1.5;
f = @(x,u,t) [x(2); (T*cos((u(1)))-0.5*rho0*exp(-x(3))*S*Cd*(x(2).^2+x(4).^2).^(0.5)*x(2))/x(5); x(4); (T*sin((u(1)))-0.5*rho0*exp(-x(3))*S*Cd*(x(2).^2+x(4).^2).^(0.5)*x(4))/x(5)-g; -T/c];

%dfx = @(x,u,t) [0 1 0 0; 0 0 0 0; 0 0 0 1; 0 0 0 0];
%dfu = @(x,u,t) [0; -a*sin(u(1)); 0; a*cos(u(1))];
%dft = @(x,u,t) [0; 0; 0; 0];

t_0 = 0;

x_0 = [0 0 0 0 1];

imposed_final_states = [0 0 1 1 0];   % mask vector with the variables on which a final condition is imposed
x_f = [0 0.1 10 0 0];                % vector of final conditions (size???)

% Discretisation settings

num_elems = 4;
state_order = 6;
control_order = 6;
DFET = 1;
state_distrib = 'Lobatto'; % or Cheby
control_distrib = 'Legendre';

integr_order = 2*state_order;%2*state_order-1;

num_eqs = length(x_0);
num_controls = 1;

structure = prepare_transcription(num_eqs,num_controls,num_elems,state_order,control_order,integr_order,DFET,state_distrib,control_distrib);

structure = impose_final_conditions(structure,imposed_final_states);

state_bounds = [-inf inf;-inf inf; -inf inf;-inf inf; 0 inf];
control_bounds = [-pi/2 pi/2];

[vlb,vub] = transcribe_bounds(state_bounds,control_bounds,structure);

vlb = [100;vlb]';
vub = [250;vub]';

% tol_conv = 1e-6;
% maxits = 10000;
% 
% fminconoptions = optimset('Display','off','MaxFunEvals',maxits,'Tolcon',tol_conv,'GradCon','on');

%% plot trajectories

figure(2)
box on
set(gca,'LooseInset',get(gca,'TightInset')); 

for i = 1:size(qq,1)
    
    [x,u,xb] = extract_solution(qq(i,2:length(vlb)),structure,x_f);
    tplot = linspace(t_0,qq(i,1),100);
    [xt,ut] = eval_solution_over_time(x,u,t_0,qq(i,1),tplot,structure);
    plot(xt(:,1),xt(:,3))
    hold on
end
xlabel('x');
ylabel('y');
legend('Trajectory 1','Trajectory 2','Trajectory 3','Trajectory 4','Location','East')

%% plot velocities and control laws
hs = {};
hc = {};
for i = 1:size(qq,1)
    
    [x,u,xb] = extract_solution(qq(i,2:length(vlb)),structure,x_f);
	tplot = linspace(t_0,qq(i,1),100);
    [xt,ut] = eval_solution_over_time(x,u,t_0,qq(i,1),tplot,structure);

    [hs{i},hc{i}] = plot_solution_vs_time2(x,u,x_0,xb,t_0,qq(i,1),structure,2*i+1);
    figure(2*i+1)
    clf
    plot(tplot,xt(:,2),'b')
    box on
    set(gca,'LooseInset',get(gca,'TightInset')); 
    hold on
    plot(tplot,xt(:,4),'b--')
    axis([0 250 0 1])
    xlabel('t')
    ylabel('velocities')
    legend('v_x','v_y')
    figure(2*i+2)
    box on
    set(gca,'LooseInset',get(gca,'TightInset')); 
    axis([0 250 -pi pi])
    xlabel('t')
    ylabel('u')
    drawnow
    
end 

%% compare extreme points with single objective solutions

% figure(3)
% clf
% [x,u,xb] = extract_solution(qq(1,2:length(vlb)),structure,x_f);
% tplot = linspace(t_0,qq(1,1),10);
% [xt,ut] = eval_solution_over_time(x,u,t_0,qq(1,1),tplot,structure);
% plot(tplot,xt(:,2),'bo')
% box on
% set(gca,'LooseInset',get(gca,'TightInset')); 
% hold on
% plot(tplot,xt(:,4),'b*')
% axis tight
% tplot = linspace(t_0,qq(1,1),100);
% load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Ascent\min_time_states.mat')
% load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Ascent\min_time_controls.mat')
% plot(tplot,xt(:,2),'b')
% plot(tplot,xt(:,4),'b--')
% xlabel('t')
% ylabel('velocities')
% legend('v_x(MACS)','v_y(MACS)','v_x(single_obj)','v_y(single_obj)')
% axis tight
% 
% figure(4)
% clf
% [x,u,xb] = extract_solution(qq(1,2:length(vlb)),structure,x_f);
% tplot = linspace(t_0,qq(1,1),10);
% [xt,ut] = eval_solution_over_time(x,u,t_0,qq(1,1),tplot,structure);
% plot(tplot,ut,'b*')
% box on
% set(gca,'LooseInset',get(gca,'TightInset')); 
% hold on
% axis tight
% tplot = linspace(t_0,qq(1,1),100);
% load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Ascent\min_time_states.mat')
% load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Ascent\min_time_controls.mat')
% plot(tplot,ut,'b')
% xlabel('t')
% ylabel('controls')
% legend('u(MACS)','u(single obj)')
% axis tight
% 
% figure(9)
% clf
% [x,u,xb] = extract_solution(qq(end,2:length(vlb)),structure,x_f);
% tplot = linspace(t_0,qq(end,1),10);
% [xt,ut] = eval_solution_over_time(x,u,t_0,qq(end,1),tplot,structure);
% plot(tplot,xt(:,2),'bo')
% box on
% set(gca,'LooseInset',get(gca,'TightInset')); 
% hold on
% plot(tplot,xt(:,4),'b*')
% axis ([0 250 0 1])
% tplot = linspace(t_0,qq(end,1),100);
% load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Ascent\max_vel_states.mat')
% load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Ascent\max_vel_controls.mat')
% plot(tplot,xt(:,2),'b')
% plot(tplot,xt(:,4),'b--')
% xlabel('t')
% ylabel('velocities')
% legend('v_x(MACS)','v_y(MACS)','v_x(single_obj)','v_y(single_obj)','Location','East')
% 
% figure(10)
% % clf
% % [x,u,xb] = extract_solution(qq(end,2:length(vlb)),structure,x_f);
% % tplot = linspace(t_0,qq(end,1),10);
% % [xt,ut] = eval_solution_over_time(x,u,t_0,qq(end,1),tplot,structure);
% % plot(tplot,ut,'b*')
% % box on
% % set(gca,'LooseInset',get(gca,'TightInset')); 
% % hold on
% % axis ([0 250 -pi pi])
% tplot = linspace(t_0,qq(end,1),100);
% load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Ascent\max_vel_states.mat')
% load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Ascent\max_vel_controls.mat')
% hnew = plot(tplot,ut,'b--');
% xlabel('t')
% ylabel('controls')
% legend([hc{end}(1),hnew],'u(MACS)','u(single obj)')
