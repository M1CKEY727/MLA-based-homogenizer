function h=plotProfile(Image)
imshow(Image,[])
[x,y]=ginput(2);
x=round(x)';
y=round(y)';
line=logical(drawLine(size(Image),[x;y]));
h=plot(Image(line));
end