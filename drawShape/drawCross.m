%绘制十字
%N:图像尺寸
%n:十字宽度
%x0,y0:十字中心坐标
function cross=drawCross(N,n,x0,y0)
x=-N/2:1:N/2-1;
[X,Y]=meshgrid(x,x);
coorx=abs(X-x0)<n/2;
coory=abs(Y-y0)<n/2;
cross=coorx+coory;
end