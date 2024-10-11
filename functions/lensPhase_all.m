%计算透镜厚度函数（已弃用，请使用Lens类）
% r: 曲率半径向量
% d: 透镜半径
% t: 透镜厚度向量
% n: 透镜折射率向量
% lambda: 波长
% N: 采样点数
% device: 如果使用GPU则为 'GPU'，否则为其他任意值

function  varargout = lensPhase_all(r,d,D,t, N, type,P0)
if nargin<=6
    P0=zeros(1,2);
end
if numel(N)==1
    M=N;
else
    M=N(1);
    N=N(2);
end
    D2=D/N*M;
    % 生成采样点的2D网格
    x = linspace(-D/2, D/2-D/N, N);
    y = linspace(-D2/2, D2/2-D2/M, M);
    if strcmp(type,'square')
        d=d*sqrt(2);
    end
    [X, Y] = meshgrid(x+P0(1), y+P0(2));
    
    % 初始化用于存储相位差的数组
    delta_edge = zeros(M, N, size(t, 2) + 1);
    delta_air = zeros(M, N, size(t, 2));
    
    
    % 初始化用于存储边缘厚度的数组
    delta_mid = zeros(1,size(t, 2));
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
    delta_air(:,:,1)=t_edge(1)-delta_edge(:,:,1);
    delta_air(:,:,2)=t_edge(end)-delta_edge(:,:,end);
    
    
    % 计算中间层相位差
    for ii = 1:size(t, 2)
        delta_mid(ii) = (t(ii) - t_edge(ii) - t_edge(ii+1));
    end
    varargout{1}=delta_edge;
    varargout{2}=delta_mid;
    varargout{3}=delta_air;
    varargout{4}=t_edge;
end