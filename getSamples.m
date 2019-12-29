function [data , fs] = getSamples(input1)
[data,fs]=audioread(input1);
%sound(data,fs);
data = data(:,1);
end

