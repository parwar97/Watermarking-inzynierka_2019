clear all;
clc;
clf;
%------------DEKLARACJA ZMIENNYCH-------------
 
k = 500;
K=500;
    %flagi
vtrans = 3;
    % 0 dla dct
    % 1 dla fft
    % 2 dla dwt
    % 3 dla svd
    vOMP = 1;
    vCosamp = 0;
%---------------------------------------------


[SP,Fs] = audioread('man.wav');
display(SP)
SP=SP(:,1);
SP = SP(1:500);
figure('Name','Original signal','NumberTitle','off');
stem(SP)
sound(SP,Fs);
switch(vtrans)
    case 0
        x= dct(SP);
    case 1
        x = fft(SP);
    case 2
        [x,c] = dwt(SP,'db1');
    case 3
%         SP = ArrayIntoMatrix(SP)';
%         [U,x,V] = svd(SP);
%         for i = 1:size(SP,1)
%             U1((i-1)*size(U,1)+1:i*size(U,1))=U(i,:);
%             x1((i-1)*size(x,1)+1:i*size(x,1))=x(i,:);
%             V1((i-1)*size(V,1)+1:i*size(V,1))=V(i,:);
%         end
%         x = (U1.*x1)';
        [U,x,V]=svd(SP);
        x=U*x;
end
N=length(x);
A = randn(K,N);
y = A*x;
figure('Name','Compressed signal','NumberTitle','off');
stem(y)

if (vOMP==1)
    [xc,r] = ownOMP(A,y,k);
end

if (vCosamp ==1)
    opts = [];
    opts.addK = k;
    [xc,r] = CoSaMP2(A,y,k,[],opts);
end

switch(vtrans)
    case 0
        CSP= idct(xc);
    case 1
        CSP = ifft(xc);
    case 2
        CSP = idwt(xc, c, 'db1');
    case 3
%         xc = ArrayIntoMatrix(xc)';
%         CSP = xc*V';
%         for i = 1:size(CSP,1)
%             CSP1((i-1)*size(CSP,1)+1:i*size(CSP,1))=CSP(i,:);
%         end
%         CSP = double(CSP1);
        CSP = xc*V';
end
CSP = double(CSP);
figure('Name','Reconstructed signal','NumberTitle','off');
stem(CSP)
soundsc((real(double(CSP))),Fs)
%sound(CSP,Fs);
CR = length(SP)/length(y) * 100;
R = corrcoef(SP,CSP);