clear all;
clc;
%------------DEKLARACJA ZMIENNYCH-------------
 
Key = 20;
alfa = 0.0001;
%---------------------------------------------

[data, fs] = getSamples();
data = ArrayIntoMatrix(data);
[r,l,m] = frit(data,1,'db1');
LL = r(1:l(1),1:l(1));
[U,S,V] = svd(LL); % Operacja SVD
Sp = load('S_matrix.mat');
D = Sp.Uw*S*Sp.Vw';

EW = extract_enwatermark(Sp,D,alfa);
EW0 = uint8(EW);
figure(1)
imshow(EW0)
data_out = Arnold_inverse(EW,Key);
out0 = uint8(data_out);
figure(2)
imshow(out0)