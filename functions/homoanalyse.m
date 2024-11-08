function [uniformity,stdd,N_percent]=homoanalyse(I)
threshold=otsuthresh(imhist(I));
im2=I>threshold;
im3=I(im2);
uniformity=1-(max(im3)-min(im3))/(max(im3)+min(im3));
stdd=sqrt(mean((im3-mean(im3)).^2))/mean(im3)*100;
%%
%九点取样法
%美国ANSI/NAPMIT7.228-1997标准
[coorx,coory]=find(im2==1);
maxX=max(coorx);
minX=min(coorx);
maxY=max(coory);
minY=min(coory);
width=(maxX-minX)/3;
height=(maxY-minY)/3;
posx=round(width*[0.5,1.5,2.5]+minX);
posy=round(height*[0.5,1.5,2.5]+minY);
pos=[posx(1),posy(1);posx(1),posy(2);posx(1),posy(3);
    posx(2),posy(1);posx(2),posy(2);posx(2),posy(3);
    posx(3),posy(1);posx(3),posy(2);posx(3),posy(3);];
II=zeros(1,9);
for ii=1:9
    rect=logical(drawRect(size(I),width*0.05,pos(ii,1)-size(I,1)/2,pos(ii,2)-size(I,2)/2));
    II(ii)=mean(I(rect));
end
Ea=mean(II);
N_percent=(1-max(abs(II-Ea))/Ea)*100;
end