function out = fn_policyfun(vec,pi,delta)

lo = floor(vec./delta)+1;
hi = lo+1;
out = pi(lo,2) + (vec-pi(lo,1)).*(pi(hi,2) - pi(lo,2))./(pi(hi,1)-pi(lo,1));

