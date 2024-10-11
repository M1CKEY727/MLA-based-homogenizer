function peak=findPeak(I)
hist=imhist(I);
thr=otsuthresh(hist);
coor=I>thr;
[gX,gY]=gradient(I);
grad_mag=sqrt(gX.^2+gY.^2);
threshold=otsuthresh(imhist(grad_mag));
coor2=grad_mag<threshold;
peak=coor2&coor;
end