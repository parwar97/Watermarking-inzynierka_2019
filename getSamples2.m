function [data , fs] = getSamples2()
[data,fs]=audioread('zapis.m4a');
data = data(:,1);
%remove padding

for i=1:length(data)
    if(data(i)~=0 && i > 1)
        data(1:i-1)=[];
        display(data(i));
        break;
    end
end

for i=length(data):1
    if(data(i)~=0 && i < length(data))
        data(i+1:length(data))=[];
        break;
    end
end

end

