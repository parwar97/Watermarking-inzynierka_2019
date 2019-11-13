%stworzenie plikuu csv
for i=0:20
    temp = rand(2000,1);
    csvwrite('ds.csv',temp,i,0);
end

ds = datastore('D:\Watermarking - projekt inzynierski 2019/ds.csv','Type','tabulartext','MissingValue',0);
data = read(ds);
display('koniec');