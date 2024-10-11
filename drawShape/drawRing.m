%绘制圆环
%r1,r2:圆环外半径，内半径
%a,b:中心点横纵坐标
%W,L:图像尺寸
function I64=drawRing(r1,r2,a,b,W,L)
%[m,n]=meshgrid(linspace(-N/2,N/2-1,N));
I64=zeros(W,L);
[m,n]=meshgrid(linspace(-L/2,L/2-1,L),linspace(-W/2,W/2-1,W));
D=((m+a).^2+(n+b).^2).^(1/2);
i=D<=r2&D>r1;
I64(i)=1;
%figure(2);
%imshow(A);