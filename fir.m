clear all; close all; clf;

% za³o¿enia takie same jak dla poprzednich laboratoriów
fp = 6000;  % dolna czestotliwoœæ kana³u
fr = 7000;  % górna czêstotliwoœæ kana³u
fc = (fp+fr)/2; % czêstotliwoœæœrednia, dla któej projektujemy filtr
fs = 48000;  % czêstotliwoœæ próbkowania
Rr = 80;    % t³umienie w paœmie zaporowym, podane w dB

% rz¹d filtru, magiczny wzorek wyjaœniony w poprzednim skrypcie, bo taki sam
R = ceil(3.3*fs/(fr-fp));
K = 2 * ( R+1);    % Liczba wspó³czynników, wiêksza od rzêdu filtru, przynajmniej dwukrotnie
% przy dzisiejszych mo¿liwoœciach komputerów nawet wiêcej, ale potêga dwójki

k = 0:K-1; % we wzorach podanych na wyk³adzie to jest n, jak siê zmienia ten indeks

if rem(K,2)==0  % je¿eli liczba wspó³czynników jest parzysta
    M = (K-2)/2;    % to liczymy liczbê pr¹¿ków chaki Hx
else
    M = (K-1)/2;
end

fk = k*fs/K; % ciê¿ko mi opisac co tu siê dzieje
P = length(find(fk>0 & fk<=fc)); % liczba pr¹¿ków o wartoœci 1

Hx = [ones(1,P) zeros(1,M-P)];
% chakê  z przesuniêciem mo¿na zbudowac na dwa sposoby
% pierwszy dodaje fazê do wifma, czyli przesuwa w czasie
if (1)
    if rem(K,2)==0                  
       H = [1 Hx 0 Hx(end:-1:1)].*exp(-j*2*pi*k/K*K/2);
    else                         % ^^^^^^^^^^^^^^^^^^^^ dodawanie liniowej fazy
       H = [1 Hx   Hx(end:-1:1)].*exp(-j*2*pi*k/K*K/2);
    end   
    hx = (ifft(H));
else %drugi robi zamianê po³ówek charakterystyk, zobacz jak wygl¹da przed i po zamianie to zrozumiesz! 
    if rem(K,2)==0
        H = [1 Hx 0 Hx(end:-1:1)];
    else
        H = [1 Hx   Hx(end:-1:1)];
    end 
    kkk = ifft(H); % przed zamian¹ kolejnoœci
    hx = ifftshift(kkk);    % po zamianie kolejnoœci
end
% samo konstruowanie chaki pokazuje obrazek "cha_ki.jpg"


% sprawdzanie czy nie skonstruowaliœmy cha-ki
% jeœli czêœæ urojona jest wiêksza to znaczy, ¿e Ÿle i musimy coœ zmieniæ
% ale chyba na kolo tego nie bêdzie
if max(abs(imag(hx))) < 1e-12
    hx = real(hx);
else
    error('B£¥D!')
end

% z wektora hx wyjmujemy R+1 elementów ze œrodka => 'c' center
hx = wkeep (hx, R+1 , 'c')   .* hamming(R+1)';

% no i rysujemy
figure(1), hold on, grid on
    subplot(2,1,1), hold on, grid on
        stem(fk,abs(H),'bs','fill')
    subplot(2,1,2), hold on, grid on
        stem(fk,angle(H),'bs','fill')

figure(2), hold on, grid on
    stem([0:R]/fs,hx,'bs','fill')

[H1 F1] = freqz(hx,1,1024,fs);
%[H2 F2] = freqz(h,1,1024,fs);

figure(3), hold on, grid on
    plot(F1,20*log10(abs(H1)/max(abs(H1))),'b');
    axis([0 fs/2 -100 10]);
    %rysuje te kreski
    plot(fp*[1 1],get(gca,'ylim'),'k--');
    plot(fr*[1 1],get(gca,'ylim'),'k--');
    plot(get(gca,'xlim'),-Rr*[1 1],'k--');
    
% dlaczego nasza chka nie mieœci siê z t³umieniem w wyznaczonych 1750 Hz?
% poniewa¿ wspó³czynniki K s¹ maj¹ konkretne wartoœci na osi czêstotliwoœci
% i przy przejœciu chaki miêdzy 1 a 0, nie trafimy, ¿eby idelanie 1500 by³o
% w po³owe. Mo¿emy zwiêkszyæ liczbê wspó³czynników K. U góry napisane gdzie
% poikazuje to obrazek "dlaczegoPrzekracza1750.jpg"

figure(4), hold on, grid on,
stem(fk,abs(H),'bs','fill');
plot(F1,abs(H1),'r');
%ylim([0 1.2]);
%xlim([1000 2000]);
    plot(fp*[1 1],get(gca,'ylim'),'k--');
    plot(fr*[1 1],get(gca,'ylim'),'k--');
save('hx','hx');