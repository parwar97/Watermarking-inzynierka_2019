Img=imread('lena.tif');
image = rgb2gray(Img);
image = image(1:256,1:256);
figure(3)
imshow(image);
out = Arnold(image,K);
figure(1)
out = uint8(out);
imshow(out);
figure(2)
out2 = Arnold_inverse(out,192);
out2=uint8(out2);
imshow(out2);
