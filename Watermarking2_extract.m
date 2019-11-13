clear all;
clc;
clf;

%------------DEKLARACJA ZMIENNYCH-------------
    % tajne informacje wymagane by odczytaæ znak wodny(razem z macierzami
    % Uw Vw
Key = 5;
alfa = 0.00015;
    % flagi dotycz¹ce zak³óceñ, ustaw 1 by poddaæ sygna³ atakowi
vcrop = 1;
vresample=1;
vrequantize = 1;
vlowpass = 1;
vnoise = 1;
%---------------------------------------------

Sp = load('S_matrix.mat');  
data = Sp.data_out2(:,1);  % Wczytaj dane bezposrednio
fs = 48000;

%[data, fs] = getSamples2();  % Wczytaj dane z uprzednio zapisanego pliku d¿wiêkowego

display(length(data))
figure('Name','Sygnal przed ekstrakcj¹ watermarku','NumberTitle','off');
stem(data);

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
    data = filter(hx,1,data); % lowpass filter
end

figure('Name','Sygna³ po ewntualnych zak³óceniach','NumberTitle','off');
stem(data);

data = ArrayIntoMatrix2(data);
[r,l,m] = frit(data,1,'db1');
LL = r(1:l(1),1:l(1));
[U,S,V] = svd(LL); % Operacja SVD
D = Sp.Uw*S*Sp.Vw';

EW = extract_enwatermark(Sp,D,alfa);
EW0 = uint8(EW);
figure('Name','Wydobyty watermark przed IAST','NumberTitle','off');
imshow(EW0)
data_out = Arnold_inverse(EW,Key);
out0 = uint8(data_out);
figure('Name','Wydobyty watermark','NumberTitle','off');
imshow(out0)
lena = load('lena.mat');
lena2 = lena.image;

% wyniki
[ssimval,ssimmap] = ssim(out0,lena2);
ncvalue = NC(out0,lena2);
[ber_number,ber_ratio] = biterr(out0,lena2);