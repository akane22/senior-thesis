function [tau_star,S_star] = fn_solve_maximin(fspace,c)
S = @(t) funeval(c,fspace,t,1);
tau_star = bisect(S,0,1);

S_star = funeval(c,fspace,tau_star);