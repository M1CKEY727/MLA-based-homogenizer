function result = ASMLens(beam, delta_edge, delta_mid, delta_air, t_edge, lambda, n, area)
% ASMLens: 模拟光学系统中透镜的行为。只考虑相位

% 输入:
%   - beam: 表示光学光束的复数二维数组。
%   - delta_edge: 三维数组，表示透镜边缘的相位变化。
%   - delta_mid: 三维数组，表示透镜中部的相位变化。
%   - delta_air: 三维数组，表示空气区域的相位变化。
%   - t_edge: 透镜边缘的厚度数组。
%   - lambda: 光学光束的波长。
%   - n: 折射率的一维数组，对应不同区域。
%   - area: 表示光束的空间分布的二维数组。

% 输出:
%   - result: 表示通过透镜后的光学光束的复数二维数组。

% 根据提供的区域计算空间率。
rate = area ./ size(beam,[1 2]);

if size(beam,1)~=size(delta_air,1)
    if size(beam,1)>size(delta_air,1)
        beam=imcrop(beam,[1,1,size(delta_air,1),size(delta_air,2)]);
    else
        beam(end+size(delta_air,1)-size(beam,1),end+size(delta_air,2)-size(beam,2))=0;
    end
end

% 在空气区域应用相位变化。
beam = beam .* exp(1i * 2 * pi / lambda * delta_air(:,:,1));



% 迭代透镜的不同层。
for ii = 1:size(delta_edge, 3) - 1
    % 在透镜边缘应用相位变化。
    if ii == 1
        beam = beam .* exp(1i * 2 * pi / lambda * n(ii) * delta_edge(:,:,ii));
    else
        beam = beam .* exp(1i * 2 * pi / lambda *n(ii) * (t_edge(ii) - delta_edge(:,:,ii)));
    end
    
    % 根据中部参数变换光束。
    beam = transform(beam, area, lambda, delta_mid(ii), rate,n(ii));
    
    % 在下一个透镜边缘应用相位变化。
    beam = beam .* exp(1i * 2 * pi / lambda * n(ii) * delta_edge(:,:,ii + 1));
end

% 在最终的空气区域应用相位变化。
result = beam .* exp(1i * 2 * pi / lambda * delta_air(:,:,2));
end