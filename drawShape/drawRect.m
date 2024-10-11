%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 矩形函数绘制
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 作者：米远
% 时间：2023
% 平台：MATLAB R2022b
% 输入：长度量单位均为 mm
% N:         图像尺寸向量
% n:         矩形边长向量
% x0,y0：    矩形中心点横纵坐标
% emergence: 边界羽化系数（使用hann窗函数），取值范围[0,1] 默认值0
% chamfer：  倒角半径，默认不倒角
% 输出：     1D/2D矩形脉冲函数
function rect=drawRect(N,n,x0,y0,emergence,chamfer)
if numel(N)==1
    N=[N,N];
end
if numel(n)==1
    n=[n,n];
end
y=-N(2)/2:1:N(2)/2-1;
x=-N(1)/2:1:N(1)/2-1;
coorx=(abs(x'-x0)<=n(:,1)/2)';
coory=(abs(y'-y0)<=n(:,2)/2)';
%羽化边界
if exist('emergence','var')&&emergence~=0
    edgex=zeros(size(n));
    edgey=zeros(size(n));
    edgex(:,1)=x0+n(:,1)/2;
    edgex(:,2)=x0-n(:,1)/2;
    edgey(:,1)=y0+n(:,2)/2;
    edgey(:,2)=y0-n(:,2)/2;
    XX1=x(:)>edgex(1);
    XX2=x(:)<edgex(2);
    YY1=y(:)>edgey(1);
    YY2=y(:)<edgey(2);
    XX3=coorx==1;
    YY3=coory==1;
    wx1=0.5*(1+cos(2*pi*(x(XX1)-edgex(:,1))/(N(1)*emergence-1)));
    
    if numel(x(XX1))~=numel(x)
        if round(N(1)/2*emergence)==0
            wx1=[];
        else
        wx1(ceil(N(1)/2*emergence):end)=0;
        end
    else
        wx1=zeros(1,numel(x));
    end
    wx2=0.5*(1+cos(2*pi*(x(XX2)-edgex(:,2))/(N(1)*emergence-1)));
    if numel(x(XX2))~=numel(x)
        wx2(1:end-round(N(1)/2*emergence))=0;
    else
        wx2=zeros(1,numel(x));
    end
    wy1=0.5*(1+cos(2*pi*(y(YY1)-edgey(:,1))/(N(2)*emergence-1)));
    if numel(y(YY1))~=numel(y)
        wy1(ceil(N(2)/2*emergence):end)=0;  
    else
        wy1=zeros(1,numel(y));
    end
    wy2=0.5*(1+cos(2*pi*(y(YY2)-edgey(:,2))/(N(2)*emergence-1)));
    
    if numel(y(YY2))~=numel(y)
        wy2(1:end-round(N(2)/2*emergence))=0;
    else
        wy2=zeros(1,numel(y));
    end
    coorx=[wx2,coorx(XX3),wx1];
    coory=[wy2,coory(YY3),wy1];
    if length(coorx)<N(1)
        while length(coorx)<N(1)
            coorx(end+1)=coorx(1);
        end
    elseif length(coorx)>N(1)
        coorx=coorx(1:end-1);
    end
    if length(coory)<N(2)
        while length(coory)<N(2)
            coory(end+1)=coory(1);
        end
    elseif length(coory)>N(2)
        coory=coory(1:end-1);
    end
end
%计算矩形脉冲
if all(coorx==0) && isscalar(coorx)
    rect=coory;
else
    rect=coory'*coorx;
end
%倒角
if exist('chamfer','var')%给rect倒角
    x1r=x0-(n(:,1)/2-chamfer);
    y1r=y0+(n(:,2)/2-chamfer);
    circle1=drawCircle(chamfer,x1r,y1r,N(2),N(1));
    x1=x1r-chamfer/2;
    y1=y1r+chamfer/2;
    rect1=1-drawRect(N,chamfer,x1,y1);
    
    x2r=x0+(n(:,1)/2-chamfer);
    y2r=y0+(n(:,2)/2-chamfer);
    circle2=drawCircle(chamfer,x2r,y2r,N(2),N(1));    
    x2=x2r+chamfer/2;
    y2=y2r+chamfer/2;
    rect2=1-drawRect(N,chamfer,x2,y2);

    x3r=x0+(n(:,1)/2-chamfer);
    y3r=y0-(n(:,2)/2-chamfer);
    circle3=drawCircle(chamfer,x3r,y3r,N(2),N(1));
    x3=x3r+chamfer/2;
    y3=y3r-chamfer/2;
    rect3=1-drawRect(N,chamfer,x3,y3);

    x4r=x0-(n(:,1)/2-chamfer);
    y4r=y0-(n(:,2)/2-chamfer);
    circle4=drawCircle(chamfer,x4r,y4r,N(2),N(1));
    x4=x4r-chamfer/2;
    y4=y4r-chamfer/2;
    rect4=1-drawRect(N,chamfer,x4,y4);
    
    rect=rect.*rect1.*rect2.*rect3.*rect4;
    rect=rect+circle1+circle2+circle3+circle4;
    coor=rect>1;
    rect(coor)=1;
end
end