function [uniformity,stdd]=homoanalyse2(I,threshold)
area=I>threshold;
im3=I(area);
uniformity=1-(max(im3)-min(im3))/(max(im3)+min(im3));
stdd=sqrt(mean((im3-mean(im3)).^2))/mean(im3)*100;
end