function [ data ] = ArrayIntoMatrix(data)
%UNTITLED4 Summary of this function goes here

iter = sqrt(length(data));
iter = ceil(iter);
newsize = iter*iter;
%display(newsize);
newdata = zeros(newsize,1);
newdata(1:length(data)) = data;
data = reshape(newdata,iter,iter);
data = data';
end

