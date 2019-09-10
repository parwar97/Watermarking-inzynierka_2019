function [data ] = getSamples()
[data,fs]=audioread('Nagranie (33).m4a', [1 inf]);
%sound(data,fs);
data = reshape(data,[size(data,1)*size(data,2) ,1]);
end

