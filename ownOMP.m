function [nowe,r] = ownOMP( A, y, K)

r=y;
lambda = zeros(size(A,2),1);
indexes = zeros(size(A,2),1);
Anew = zeros(size(A,1),K);

Al = A;
for li = 1:size(Al,2)
    Al(:,li) = Al(:,li)/norm(Al(:,li));
end

for k=1:K
    w = (Al'*r);
    [~, I] = max(abs(w));
    Anew(:,k) = A(:,I);
    indexes(k) = I;
    Al(:,I) = zeros(1,size(Al,1));
    Anewp = pinv(Anew(:,1:k));
    lambda(1:k) = Anewp * y;
    r = y - Anew(:,1:k)*lambda(1:k);
    display(k)
end

nowe = zeros(size(A,2),1);
for in = 1:K
    nowe(indexes(in))=lambda(in);
end

end




