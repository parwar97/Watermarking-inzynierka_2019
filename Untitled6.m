fs = 1000;
x = randn(20000,1);

[y1,d1] = lowpass(x,200,fs,'ImpulseResponse','iir','Steepness',0.5);
[y2,d2] = lowpass(x,200,fs,'ImpulseResponse','iir','Steepness',0.8);
[y3,d3] = lowpass(x,200,fs,'ImpulseResponse','iir','Steepness',0.95);

pspectrum([y1 y2 y3],fs)
legend('Steepness = 0.5','Steepness = 0.8','Steepness = 0.95')


[h1,f] = freqz(d1,1024,fs);
[h2,~] = freqz(d2,1024,fs);
[h3,~] = freqz(d3,1024,fs);

plot(f,mag2db(abs([h1 h2 h3])))
legend('Steepness = 0.5','Steepness = 0.8','Steepness = 0.95')