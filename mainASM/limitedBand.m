%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 带限角谱衍射传递函数计算
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 作者：米远
% 时间：2023
% 平台：MATLAB R2022b
% 输入：长度量单位均为 mm
% imsize:图像尺寸
% lambda:波长
% area:  目标平面尺寸向量
% z:     传播距离，标量或向量
% coor： 离轴中心点坐标向量，默认值[0,0]
% 输出：  带宽限制1D/2D矩形脉冲函数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%参考文献：Kyoji Matsushima and Tomoyoshi Shimobaba.  
% Band-limited angular spectrum method for numerical simulation of free-space propagation in far and near fields.   
% Opt. Express, 17(22):19662–19673, Oct 2009.
function rect=limitedBand(imsize,lambda,area,z,coor)
if numel(area)==1
    area=[area area];
end
if ~exist('coor','var')
    coor=[0,0];
end
%计算系数
f_limit_plus=(sqrt((z./(coor+area/2)).^2+1)*lambda).^-1;
f_limit_minus=(sqrt((z./(coor-area/2)).^2+1)*lambda).^-1;

if area(1)/2<=coor(1)
    fX0=(f_limit_plus(:,1)+f_limit_minus(:,1))/2;
    fX_width=f_limit_plus(:,1)-f_limit_minus(:,1);
elseif area(1)/2>coor(1)&&coor(1)>=-area(1)/2
    fX0=(f_limit_plus(:,1)-f_limit_minus(:,1))/2;
    fX_width=f_limit_plus(:,1)+f_limit_minus(:,1);
elseif coor(1)<-area(1)/2
    fX0=-(f_limit_plus(:,1)+f_limit_minus(:,1))/2;
    fX_width=f_limit_minus(:,1)-f_limit_plus(:,1);
end

if area(2)/2<=coor(2)
    fY0=(f_limit_plus(:,2)+f_limit_minus(:,2))/2;
    fY_width=f_limit_plus(:,2)-f_limit_minus(:,2);
elseif area(2)/2>coor(2)&&coor(2)>=-area(2)/2
    fY0=(f_limit_plus(:,2)-f_limit_minus(:,2))/2;
    fY_width=f_limit_plus(:,2)+f_limit_minus(:,2);
elseif coor(2)<-area(2)/2
    fY0=-(f_limit_plus(:,2)+f_limit_minus(:,2))/2;
    fY_width=f_limit_minus(:,2)-f_limit_plus(:,2);
end
deltaF=1./area;
%hann窗函数系数
%减少傅里叶变换旁瓣（锐利边界傅里叶变换造成的高频伪影）
%emergence=(coor(1)*2/area(1)-1)^2*0.1+0.025;
emergence=0;
%2D矩形脉冲
if imsize(1)~=1
    rect=drawRect(imsize,[fX_width/deltaF(1),fY_width/deltaF(2)],fX0(1)/deltaF(1),fY0(1)/deltaF(2),emergence);
%1D矩形脉冲
else
    rect=zeros(length(z),imsize(2));
    for ii=1:length(z)
        Rectangle=drawRect(imsize,[fX_width(ii)/deltaF(1),fY_width(ii)/deltaF(2)],fX0(ii)/deltaF(1),fY0(ii)/deltaF(2));
        rect(ii,1:length(Rectangle))=Rectangle;
    end
end
end