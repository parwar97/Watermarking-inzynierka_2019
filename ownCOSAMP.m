function [x,r,normR,residHist, errHist] = ownCOSAMP( A, b, k, iter)

% b = A*x

r=b; % wektor reszty
Ar = A'*r;
N           = size(Ar,1);
M           = size(r,1);
if k > M/3
    error('K cannot be larger than the dimension of the atoms');
end
x = zeros(N,1);
ind_k = []; %ind_k
residHist   = zeros(k,1);
errHist     = zeros(k,1);
normR = zeros(k,1);
for s=1:iter
    y_sort  = sort( abs(A'*r),'descend');
    cutoff      = y_sort(2*k); 
    new_ind= find(abs(A'*r)>=cutoff);
    T = union(new_ind,ind_k);
    RHS     = r; % where r = b - A*x, so we'll need to add in "x" later
    x_T     = pinv( A(:,T) )*RHS;
    x_new       = zeros(N,1);
    x_new(T)    = x_T;
    x           = x + x_new;    % this is the key extra step in HSS
    cutoff      = findCutoff( x, k );
    x           = x.*( abs(x) >= cutoff );
    ind_k       = find(x);
    display(size(r));
    display(size(A));
    display(size(r));
    r       = b - A*x;
    if s < iter
        Ar  = A'*r; % prepare for next round
    end
end

function tau = findCutoff( x, k )
% finds the appropriate cutoff such that after hard-thresholding,
% "x" will be k-sparse
x   = sort( abs(x),'descend');
if k > length(x)
    tau = x(end)*.999;
else
    tau  = x(k);
end
end


end