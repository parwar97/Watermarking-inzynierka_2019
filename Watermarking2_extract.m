clear all;
clc;
clf;
close all;
%------------DEKLARACJA ZMIENNYCH-------------
    % tajne informacje wymagane by odczytaæ znak wodny(razem z macierzami
    % Uw Vw
Key = 5;
alfa = 0.0002;
wav='db1';
    % flagi dotycz¹ce zak³óceñ, ustaw 1 by poddaæ sygna³ atakowi
vcrop = 1;
vresample=0;
vrequantize = 0;
vlowpass = 0;
vnoise = 0;
%---------------------------------------------

Sp = load('S_matrix.mat');  
fs = 48000;
option = Sp.option;


% ZAKOMENTUJ BY U¯YÆ DRUGIEJ OPCJI
data = Sp.data_out2(:,1);  % Wczytaj dane bezposrednio
%[data, fs] = getSamples2(length(Sp.data_out2));  % Wczytaj dane z uprzednio zapisanego pliku d¿wiêkowego


figure('Name','Sygnal przed ekstrakcj¹ znaku wodnego','NumberTitle','off');
stem(data);
xlabel('Próbki') 
ylabel('Amplituda') 
title('Sygna³ przed ekstrakcj¹ znaku wodnego')

if (vnoise == 1)
    data = awgn(data,50); %noise atak 
end

if (vcrop == 1)
    data(1:30000) = zeros(1,30000); %cropping atak
    data(1:30000) = awgn(data(1:30000),50); %cropping atak
    data(150000:end) = zeros(1,length(data(150000:end))); %cropping atak
    data(150000:end) = awgn(data(150000:end),50); %cropping atak
end

if (vresample == 1)
    data=resample(data,1,2); %resampling atak
    data = resample(data,2,1); % resampling atak
    data = data(2:end); % resampling atak
    display(length(data)) % resampling atak
end

if (vrequantize == 1) % ten przyk³ad powinien zostaæ poprawiony by uwzglêdnia³ wiêksz¹ rekwantyzacje,
                     % obecnie z 64bit -> 32bit, wp³yw jest niezauwa¿alny
    data = single(data); % requantize
    data = double(data); %requantize
end

if (vlowpass ==1)
    hx = load('hx.mat'); % lowpass filter
    hx = hx.hx; % lowpass filter
    data =filter(hx,1,data); % lowpass filter
end

figure('Name','Sygna³ po ewentualnych zak³óceniach','NumberTitle','off');
stitle='';
if(vlowpass)
stitle=[stitle,'_vlowpass'];
end
if(vnoise)
stitle=[stitle,'_vnoise'];
end
if(vcrop)
stitle=[stitle,'_vcrop']
end
if(vresample)
stitle=[stitle,'_vresample']
end
if(vrequantize)
stitle=[stitle,'_vrequantize']
end
display(stitle);
stem(data);
xlabel('Próbki') 
ylabel('Amplituda') 
title('Sygna³ po przeprowadzonym ataku')
saveas(gcf,['wykresy/',option,['/signal_attacks',stitle,'.png']]);
data = ArrayIntoMatrix2(data);
[r,l,m] = frit(data,1,wav);
LL = r(1:l(1),1:l(1));
[U,S,V] = svd(LL); % Operacja SVD
D = Sp.Uw*S*Sp.Vw';

EW = extract_enwatermark(Sp,D,alfa);
EW0 = uint8(EW);
figure('Name','Wydobyty znak wodny przed IAST','NumberTitle','off');
imshow(EW0)
title('Wyekstrahowany znak wodny przed operacj¹ IAST')
saveas(gcf,['wykresy/',option,['/watermark_bIAST',stitle,'.png']]);
data_out = Arnold_inverse(EW,Key);
out0 = uint8(data_out);
figure('Name','Wydobyty znak wodny','NumberTitle','off');
imshow(out0)
title('Wyekstrahowany znak wodny po IAST')
saveas(gcf,['wykresy/',option,['/watermark_extrAST',stitle,'.png']]);
lena = load('IMG_W.mat');
img_w = lena.image;

% wyniki
[ssimval,ssimmap] = ssim(out0,img_w);
save(['wykresy/',option,'/results'],'ssimval', '-append');
ncvalue = NC(out0,img_w);
save(['wykresy/',option,'/results'],'ncvalue', '-append');
[ber_number,ber_ratio] = biterr(out0,img_w);
save(['wykresy/',option,'/results'],'ber_ratio', '-append');