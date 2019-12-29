clear all;
clc;
clf;
close all;
%------------DEKLARACJA ZMIENNYCH-------------
 
Key = 5;
alfa = 0.0002;
wav = 'db1';
input1='Nagranie_123.m4a';
wtitle='lena.tif';
%wtitle='watermark2.jpeg'
%---------------------------------------------

option = ['key_',int2str(Key),'_alfa_',int2str(alfa*10^6),'div10^6_filter_',wav,'_inp_',input1,'_wat_',wtitle];

save('S_matrix','option');

if ~exist(['wykresy/',option], 'dir')
    mkdir(['wykresy/',option])
end
save(['wykresy/',option,'/results'],'option');

prompt = 'Wybierz 1 by skorzystaæ z darmowych próbek dzwiêku, lub 2 by samemu nagraæ sygna³ mowy.';
x = input(prompt,'s');
x= str2double(x);
while 1
    if x == 1.
        [data, fs] = getSamples(input1);
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
xlabel('Próbki') 
ylabel('Amplituda') 
title('Oryginalny sygna³')
saveas(gcf,['wykresy/',option,'/original.png']);
dataXX=data;
data = ArrayIntoMatrix(data); % Upakuj dane w macierz kwadratow¹ p x p; p - liczba pierwsza
[r,l,m] = frit(data,1,wav); % Wykonaj FRT oraz DWT pierwszego poziomu
LL = r(1:l(1),1:l(1)); % Wyodrebnij podpasmo LL
[U,S,V] = svd(LL); % Operacja SVD

save('S_matrix','S','-append');

%image=imread(wtitle);
image=imread(wtitle);
image = rgb2gray(image); % Wczytaj obrazek Leny i zapisz w odcieniach szaroœci

figure('Name','Znak wodny przed AST','NumberTitle','off');
image=imresize(image,[l(1) l(1)]);
save('IMG_W','image');
imshow(image)
title('Znak wodny przed operacj¹ AST')
saveas(gcf,['wykresy/',option,'/watermark_bAST.png']);
out = Arnold(image,Key); % Wykonaj operacje "Arnold Scrambling Transform"
figure('Name','Znak wodny po AST','NumberTitle','off');
out0 = uint8(out);
imshow(out0)
title('Znak wodny po operacji AST')
saveas(gcf,['wykresy/',option,'/watermark_AST.png']);
temp=insert_watermark(S,out,alfa); % Dodaj znak wodny do podpasma LL
[Uw,Sw,Vw] = svd(temp);
save('S_matrix','Uw', '-append');
save('S_matrix','Vw', '-append');
LL = U*Sw*V'; % Powrór z SVD
r(1:l(1),1:l(1)) = LL;
data_out = ifrit(r,l,m,wav);
data_out2=[];
for i = 1:size(data_out,1)
    data_out2((i-1)*size(data_out,1)+1:i*size(data_out,1))=data_out(:,i);
end
clear data_out;
data_out2 = data_out2';
data_out2(:,2) = data_out2;
figure('Name','Sygna³ w czasie po operacji watermarkingu','NumberTitle','off')
stem(data_out2(:,1))
xlabel('Próbki') 
ylabel('Amplituda') 
title('Sygna³ po operacji na³o¿enia znaku wodnego')
saveas(gcf,['wykresy/',option,'/after_watermark.png']);
save('S_matrix','data_out2', '-append');
audiowrite('zapis.m4a',data_out2,fs);
figure('Name','Roznica w wartosci poszczegolnych probek po operacji watermarkingu','NumberTitle','off');
stem(data_out2(1:length(dataXX),1)-dataXX)
xlabel('Próbki') 
ylabel('Amplituda') 
title('Ró¿nica')
saveas(gcf,['wykresy/',option,'/difference.png']);
%SNR
data_out_SNR = data_out2(1:length(dataXX))';
licznik = dataXX.*dataXX;
mianownik = (dataXX - data_out_SNR).*(dataXX - data_out_SNR);
wynik = 10*log10(sum(licznik)/sum(mianownik));
%wynik = snr(dataXX,dataXX-data_out_SNR);

err = mean(data_out2(1:length(dataXX),1)-dataXX);

display(sprintf('SNR po operacji watermarkingu wynosi %f db', wynik));
display(sprintf('Wartoœæ œrednia sygna³u b³êdu to: %f',err));
save(['wykresy/',option,'/results'],'wynik');
save(['wykresy/',option,'/results'],'err', '-append');