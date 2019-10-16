clear all;
clc;
%------------DEKLARACJA ZMIENNYCH-------------
 
Key = 20;
alfa = 0.00005;

%---------------------------------------------


prompt = 'Wybierz 1 by skorzysta� z darmowych pr�bek dzwi�ku, lub 2 by samemu nagra� sygna� mowy.';
x = input(prompt,'s');
x= str2double(x);
while 1
    if x == 1.
        [data, fs] = getSamples();
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

% Poczatek algorytmu
figure('Name','Original signal','NumberTitle','off');
stem(data)
dataXX=data;
data = ArrayIntoMatrix(data); % Upakuj dane w macierz kwadratow� p x p; p - liczba pierwsza
[r,l,m] = frit(data,1,'db1'); % Wykonaj FRT oraz DWT pierwszego poziomu
LL = r(1:l(1),1:l(1)); % Wyodrebnij podpasmo LL
[U,S,V] = svd(LL); % Operacja SVD

save('S_matrix','S');

Img=imread('lena.tif');
image = rgb2gray(Img); % Wczytaj obrazek Leny i zapisz w odcieniach szaro�ci
figure('Name','Watermark before AST','NumberTitle','off');
image=imresize(image,[l(1) l(1)]);
imshow(image)
out = Arnold(image,Key); % Wykonaj operacje "Arnold Scrambling Transform"
figure('Name','Watermark after AST','NumberTitle','off');
out0 = uint8(out);
imshow(out0)

temp=insert_watermark(S,out,alfa); % Dodaj znak wodny do podpasma LL
[Uw,Sw,Vw] = svd(temp);
save('S_matrix','Uw', '-append');
save('S_matrix','Vw', '-append');
LL = U*Sw*V'; % Powr�r z SVD
r(1:l(1),1:l(1)) = LL;
data_out = ifrit(r,l,m,'db1');
data_out2=[];
for i = 1:size(data_out,1)
    data_out2((i-1)*size(data_out,1)+1:i*size(data_out,1))=data_out(:,i);
end
data_out2 = data_out2';
data_out2(:,2) = data_out2;
figure('Name','Signal in time after watermark procedure','NumberTitle','off')
stem(data_out2(:,1))
save('S_matrix','data_out2', '-append');
audiowrite('zapis.m4a',data_out2,fs);

%SNR
data_out_SNR = data_out2(1:length(dataXX))';
licznik = dataXX.*dataXX;
mianownik = (dataXX - data_out_SNR).*(dataXX - data_out_SNR);
wynik = 10*log10(sum(licznik)/sum(mianownik));
display(wynik);