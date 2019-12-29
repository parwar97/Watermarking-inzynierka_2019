% b = A*x

k = 150;
K=400;
iter=50;
[SP,Fs] = audioread('man.wav');
display(SP)
SP=SP(:,1);
SP = SP(1:500);
N=length(x)
A = randn(K,N);
y = A*x;

b = y;

r=b; % wektor reszty
x = zeros(size(A'*r,1),1);
N           = size(A'*r,1);
ind_k = []; %ind_k
residHist   = zeros(k,1);
errHist     = zeros(k,1);
for s=1:iter
    y_sort  = sort( abs(A'*r),'descend');
    new_ind= find(abs(A'*r)>=y_sort(2*k));
    T = union(new_ind,ind_k);
    RHS     = r; % where r = b - A*x, so we'll need to add in "x" later
    x_T     = pinv( A(:,T) )*RHS;
    x_new       = zeros(N,1);
    x_new(T)    = x_T;
    x           = x + x_new;    % this is the key extra step in HSS
    temp   = sort( abs(x),'descend');
    if(k>length(x))
        cutoff = temp(end).*999;
    else
        cutoff = temp(k);
    end
    x           = x.*( abs(x) >= cutoff );
    ind_k       = find(x);
    r       = b - A*x;
    if s < iter
        Ar  = A'*r; % prepare for next round
    end
end