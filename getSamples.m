function [data , fs] = getSamples()
[data,fs]=audioread('Nagranie_Marcin.m4a');
%sound(data,fs);
data = data(:,1);
end

