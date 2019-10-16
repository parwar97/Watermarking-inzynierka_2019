function [data , fs] = getSamples2()
[data,fs]=audioread('zapis.m4a');
%sound(data,fs);
data = data(:,1);
data = data(1:310249);
display(length(data));
end

