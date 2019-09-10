function [ data_out ] = Arnold_inverse( data, iter )
%Funkcja realizuj¹ca "Inverse 2D Arnold Scrambling transform"

data_size = size(data);
data_size = data_size(1);
display(data_size);
data_out = zeros(data_size);
A=[2,-1;-1,1];

for i = 1:iter
    for x = 0:(data_size-1)
       for y = 0:(data_size-1)
           temp = A * [x;y];
           temp = temp + [data_size;data_size];
           data_out(mod(temp(1),data_size)+1,mod(temp(2),data_size)+1) = data(x+1,y+1);
       end
    end
    data = data_out;
end


end

