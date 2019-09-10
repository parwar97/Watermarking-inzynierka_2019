Img=imread('lena.tif');
image = rgb2gray(Img);

out = Arnold(image,40);
figure(1)
out = uint8(out);
imshow(out);
figure(2)
out2 = Arnold_inverse(out,40);
out2=uint8(out2);
imshow(out2);
