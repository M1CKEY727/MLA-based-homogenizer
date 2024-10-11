%六边形脉冲
%x,y:          中心点横纵坐标
%h:            六边形两对边距离
%image_size:   图像尺寸
%rotationAngle:旋转角度
function hexagon=drawHexagon(x,y,h,image_size,rotationAngle)
hexagon=zeros(image_size(1),image_size(2));
%{
for ii=1:6
    hexagon=hexagon+drawTriangle(x,y,h,image_size,rotationAngle+(ii-1)*60);
end
%}

rotation=[cosd(rotationAngle) -sind(rotationAngle);sind(rotationAngle) cosd(rotationAngle)];
X=zeros(1,6);
Y=X;
X(1)=x; Y(1)=y+h*2/sqrt(3);
X(2)=x+h; Y(2)=y+h/sqrt(3);
X(3)=x+h; Y(3)=y-h/sqrt(3);
X(4)=x; Y(4)=y-h*2/sqrt(3);
X(5)=x-h; Y(5)=y-h/sqrt(3);
X(6)=x-h; Y(6)=y+h/sqrt(3);
Point=[X;Y];
if rotationAngle~=0
    Point=rotation*Point;
    X=Point(1,:);
    Y=Point(2,:);
end
for ii=1:6
    X(ii)=X(ii)+image_size(2)/2;
    Y(ii)=Y(ii)+image_size(1)/2;
end
% 创建一个掩模，表示三角形的位置
mask = poly2mask(X,Y, image_size(1), image_size(2));

% 在矩阵中填充白色的三角形
hexagon(mask) = 1;

end