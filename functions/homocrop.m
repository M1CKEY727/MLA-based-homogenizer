function [croppedI,rect]=homocrop(I)
if numel(size(I))==3
    I=rgb2gray(I);
end
I=imnorm(double(I));
se=strel([3,3]);
thresh=otsuthresh(imhist(I))*2.1;
im=I>thresh;
im=imerode(im,se);
[row,col]=find(im==1);
maxX=max(col);
maxY=max(row);
minX=min(col);
minY=min(row);
croppedI=I(minY:maxY,minX:maxX);
rect=[minX,maxX,minY,maxY];
end
