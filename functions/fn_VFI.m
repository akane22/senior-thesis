function[Lvec,V,pi, L_path, c_path] = fn_VFI(S_0,tau,beta,theta,tol,delta)

solve_Lbar = @(L) ((1-tau).*L.^theta + S_0 - L);
Lbar = bisect(solve_Lbar,0,max(1,10));
maxL = max(max(Lbar,1));
maxL = maxL*1.5;
if S_0 > 0
    Lvec = 0:delta:maxL;
else 
    Lvec = delta:delta:maxL;
end
max_newL = (1-tau).*Lvec.^theta + S_0;


V = zeros(1,length(Lvec));
V_new = zeros(1,length(Lvec));
pi = [Lvec; zeros(1,length(Lvec))]';
dif = 1;
while dif > tol
    for i = 1:length(V)
        L0 = Lvec(i);
        valfun = @(L) fn_valfun(L,Lvec,beta,L0,theta,tau,S_0,V);
        Lnew = fminbnd(valfun,0,max_newL(i));
        V_new(i) = -valfun(Lnew);
        pi(i,2) = Lnew;
    end
    dif = norm(V - V_new);
    V = V_new;
end

L_path = pi;
i=3;
while dif > tol*.1
    L_path(:,i) = fn_policyfun(L_path(:,i-1),pi,delta);
    dif = max(L_path(:,i)-L_path(:,i-1));
    i=i+1;
end

L_path = [0:size(L_path,2)-1;L_path];
L_path = L_path';

c_path = L_path;
for i = 1:(size(c_path,1)-1)
    c_path(i,2:size(c_path,2)) = (1-tau).*c_path(i,2:size(c_path,2)).^theta + S_0 - c_path(i+1,2:size(c_path,2));
end

L_path = L_path(1:(end-1),:);
c_path = c_path(1:(end-1),:); 