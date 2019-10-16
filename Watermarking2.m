clear all;
clc;
%------------DEKLARACJA ZMIENNYCH-------------
 
Key = 20;
alfa = 0.0003;
%---------------------------------------------

Sp = load('S_matrix.mat');

%[data, fs] = getSamples2();
data = Sp.data_out2(:,1);
fs = 48000;
data = ArrayIntoMatrix2(data);
[r,l,m] = frit(data,1,'db1');
LL = r(1:l(1),1:l(1));
[U,S,V] = svd(LL); % Operacja SVD
D = Sp.Uw*S*Sp.Vw';

EW = extract_enwatermark(Sp,D,alfa);
EW0 = uint8(EW);
figure(1)
imshow(EW0)
data_out = Arnold_inverse(EW,Key);
out0 = uint8(data_out);
figure(10)
imshow(out0)