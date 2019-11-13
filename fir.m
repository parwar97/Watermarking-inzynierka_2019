clear all; close all; clf;

% za�o�enia takie same jak dla poprzednich laboratori�w
fp = 6000;  % dolna czestotliwo�� kana�u
fr = 7000;  % g�rna cz�stotliwo�� kana�u
fc = (fp+fr)/2; % cz�stotliwo��rednia, dla kt�ej projektujemy filtr
fs = 48000;  % cz�stotliwo�� pr�bkowania
Rr = 80;    % t�umienie w pa�mie zaporowym, podane w dB

% rz�d filtru, magiczny wzorek wyja�niony w poprzednim skrypcie, bo taki sam
R = ceil(3.3*fs/(fr-fp));
K = 2 * ( R+1);    % Liczba wsp�czynnik�w, wi�ksza od rz�du filtru, przynajmniej dwukrotnie
% przy dzisiejszych mo�liwo�ciach komputer�w nawet wi�cej, ale pot�ga dw�jki

k = 0:K-1; % we wzorach podanych na wyk�adzie to jest n, jak si� zmienia ten indeks

if rem(K,2)==0  % je�eli liczba wsp�czynnik�w jest parzysta
    M = (K-2)/2;    % to liczymy liczb� pr��k�w chaki Hx
else
    M = (K-1)/2;
end

fk = k*fs/K; % ci�ko mi opisac co tu si� dzieje
P = length(find(fk>0 & fk<=fc)); % liczba pr��k�w o warto�ci 1

Hx = [ones(1,P) zeros(1,M-P)];
% chak�  z przesuni�ciem mo�na zbudowac na dwa sposoby
% pierwszy dodaje faz� do wifma, czyli przesuwa w czasie
if (1)
    if rem(K,2)==0                  
       H = [1 Hx 0 Hx(end:-1:1)].*exp(-j*2*pi*k/K*K/2);
    else                         % ^^^^^^^^^^^^^^^^^^^^ dodawanie liniowej fazy
       H = [1 Hx   Hx(end:-1:1)].*exp(-j*2*pi*k/K*K/2);
    end   
    hx = (ifft(H));
else %drugi robi zamian� po��wek charakterystyk, zobacz jak wygl�da przed i po zamianie to zrozumiesz! 
    if rem(K,2)==0
        H = [1 Hx 0 Hx(end:-1:1)];
    else
        H = [1 Hx   Hx(end:-1:1)];
    end 
    kkk = ifft(H); % przed zamian� kolejno�ci
    hx = ifftshift(kkk);    % po zamianie kolejno�ci
end
% samo konstruowanie chaki pokazuje obrazek "cha_ki.jpg"


% sprawdzanie czy nie skonstruowali�my cha-ki
% je�li cz�� urojona jest wi�ksza to znaczy, �e �le i musimy co� zmieni�
% ale chyba na kolo tego nie b�dzie
if max(abs(imag(hx))) < 1e-12
    hx = real(hx);
else
    error('B��D!')
end

% z wektora hx wyjmujemy R+1 element�w ze �rodka => 'c' center
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
    
% dlaczego nasza chka nie mie�ci si� z t�umieniem w wyznaczonych 1750 Hz?
% poniewa� wsp�czynniki K s� maj� konkretne warto�ci na osi cz�stotliwo�ci
% i przy przej�ciu chaki mi�dzy 1 a 0, nie trafimy, �eby idelanie 1500 by�o
% w po�owe. Mo�emy zwi�kszy� liczb� wsp�czynnik�w K. U g�ry napisane gdzie
% poikazuje to obrazek "dlaczegoPrzekracza1750.jpg"

figure(4), hold on, grid on,
stem(fk,abs(H),'bs','fill');
plot(F1,abs(H1),'r');
%ylim([0 1.2]);
%xlim([1000 2000]);
    plot(fp*[1 1],get(gca,'ylim'),'k--');
    plot(fr*[1 1],get(gca,'ylim'),'k--');
save('hx','hx');