function dif = fn_solve_S_0(alpha_dist,S_0,tau,beta,beta_G,theta,delta,E,num)

revenues = @(alpha) fn_VFI_3(alpha,S_0,tau,beta,beta_G,theta,delta);
[x,w] = qnwlogn(num,alpha_dist.mu,alpha_dist.sigma);
ind = num-sum(x > 100);
x = x(1:ind);
w = w(1:ind);
w = w/sum(w);
tot = 0;
parfor i = 1:length(x)
    tot = tot + w(i)*revenues(x(i));
end
dif = tot - S_0/(1-beta_G)-E;
