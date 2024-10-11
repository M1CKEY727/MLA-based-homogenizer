%绘制方形(已弃用,推荐使用drawRect)
%N:图像尺寸
%n:方形边长
%x0,y0:中心点横纵坐标
function square=drawSquare(N,n,x0,y0)
square=zeros(N,N);
x=-N/2:1:N/2-1;
[X,Y]=meshgrid(x,x);
coorx=abs(X-x0)<n/2;
coory=abs(Y-y0)<n/2;
coor=coorx&coory;
square(coor)=1;
end