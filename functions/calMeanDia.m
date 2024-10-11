function [ave,ave_radius]=calMeanDia(I,diameter,ratio)  
% calMeanDia 函数用于计算图像I中峰值点的平均直径  
% 输入：  
%   I - 输入图像，可以是灰度图像  
%   diameter - 预期峰值点的直径  
%   ratio - 用于确定像素亮度是否相近的比率  
% 输出：  
%   ave - 平均直径  
% 调用findPeak函数找到峰值点  
peak=findPeak(I);  
  
% 找到峰值点的行和列坐标  
[row,col]=find(peak==1);  
  
% 根据输入的直径计算半径（四舍五入为整数）  
radius=round(diameter/2);  
  
% 初始化平均半径为0  
aveRadius=0;  
all=size(row,1);
ave_radius=zeros(all,1);
% 遍历每个峰值点  
for kk=1:all 
    % 初始化该点的评价半径为0  
    evaRadius=0;  
    % 初始化计数为0  
    m=0;  
      
    % 遍历峰值点周围的一个圆形区域  
    for ii=row(kk)-radius:row(kk)+radius  
        for jj=col(kk)-radius:col(kk)+radius  
            % 如果当前像素的亮度与峰值点亮度相近（相差小于0.01）
            if ii<size(I,1)&&jj<size(I,2)&&ii>1&&jj>1
                if abs(I(ii,jj)-ratio*I(row(kk),col(kk)))<0.05
                    % 计算当前像素与峰值点的距离，并累加到evaRadius  
                    evaRadius=sqrt((ii-row(kk))^2+(jj-col(kk))^2)+evaRadius;  
                    % 增加计数器  
                    m=m+1;  
                end  
            end
        end  
    end  
    if m~=0
        % 计算当前峰值点的平均半径，并累加到aveRadius  
        aveRadius=evaRadius/m+aveRadius;
        ave_radius(kk)=evaRadius/m*1.8;
    else 
        all=all-1;
    end
end  
  
% 计算所有峰值点的平均半径，并赋值给ave  
ave=aveRadius*1.8/all;  
end