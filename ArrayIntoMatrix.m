function [ data ] = ArrayIntoMatrix(data)
%UNTITLED4 Summary of this function goes here

iter = sqrt(length(data));
iter = ceil(iter);
iter  = PrimeNumber(iter);
newsize = iter*iter;
%display(newsize);
newdata = zeros(newsize,1);
newdata(1:length(data)) = data;
newdata(length(data)+1) = 128;
data = reshape(newdata,iter,iter);
data = data';
end

