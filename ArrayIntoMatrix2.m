function [ data ] = ArrayIntoMatrix2(data)
%UNTITLED4 Summary of this function goes here

iter = sqrt(length(data));
iter = ceil(iter);
iter  = PrimeNumber(iter);
newsize = iter*iter;
%display(newsize);
newdata = zeros(newsize,1);
newdata(1:length(data)) = data;
if (newsize > length(data))
    newdata(length(data)+1) = 0;
end
data = reshape(newdata,[iter iter]);
end
