function [data , fs] = getSamples()
[data,fs]=audioread('Nagranie.m4a');
%sound(data,fs);
data = data(:,1);
end

