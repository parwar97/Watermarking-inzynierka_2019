function [ result ] = NC( inp,ref )
%NC Calculate normalized correlation of two images
licznik = 0;
mianownik1=0;
mianownik2=0;
for i =1:length(inp)
    templ = 0;
    tempm1 = 0;
    tempm2 = 0;
    for j=length(inp)
        templ = templ + double(inp(i,j)*ref(i,j));
        tempm1 = tempm1 + double(ref(i,j)*ref(i,j));
        tempm2 = tempm2 + double(inp(i,j)*inp(i,j));
    end
    licznik = licznik + templ;
    mianownik1 = mianownik1 + tempm1;
    mianownik2 = mianownik2 + tempm2;
end

result = licznik/(sqrt(mianownik1)*sqrt(mianownik2));

end

