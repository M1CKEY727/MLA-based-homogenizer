function uniformity=areaUniformity(Image)
imshow(Image,[])
[x,y]=ginput(2);
x=round(x);
y=round(y);
Im=Image(y(1):y(2),x(1):x(2));
Im=Im(:);
uniformity=1-(max(Im)-min(Im))./(max(Im)+min(Im));
end