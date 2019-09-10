function [ data_out ] = Arnold( data, iter )
% Funkcja przeprowadzajaca operacje "Arnold Scrambling Transform"

data_size = size(data);
data_size = data_size(1);
display(data_size);
data_out = zeros(data_size);
A=[1,1;1,2];

for i = 1:iter
    for x = 0:(data_size-1)
       for y = 0:(data_size-1)
           temp = A * [x;y];
           data_out(mod(temp(1),data_size)+1,mod(temp(2),data_size)+1) = data(x+1,y+1);
       end
    end
    data = data_out;
end

end
