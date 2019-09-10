%Written by Dr. Prashan Premaratne - University of Wollongong - 1 May 2006
%num specifies the number of Iterations for the Arnold Transform
function arnold_2(im,num)
[rown,coln]=size(im);
figure(1)
rown = rown-1;
for inc=1:num
    for row=0:rown
        for col=0:rown
            newcord =[1 1;1 2]*[row col]';
            nrowp=newcord(1);
            ncolp=newcord(2);
            nrowp = mod(nrowp,rown)+1;
            ncolp = mod(ncolp,rown)+1;
            newim(nrowp,ncolp) = im(row+1,col+1);   
        end
    end 
end
imshow(newim)
figure(2)
[irown,icoln]=size(newim);
for inc=1:num
for irow=1:irown
    for icol=1:icoln
        
        inrowp = irow;
        incolp=icol;
        %for ite=1:num
            inewcord =[2 -1;-1 1]*[inrowp incolp]';
            inrowp=inewcord(1);
            incolp=inewcord(2);
            inrowp = inrowp + irown;
            incolp = incolp + icoln ;
        %end

        iminverse(irow,icol)=newim((mod(inrowp,irown)+1),(mod(incolp,icoln)+1));
        
    end
end
imshow(iminverse)
end
%out=iminverse;