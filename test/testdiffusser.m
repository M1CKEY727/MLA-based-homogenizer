clc;
clear
phase=diffuser(500,2.5);
phase=angle(phase);
phase=rad2deg(phase);
[gradx,grady]=gradient(phase);
a=sqrt(gradx.^2+grady.^2);
max(max(a))
%{
phase = diffuser(750,2.5);
phase=angle(phase);
angleZ=computeAngleWithZAxis(phase);
max(max(angleZ))
function angle = computeAngleWithZAxis(z_func)
    % 计算高度函数的梯度向量
    [gx, gy] = gradient(z_func);

    % 计算单位 z 轴向量
    z_unit = [0, 0, 1];

    % 计算法向量
    for ii=1:size(z_func,1)
        for jj=1:size(z_func,2)
            N = cross([-gx(ii,jj), -gy(ii,jj), 1], z_unit);
            N = N ./ vecnorm(N, 2, 2);  % 归一化法向量
        
            % 计算法向量与 z 轴的夹角
            cos_theta = dot(N, z_unit);
            angle(ii,jj) = acosd(cos_theta);
        end
    end
end
%}
