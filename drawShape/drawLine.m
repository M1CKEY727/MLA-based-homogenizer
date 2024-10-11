%绘制线段
%N:图像尺寸
%coor:线段两端坐标
function line=drawLine(N,coor)
line=zeros(N(1),N(2));
x=coor(1,:);
y=coor(2,:);
vx=(x(1)-x(2));
vy=(y(1)-y(2));
vy_p=-vx/vy;
theta=atan(vy_p);
x=[x(1) x+1*cos(theta) x(2)]-1;
y=[y(1) y+1*sin(theta) y(2)]-1;
mask = poly2mask(x,y, N(1), N(2));
line(mask)=1;
end