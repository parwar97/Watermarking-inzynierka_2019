function [ ber_value ] = BER( in,ref )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
ber_value =0;
for i=1:length(in)
   for j=1:length(in)
       ber_value = ber_value + conv(in(i,j),ref(i,j))/i/j;
   end
end
end

