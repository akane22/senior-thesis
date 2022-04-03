function sw = fn_solve_utilitarian(tau,fspace,c,alpha_dist,beta,beta_G,theta,delta,num)
S = @(tau) funeval(c,fspace,tau);

utility = @(alpha) fn_utility(alpha,S(tau),tau,beta,beta_G,theta,delta);

[x,w] = qnwlogn(num,alpha_dist.mu,alpha_dist.sigma);
ind = num-sum(x > 100); % solving for the value function is quite computationally intense for alpha > 100, and 1-F(100) = 2.06e-6, so this is still a very good approximation.
x = x(1:ind);
w = w(1:ind);
w = w/sum(w);
sw = 0;
parfor i = 1:length(x)
    sw = sw + w(i)*utility(x(i));
end
