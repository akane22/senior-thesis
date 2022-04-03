function revenues = fn_revnues(tau,L_0,theta,r,L_path)

Lvec = L_path(:,1+find(L_path(1,2:end)==L_0));

revenue_vec = tau.*Lvec.^theta;
pv_convert = ones(length(revenue_vec),1);
for i = 1:length(pv_convert)
    pv_convert(i) = 1/((1+r)^(i-1));
end

finite_revenues = pv_convert'*revenue_vec;

t = length(Lvec)-1;
infinite_revenues = revenue_vec(end)/(r*((1+r)^(t-1)));

revenues = finite_revenues + infinite_revenues;
