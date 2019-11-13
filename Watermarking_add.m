clear all;
clc;
clf;
%------------DEKLARACJA ZMIENNYCH-------------
 
Key = 5;
alfa = 0.00005;

%---------------------------------------------


prompt = 'Wybierz 1 by skorzystaæ z darmowych próbek dzwiêku, lub 2 by samemu nagraæ sygna³ mowy.';
x = input(prompt,'s');
x= str2double(x);
while 1
    if x == 1.
        [data, fs] = getSamples();
        break;
    elseif x == 2.
        [data,fs] = recordSpeech();
        break;
    else
        display('Wybrano b³êdn¹ opcjê, spróbuj jeszcze raz');
        x = input('','s');
        x= str2double(x);
    end
end

% Poczatek algorytmu
figure('Name','Oryginalny sygna³','NumberTitle','off');
stem(data)
dataXX=data;
data = ArrayIntoMatrix(data); % Upakuj dane w macierz kwadratow¹ p x p; p - liczba pierwsza
[r,l,m] = frit(data,1,'db1'); % Wykonaj FRT oraz DWT pierwszego poziomu
LL = r(1:l(1),1:l(1)); % Wyodrebnij podpasmo LL
[U,S,V] = svd(LL); % Operacja SVD

save('S_matrix','S');

Img=imread('lena.tif');
image = rgb2gray(Img); % Wczytaj obrazek Leny i zapisz w odcieniach szaroœci
figure('Name','Watermark przed AST','NumberTitle','off');
image=imresize(image,[l(1) l(1)]);
save('lena','image');
imshow(image)
out = Arnold(image,Key); % Wykonaj operacje "Arnold Scrambling Transform"
figure('Name','Watermark po AST','NumberTitle','off');
out0 = uint8(out);
imshow(out0)

temp=insert_watermark(S,out,alfa); % Dodaj znak wodny do podpasma LL
[Uw,Sw,Vw] = svd(temp);
save('S_matrix','Uw', '-append');
save('S_matrix','Vw', '-append');
LL = U*Sw*V'; % Powrór z SVD
r(1:l(1),1:l(1)) = LL;
data_out = ifrit(r,l,m,'db1');
data_out2=[];
for i = 1:size(data_out,1)
    data_out2((i-1)*size(data_out,1)+1:i*size(data_out,1))=data_out(:,i);
end
clear data_out;
data_out2 = data_out2';
data_out2(:,2) = data_out2;
figure('Name','Sygna³ w czasie po operacji watermarkingu','NumberTitle','off')
stem(data_out2(:,1))
save('S_matrix','data_out2', '-append');
%display(mean(data_out2))
audiowrite('zapis.m4a',data_out2,fs);
figure('Name','Roznica w wartosci poszczegolnych probek po operacji watermarkingu','NumberTitle','off');
stem(data_out2(1:length(dataXX),1)-dataXX)
%SNR
data_out_SNR = data_out2(1:length(dataXX))';
licznik = dataXX.*dataXX;
mianownik = (dataXX - data_out_SNR).*(dataXX - data_out_SNR);
wynik = 10*log10(sum(licznik)/sum(mianownik));

err = mean(data_out2(1:length(dataXX),1)-dataXX);

display(sprintf('SNR po operacji watermarkingu wynosi %f db', wynik));
display(sprintf('Wartoœæ œrednia sygna³u b³êdu to: %f',err));