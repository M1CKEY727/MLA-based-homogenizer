%计算透镜相位（已弃用，请使用Lens类）
% r: 曲率半径向量
% d: 透镜半径
% t: 透镜厚度向量
% n: 透镜折射率向量
% lambda: 波长
% N: 采样点数
% device: 如果使用GPU则为 'GPU'，否则为其他任意值

function phase = lensPhase(r, d,D,t, n, lambda, N, type,P0)
if nargin<=8
    P0=zeros(1,2);
end
    % 生成采样点的2D网格
    x = linspace(-D/2, D/2-D/N, N);
    if strcmp(type,'square')
        d=d*sqrt(2);
    end
    [X, Y] = meshgrid(x+P0(1), x+P0(2));
    
    % 初始化用于存储相位差的数组
    delta_edge = zeros(N, N, size(t, 2) + 1);
    delta_mid = zeros(N, N, size(t, 2));
    delta = zeros(N, N, size(t, 2));
    delta_air = sum(t,2)*ones(N,N);
    % 初始化相位矩阵
    phase = ones(N, N);
    
    % 初始化用于存储边缘厚度的数组
    t_edge = zeros(1, size(t, 2) + 1);
    
    % 计算边缘相位差
    for ii = 1:size(t, 2)+1
        if ~isinf(r(ii))
            num=mod(ii,2);
            delta_edge(:,:,ii) = sqrt(r(ii)^2 - X.^2 - Y.^2) - sqrt(r(ii)^2 - (d/2)^2);
            t_edge(ii) = max(max(abs(delta_edge(:,:,ii))));
            if num&&ii<size(r,2)
                if r(ii)>0
                    delta_edge(:,:,ii)=t_edge(ii)-delta_edge(:,:,ii);
                end
            else
                if r(ii)<0
                    delta_edge(:,:,ii)=t_edge(ii)-delta_edge(:,:,ii);
                end
            end
        end
    end

    
    
    % 计算中间层相位差
    for ii = 1:size(t, 2)
        delta_mid(:,:,ii) = (t(ii) - t_edge(ii) - t_edge(ii+1)) * ones(N, N);
        if ii==1
            delta(:,:,ii) = delta(:,:,ii) + delta_edge(:,:,ii) + delta_edge(:,:,ii+1) + delta_mid(:,:,ii);
        else
            delta(:,:,ii) = delta(:,:,ii) + (t_edge(ii)-delta_edge(:,:,ii)) + delta_edge(:,:,ii+1) + delta_mid(:,:,ii);
        end
        phase = exp(1i * 2 * pi * n(ii) / lambda * delta(:,:,ii)) .* phase;
        delta_air=delta_air-delta(:,:,ii);
    end
    % 乘以空气中的相位差
    phase = phase .* exp(1i * 2 * pi / lambda * delta_air);
end