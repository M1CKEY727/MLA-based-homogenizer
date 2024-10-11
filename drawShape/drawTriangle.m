%绘制三角形
%x,y:          中心点横纵坐标
%h:            三角形高
%image_size:   图像尺寸
%rotationAngle:旋转角度
function triangle=drawTriangle(x,y,h,image_size,rotationAngle)
if nargin ==4
    rotationAngle=0;
end
% 创建一个大小为image_size的矩阵
triangle = zeros(image_size);
%旋转矩阵
rotation=[cosd(rotationAngle) -sind(rotationAngle);sind(rotationAngle) cosd(rotationAngle)];
x1=x;y1=y;
x2=h/sqrt(3)+x1; y2=y1+h;
x3=x1-h/sqrt(3); y3=y1+h;
if rotationAngle~=0
    point2=rotation*[x2;y2];
    point3=rotation*[x3;y2];
    x2=point2(1);y2=point2(2);
    x3=point3(1);y3=point3(2);
end
x1=x1+image_size(2)/2;
y1=y1+image_size(1)/2;
x2=x2+image_size(2)/2;
x3=x3+image_size(2)/2;
y2=y2+image_size(1)/2;
y3=y3+image_size(1)/2;
% 定义三角形的顶点坐标
x = [x1, x2, x3]; % 三角形的顶点 x 坐标
y = [y1, y2, y3]; % 三角形的顶点 y 坐标

% 创建一个掩模，表示三角形的位置
mask = poly2mask(x,y, image_size(1), image_size(2));

% 在矩阵中填充白色的三角形
triangle(mask) = 1;
