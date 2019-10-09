function [ i ] = PrimeNumber(data)
num=0;
for i=data:9223372036854775807
    for j=1:i
        if rem(i,j)==0 
            num=num+1;
        end
    end
    if num==2
        break;
    else
        num=0;
    end
end


