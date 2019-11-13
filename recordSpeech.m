function [ data, fs ] = recordSpeech()
%recordSpeech Summary 
%   Funkcja korzystaj�c z audiorecordera pozwala u�ytkownikowi nagra�
%   pr�bk� swojego g�osu. 
%   Funkcja zwraca jednowymiarowy wektor z danymi
prompt = 'Wybierz czas nagrywania( do 10 sekund)';
x = input(prompt,'s');
while(1)
    
    x=str2double(x);
    if x<10 && x > 0
        break;
    else
        display('Wybierz prawidlowa wartosc( od zera do 10 sekund w��cznie)');
        x = input('','s');
    end
end
disp('Nagrywanie rozpoczyna si�... ')
fs = 48000;
recObj = audiorecorder(fs,16,1);
recordblocking(recObj,x);
play(recObj);
data= getaudiodata(recObj);

end

