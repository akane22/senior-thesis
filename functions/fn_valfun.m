function x = fn_valfun(L,Lvec,beta,L0,theta,tau,S_0,V)

Lbelow = max(sum(L>Lvec),1);
Labove = Lbelow+1;

interp = V(Lbelow) + (L-Lvec(Lbelow))*(V(Labove) - V(Lbelow))/(Lvec(Labove)-Lvec(Lbelow));


c = (1-tau)*L0^theta + S_0 - L;

if c <= 0
    x = -1e16;
else 
    x = log(c) + beta*interp;
end

x=-x;



