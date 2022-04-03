function[revenues,Lvec,vi, utility] = fn_VFI_3(alpha,S_0,tau,beta,beta_G,theta,delta)

if alpha < 0.002
    alpha_2 = 0;
else 
    alpha_2 = alpha;
end
solve_Lbar = @(L) ((1-tau).*alpha_2.^(1-theta).*L.^theta + S_0 - L);
Lbar = bisect(solve_Lbar,0,max(alpha_2,10));
ss_no_gov = alpha_2*(beta*theta)^(1/(1-theta));
L_0 = round((1/delta*ss_no_gov))*delta;
maxL = max(max(Lbar,1),L_0);
maxL = maxL*1.5;
if floor((0:delta:maxL)/250) > 2
    delta = delta*floor((0:delta:maxL)/250);
end
if S_0 > 0
    Lvec = 0:delta:maxL;
else 
    Lvec = delta:delta:maxL;
end

Lvec = round((1/delta).*Lvec).*delta;
n = length(Lvec);
X = Lvec;
m = length(X);
f = zeros(n,m);
for i = 1:m
    c = (1-tau).*alpha_2.^(1-theta).*Lvec.^(theta)+ S_0 -X(i);
    c(c<0) = 0;
    f(:,i) = log(c);
end
g = zeros(n,m);
for i = 1:m
    g(:,i) = i;
end
model.reward = f;
model.transfunc = g;
model.horizon = inf;
model.discount = beta;
[vi,xi,~] = ddpsolve(model);
pi = [Lvec; Lvec(xi)]';
utility = vi(Lvec == L_0);

L_path = pi(pi(:,1)==L_0,:);
i=3;
dif = 1;
tol = 1e-3;
while dif > tol^2
    L_path(i) = pi(find(pi(:,1)==L_path(i-1)),2);
    dif = abs(L_path(i)-L_path(i-1));
    i=i+1;
end

revenue_vec = tau.*alpha_2.^(1-theta).*L_path'.^theta;
pv_convert = ones(length(revenue_vec),1);
for i = 1:length(pv_convert)
    pv_convert(i) = beta_G^(i-1);
end

finite_revenues = pv_convert'*revenue_vec;

t = length(L_path)-1;
infinite_revenues = revenue_vec(end)*(beta_G^t/(1-beta_G));

revenues = finite_revenues + infinite_revenues;
