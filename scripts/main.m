tic
cd 'C:\Users\abkan\Documents\Senior Essay\Simulations\'
run scripts/start;

%% Parameters
beta = 0.9;
beta_G = 0.9;
theta = 0.5;
tol = 1e-3;
delta = 0.01;
num = 100;
alpha_dist  = makedist('Lognormal','mu',0,'sigma',1);
E = 0.1/(1-beta_G);

%% Equilibrium

% Determining S_0 as a function of tau using budget constraint
tau_grid = 0.2:0.05:0.9;
S_0_tau = zeros(length(tau_grid),1);
solving_S_0 = @(S_0) fn_solve_S_0(alpha_dist,S_0,tau_grid(1),beta,beta_G,theta,delta,E,num);
S_0_tau(1) = fzero(solving_S_0,0.03);
parfor i = 2:length(tau_grid)
    solving_S_0 = @(S_0) fn_solve_S_0(alpha_dist,S_0,tau_grid(i),beta,beta_G,theta,delta,E,num);
    S_0_tau(i) = fzero(solving_S_0,0.01*i+0.02);
end


% Approximating S_0(tau) with Chebychev polynomials
fspace = fundefn('cheb',5,0,1);
c = funfitxy(fspace,tau_grid',S_0_tau);
roots = @(tau) funeval(c,fspace,tau);
t_underbar = bisect(roots,0.01,0.5);
t_overbar = bisect(roots,0.5,0.99);

% Maximizing S_0
[maximin_tax,maximin_subsidy] = fn_solve_maximin(fspace,c);

% Maximizing utilitarian social welfare
social_welfare = @(tau) fn_solve_utilitarian(tau,fspace,c,alpha_dist,beta,beta_G,theta,delta,num);
tau_utilitarian = golden(social_welfare, 0.2,0.7);
S_0_utilitarian = funeval(c,fspace,tau_utilitarian);
sw_max = social_welfare(tau_utilitarian);

taus_plot = t_underbar:0.001:t_overbar;
S_0_plot = funeval(c,fspace,taus_plot');

revenues = S_0_plot./(1-beta_G) + E;
Y = revenues./taus_plot';

%% Simulation for median alpha
delta = 0.001;
[~,V_util,pi_util,L_path_util,c_path_util] = fn_VFI(S_0_utilitarian,tau_utilitarian,beta,theta,tol,delta);
[L_grid,V_maximin,pi_maximin,L_path_maximin,c_path_maximin] = fn_VFI(maximin_subsidy,maximin_tax,beta,theta,tol,delta);

time_periods = min(size(L_path_util,1),size(L_path_maximin,1));
L_path_util = L_path_util(1:time_periods,:);
L_path_maximin = L_path_maximin(1:time_periods,:);
c_path_util = c_path_util(1:time_periods,:);
c_path_maximin = c_path_maximin(1:time_periods,:);

t_grid = L_path_util(:,1);
pts = round(linspace(5,size(L_path_util,2),5));
pts = pts(1:2);


%% Plots
% Individual
fig_valfun_and_policy_fun(L_grid,V_util,V_maximin,pi_util(:,2),pi_maximin(:,2),t_grid,c_path_util(:,pts),c_path_maximin(:,pts),...
    L_path_util(:,pts),L_path_maximin(:,pts),beta,theta,delta,tau_utilitarian,S_0_utilitarian,maximin_tax,maximin_subsidy,optfig)

% Subsidy and revenues
fig_S_0_tau(taus_plot,S_0_plot,Y,t_underbar,t_overbar,optfig)

%% Results
fprintf('tau_star_util  = %0.3f, S_0_util = %0.3f\n', tau_utilitarian,S_0_utilitarian)
fprintf('tau_star_maximin = %0.3f, S_0_maximin = %0.3f\n', maximin_tax,maximin_subsidy)
fprintf('minimum feasible tax = %0.3f, maximimum feasible tax = %0.3f\n', t_underbar,t_overbar)

toc
