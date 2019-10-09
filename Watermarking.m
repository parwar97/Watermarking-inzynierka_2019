clear all;
clc;

prompt = 'Wybierz 1 by skorzysta� z darmowych pr�bek dzwi�ku, lub 2 by samemu nagra� sygna� mowy.';
x = input(prompt,'s');
x= str2double(x);
while 1
    if x == 1.
        data = getSamples();
        break;
    elseif x == 2.
        data = recordSpeech();
        break;
    else
        display('Wybrano b��dn� opcj�, spr�buj jeszcze raz');
        x = input('','s');
        x= str2double(x);
    end
end
data = ArrayIntoMatrix(data);
[r,l,m] = frit(data,1,'db1');
r = r(1:200,1:200);
%insert_watermark(r,watermark);
[U,S,V] = svd(r);
