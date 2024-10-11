%二维圆域函数
%r：半径
%a,b:圆心横纵坐标
%W,L:图像宽、长度
function I64=drawCircle(r,a,b,W,L)
I64=zeros(W,L);
[m,n]=meshgrid(linspace(-L/2,L/2-1,L),linspace(-W/2,W/2-1,W));
D=((m-a).^2+(n-b).^2).^(1/2);
i=D<=r;
I64(i)=1;