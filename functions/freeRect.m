function rect=freeRect(I)
imshow(I)
[y,x]=ginput(2);
y1=abs(x(2)-x(1));
x1=abs(y(2)-y(1));
x0=round((y(2)+y(1))/2-size(I,1)/2);
y0=round((x(2)+x(1))/2-size(I,2)/2);
rect=drawRect(size(I),[x1,y1],x0,y0);
end