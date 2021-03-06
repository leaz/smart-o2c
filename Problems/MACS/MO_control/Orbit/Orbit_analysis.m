% This Source Code Form is subject to the terms of the Mozilla Public
% License, v. 2.0. If a copy of the MPL was not distributed with this
% file, You can obtain one at http://mozilla.org/MPL/2.0/. */
%
%------ Copyright (C) 2018 University of Strathclyde and Authors ------
%--------------- e-mail: smart@strath.ac.uk ---------------------------
%------------------- Authors: SMART developers team -------------------
close all
clear all
clc

%% load files

load('mem_50k_e-7tol.mat')

mm = [];

for i=1:30
    
    mm = [mm;mem(i).memory];
    
end

clear mem

%% extract non dominated front

dom=dominance(mm(:,end-3:end-2),0);
nondom = mm(dom==0,:);

%% select 5 uniformly distributed points

mins = min(nondom(:,end-3:end-2));
maxs = max(nondom(:,end-3:end-2));

[selection,dd,energy,ener2,mins,maxs]=arch_shrk6([],[],nondom(1:10,:),0,[],mins,maxs,size(nondom,2)-4,2,10);
[selection,dd,energy,ener2,mins,maxs]=arch_shrk6(selection,dd,nondom(11:end,:),energy,ener2,mins,maxs,size(nondom,2)-4,2,10);

%% sort chosen points

[~,b] = sort(selection(:,end-2));

qq = selection(b,:);    %sort wrt t_f

%% Plot Pareto front

% Change default axes fonts.
% set(0,'DefaultAxesFontName', 'Times New Roman')
% set(0,'DefaultAxesFontSize', 10)
% set(0,'DefaultTextFontname', 'Times New Roman')
% set(0,'DefaultTextFontSize', 10)

plot(nondom(:,end-3),nondom(:,end-2),'b.')
box on
set(gca,'LooseInset',get(gca,'TightInset'));
hold on
plot(qq(:,end-3),qq(:,end-2),'r+','MarkerSize', 10)
xlabel('t_f')
ylabel('-E(t_f)')
text(qq(1,end-3)-1,qq(1,end-2)+0.01,'1')
text(qq(2,end-3)+1,qq(2,end-2)+0.01,'2')
text(qq(3,end-3)+1,qq(3,end-2)+0.01,'3')
text(qq(4,end-3)+1,qq(4,end-2)+0.01,'4')
text(qq(5,end-3)+1,qq(5,end-2)+0.01,'5')
text(qq(6,end-3)+1,qq(6,end-2)+0.01,'6')
text(qq(7,end-3)+1,qq(7,end-2)+0.01,'7')
text(qq(8,end-3)+1,qq(8,end-2)+0.01,'8')
text(qq(9,end-3)+1,qq(9,end-2)+0.01,'9')
text(qq(10,end-3)+1,qq(10,end-2)+0.01,'10')

%% Compute metrics wrt Pareto front

nonnorm = (nondom(:,end-3:end-2)-repmat(min(nondom(:,end-3:end-2)),size(nondom,1),1));%./repmat(max(nondom(:,end-3:end-2)),size(nondom,1),1);
nonnorm = nonnorm./repmat(max(nonnorm(:,1:2)),size(nonnorm,1),1);

%fp = nondom(:,end-3:end-2);
fp = nonnorm;
xp = nondom(:,1:end-4);

M1 = zeros(30,1);
M4 = M1;
AveGDP = M1;
AveIGDP = M1;
AveHaus = M1;

weights = [1 1];

for j=1:30
        
    this = mm((j-1)*10+1:j*10,:);
    
    x = this(:,1:end-4);
    f = this(:,end-3:end-2);
    f = f-repmat(min(nondom(:,end-3:end-2)),size(f,1),1);
    f = f./repmat(max(nondom(:,end-3:end-2))-min(nondom(:,end-3:end-2)),size(f,1),1);
    
    [M1(j),~,~,M4(j)] = ZDTmetrics(x,f,xp,fp,0,weights);
	[AveIGDP(j),AveGDP(j),AveHaus(j)]=AveHausMetrics(x,f,xp,fp,inf);

end

M1mean = mean(M1);
M1var = var(M1);
M4mean = mean(M4);
M4var = var(M4);
AveIGDPmean = mean(AveIGDP);
AveIGDPvar = var(AveIGDP);
AveGDPmean = mean(AveGDP);
AveGDPvar = var(AveGDP);
AveHausmean = mean(AveHaus);
AveHausvar = var(AveHaus);

% %% DFET PROBLEM TRANSCRIPTION
% 
% % Equations, initial conditions and time span
% a=1e-2;
% f = @(x,u,t) [x(2); x(4)^2/x(1)-1/x(1)^2+a*cos(u(1)); x(4)/x(1); -x(2)*x(4)/x(1)+a*sin(u(1))];
% dfx = @(x,u,t) [0 1 0 0; -x(4)^2/x(1)^2+2/(x(1)^3) 0 0 2*x(4)/x(1); -x(4)/(x(1)^2) 0 0 1/x(1); x(2)*x(4)/(x(1)^2) -x(4)/x(1) 0 -x(2)/x(1)];
% dfu = @(x,u,t) [0; -a*sin(u(1)); 0; a*cos(u(1))];
% dft = @(x,u,t) [0; 0; 0; 0];
% 
% t_0 = 0;
% 
% x_0 = [1.1 0 0 1/(1.1)^0.5];
% 
% imposed_final_states = [0 0 0 0];   % mask vector with the variables on which a final condition is imposed
% x_f = [0 0 0 0];                % vector of final conditions (size???)
% 
% % Discretisation settings
% 
% num_elems = 30;
% state_order = 1;
% control_order = 1;
% DFET = 1;
% state_distrib = 'Lobatto'; % or Cheby
% control_distrib = 'Legendre';
% 
% integr_order = 2*state_order;%2*state_order-1;
% 
% num_eqs = length(x_0);
% num_controls = 1;
% 
% % Make checks
% 
% test_order = state_order+(DFET==1);
% 
% if DFET==0
%     
%     total_num_equations = num_elems*(test_order+1)*num_eqs+sum(imposed_final_states);
%     total_num_unknowns = num_elems*(state_order+1)*num_eqs+num_elems*(control_order+1)*num_controls;
%     
% else
%     
%     total_num_equations = ((test_order+1)+(test_order)*(num_elems-1))*num_eqs;
%     total_num_unknowns = ((test_order)*num_elems)*num_eqs+num_elems*(control_order+1)*num_controls+sum(imposed_final_states==0);
%     
% end
% 
% if total_num_equations>total_num_unknowns
%     
%     error('Problem is over-constrained: either reduce number of final constraints, increase number of control variables, use higher order polynomials for control variables, or use more elements');
%     
% end
% 
% if total_num_equations==total_num_unknowns
%     
%     warning('Number of constraints equal to number of unknown control coefficients: optimal control is not possible, only constraints satisfaction');
%     
% end
% 
% % Transcribe constraints
% 
% structure = prepare_transcription(num_eqs,num_controls,num_elems,state_order,control_order,integr_order,DFET,state_distrib,control_distrib);
% 
% structure = impose_final_conditions(structure,imposed_final_states);
% 
% state_bounds = [0 inf;-inf inf; -inf inf;-inf inf];
% control_bounds = [-pi pi];
% 
% [vlb,vub] = transcribe_bounds(state_bounds,control_bounds,structure);
% 
% vlb = [20;vlb]';
% vub = [80;vub]';
% 
% %% plot trajectories
% 
% figure(2)
% box on
% set(gca,'LooseInset',get(gca,'TightInset'));
% ht = {};
% 
% for i = 1:size(qq,1)
%     
%     [x,u,xb] = extract_solution(qq(i,2:length(vlb)),structure,x_f);
%     tplot = linspace(t_0,qq(i,1),100);
%     [xt,ut] = eval_solution_over_time(x,u,t_0,qq(i,1),tplot,structure);
%     ht{i} = plot(xt(:,1).*cos(xt(:,3)),xt(:,1).*sin(xt(:,3)));
%     hold on
%     plot(xt(end,1).*cos(xt(end,3)),xt(end,1).*sin(xt(end,3)),'bx','MarkerSize',10);
%     
% end
% axis equal
% xlabel('x');
% ylabel('y');
% legend([ht{1},ht{2},ht{3},ht{4}],'Trajectory 1','Trajectory 2','Trajectory 3','Trajectory 4','Location','SouthWest')
% 
% %% plot velocities and control laws
% 
% hs = {};
% hc = {};
% for i = 1:size(qq,1)
%     
%     [x,u,xb] = extract_solution(qq(i,2:length(vlb)),structure,x_f);
%     tplot = linspace(t_0,qq(i,1),100);
%     [xt,ut] = eval_solution_over_time(x,u,t_0,qq(i,1),tplot,structure);
%     
%     [hs{i},hc{i}] = plot_solution_vs_time2(x,u,x_0,xb,t_0,qq(i,1),structure,2*i+1);
%     figure(2*i+1)
%     clf
%     plot(tplot,xt(:,2),'b')
%     box on
%     set(gca,'LooseInset',get(gca,'TightInset'));
%     hold on
%     plot(tplot,xt(:,4),'b--')
%     axis([0 250 0 1])
%     xlabel('t')
%     ylabel('velocities')
%     legend('v_x','v_y')
%     figure(2*i+2)
%     box on
%     set(gca,'LooseInset',get(gca,'TightInset'));
%     axis([0 80 0 pi])
%     xlabel('t')
%     ylabel('controls')
%     drawnow
%     
% end 
% 
% %% compare extreme points with single objective solutions
% 
% % figure(3)
% % clf
% % [x,u,xb] = extract_solution(qq(1,2:length(vlb)),structure,x_f);
% % tplot = linspace(t_0,qq(1,1),10);
% % [xt,ut] = eval_solution_over_time(x,u,t_0,qq(1,1),tplot,structure);
% % plot(tplot,xt(:,2),'bo')
% % box on
% % set(gca,'LooseInset',get(gca,'TightInset'));
% % hold on
% % plot(tplot,xt(:,4),'b*')
% % axis tight
% % tplot = linspace(t_0,qq(1,1),100);
% % load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Ascent\min_time_states.mat')
% % load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Ascent\min_time_controls.mat')
% % plot(tplot,xt(:,2),'b')
% % plot(tplot,xt(:,4),'b--')
% % xlabel('t')
% % ylabel('velocities')
% % legend('v_x(MACS)','v_y(MACS)','v_x(single_obj)','v_y(single_obj)')
% % axis tight
% 
% figure(4)
% tplot = linspace(t_0,qq(1,1),100);
% load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Orbit\min_time_states.mat')
% load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Orbit\min_time_controls.mat')
% plot(tplot,ut,'b')
% xlabel('t')
% ylabel('controls')
% legend('u(MACS)','u(single obj)')
% 
% % figure(11)
% % clf
% % [x,u,xb] = extract_solution(qq(end,2:length(vlb)),structure,x_f);
% % tplot = linspace(t_0,qq(end,1),10);
% % [xt,ut] = eval_solution_over_time(x,u,t_0,qq(end,1),tplot,structure);
% % plot(tplot,xt(:,2),'bo')
% % box on
% % set(gca,'LooseInset',get(gca,'TightInset'));
% % hold on
% % plot(tplot,xt(:,4),'b*')
% % axis ([0 250 0 1])
% % tplot = linspace(t_0,qq(end,1),100);
% % load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Ascent\max_vel_states.mat')
% % load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Ascent\max_vel_controls.mat')
% % plot(tplot,xt(:,2),'b')
% % plot(tplot,xt(:,4),'b--')
% % xlabel('t')
% % ylabel('velocities')
% % legend('v_x(MACS)','v_y(MACS)','v_x(single_obj)','v_y(single_obj)','Location','East')
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
% load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Orbit\max_energy_states.mat')
% load('C:\Users\LA\Desktop\code\people\WORKING\MO_control\Orbit\max_energy_controls.mat')
% hnew = plot(tplot,ut,'b--');
% xlabel('t')
% ylabel('controls')
% legend([hc{end}(1),hnew],'u(MACS)','u(single obj)')
