%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% 角谱衍射及缩放角谱衍射  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% 作者：米远  
% 时间：2023  
% 平台：MATLAB R2022b  
% 输入：长度量单位均为 mm  
% Image: 输入光场图像  
% area:  目标平面尺寸向量  
% lambda: 波长  
% z:      传播距离，标量或向量  
% delta:  采样单元尺寸向量  
% n:      传播介质折射率，默认值1  
% scale:  缩放系数，取值应大于等于1，默认值1，即不缩放  
% coor：  离轴中心点坐标向量，默认值[0,0]  
% 输出：  角谱衍射传播后的光场  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% 参考文献：  
% [1] Kyoji Matsushima and Tomoyoshi Shimobaba.    
% Band-limited angular spectrum method for numerical simulation of free-space propagation in far and near fields.     
% Opt. Express, 17(22):19662–19673, Oct 2009.  
% Xiao Yu, Tang Xiahui, Qin Yingxiong, Peng Hao, and Wang Wei.    
% [2] Band-limited angular spectrum numerical propagation method with selective scaling of observation window size and sample number.     
% J. Opt. Soc. Am. A, 29(11):2415–2420, Nov 2012.  
% 没有找到好的重构方法，代码比较乱
  
function result = transform(Image, area, lambda, z, delta, n, scale, coor)  
    % 如果折射率n未定义，则默认设置为1  
    if ~exist('n', 'var')  
        n = 1;  
    end  
    % 如果离轴中心点坐标coor未定义，则默认设置为[0,0]  
    if ~exist('coor', 'var')  
        coor = [0, 0];  
    end  
      
    % 创建传递函数  
    prop = Propagator(delta, lambda, max(area, size(Image, 1) * delta(1)), z, n, coor);  
      
    % 如果未定义缩放系数scale或scale为1（即不进行缩放）  
    if ~exist('scale', 'var') || scale == 1  
        % 计算目标平面的尺寸对应的采样点数  
        NN = round(area ./ delta);  
          
        % 根据输入图像和目标平面尺寸的关系，对图像进行填充或裁剪  
        if size(Image, 1) < NN(1) || size(Image, 2) < NN(2)  
            % 计算填充区域  
            aa = round((size(prop, 1) - size(Image, 1)) / 2);  
            bb = round((size(prop, 2) - size(Image, 2)) / 2);  
            if aa == 0  
                aa = aa + 1;  
            end  
            if bb == 0  
                bb = bb + 1;  
            end  
            % 创建填充后的图像  
            Image2 = zeros(size(prop));  
            Image2(aa:aa + size(Image, 1) - 1, bb:bb + size(Image, 2) - 1, :) = Image;  
            Image = Image2;  
            %计算结果
            result = IFT2Dc(FT2Dc(Image).*prop);
        elseif size(Image, 1) > NN(1) || size(Image, 2) > NN(2)  
            % 对结果进行裁剪  
            result = IFT2Dc(FT2Dc(Image) .* prop);  
            aa = round((size(result, 1) - NN(1)) / 2);  
            bb = round((size(result, 2) - NN(2)) / 2);  
            if aa == 0  
                aa = aa + 1;  
            end  
            if bb == 0  
                bb = bb + 1;  
            end  
            result = result(aa:aa + NN(1) - 1, bb:bb + NN(2) - 1);  
        else % 输入图像尺寸与目标平面尺寸相等  
            if size(Image, 1) == 1  
                % 特殊处理单行图像的情况(一维情况)  
                result = zeros(size(prop));  
                for ii = 1:size(prop, 1)  
                    result(ii, :) = IFT2Dc(FT2Dc(Image) .* prop(ii, :));  
                end  
            else  
                % 直接进行角谱衍射计算  
                result = IFT2Dc(FT2Dc(Image) .* prop);  
            end
        end  
    else % 进行缩放角谱计算（三次FFT）  
        if scale < 1  
            warning('scale should be bigger than 1');  
            return;  
        end  
          
        % 计算频率域的采样间隔  
        if size(area, 2) == 1  
            deltaFreq = [1 / area, 1 / area];  
        else  
            deltaFreq = 1 ./ area;  
        end  
          
        % 计算缩放因子  
        alpha = delta(1) / deltaFreq(1) / scale;  
          
        % 创建频率域坐标网格  
        x = -1 / delta(1) / 2 : deltaFreq(1) : 1 / delta(1) / 2 - deltaFreq(1);  
        y = -1 / delta(2) / 2 : deltaFreq(2) : 1 / delta(2) / 2 - deltaFreq(2);  
        [X, Y] = meshgrid(x, y);  
          
        % 计算初始角谱  
        A_ini = FT2Dc(Image) .* prop;  
          
        % 计算缩放因子1  
        factor1 = exp(1i * (pi * alpha) .* (X.^2 + Y.^2));  
          
        % 缩放角谱  
        B = A_ini .* factor1 / alpha;  
          
        % 计算缩放因子2的逆FFT  
        ff = exp(-1i * (pi * alpha) .* (X.^2 + Y.^2));  
        C = FT2Dc(IFT2Dc(B) .* IFT2Dc(ff));  
          
        % 计算最终结果  
        result = C .* factor1 .* alpha(1) .* delta(1);  
    end  
end