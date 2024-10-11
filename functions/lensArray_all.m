%计算微透镜阵列厚度函数（已弃用，请使用Lens类）
function [delta_edge,delta_mid,delta_air,t_edge]=lensArray_all(r,l,t,N,num,type,angle,valid_l)
if nargin<6||strcmp(type,'square')
    [delta_edge,delta_mid,delta_air,t_edge]=lensPhase_all(r,l,l,t, N,'square');
    if exist('valid_l','var')
        valid_l_n=round((valid_l)/(l/N));
        square=drawSquare(size(delta_edge,1),valid_l_n,0,0);
        for ii=1:2
            delta_edge(:,:,ii)=delta_edge(:,:,ii).*square;
            delta_air(:,:,ii)=t_edge(ii)*ones(N)-delta_edge(:,:,ii);
        end
    end
    delta_edge = repmat(delta_edge, num, num);
    delta_air = repmat(delta_air, num, num);
elseif strcmp(type,'hexagon')
    M = round(3*N  / sqrt(3));
    [delta_edge,delta_mid,~,t_edge]=lensPhase_all(r,l,l,t, [M,N],'square');
    if exist('valid_l','var')
        valid_l_n=round((valid_l)/(l/N));
        hexagon = drawHexagon(0, 0, valid_l_n/2, [M,N], 0);
    else
        hexagon = drawHexagon(0, 0, N/2, [M,N], 0);
    end
    for ii=1:2
        delta_edge(:,:,ii)=delta_edge(:,:,ii).*hexagon;
    end
    delta_edge_1 = repmat(delta_edge, [num-2, num-1]);
    delta_edge_2 =  repmat(delta_edge, [num-3, num]);
    delta_edge_1 = padarray(delta_edge_1, [0, round(N/2)],'symmetric'); 
    
    delta_edge_2 = padarray(delta_edge_2, [round(3*N/sqrt(3)/2), 0],'symmetric');
    if(size(delta_edge_2,1)<size(delta_edge_1,1))
        delta_edge_2(end+1,:,:)=delta_edge_2(end,:,:);
    elseif(size(delta_edge_2,1)>size(delta_edge_1,1))
        delta_edge_2=delta_edge_2(1:end-1,:,:);
    end
    if(size(delta_edge_2,2)<size(delta_edge_1,2))
        delta_edge_2(:,end+1,:)=delta_edge_2(:,end,:);
    elseif(size(delta_edge_2,2)>size(delta_edge_1,2))
        delta_edge_2=delta_edge_2(:,1:end-1,:);
    end
    delta_edge=delta_edge_1+delta_edge_2;
    diff=(size(delta_edge,1)-size(delta_edge,2))/2;
    delta_edge_3=delta_edge(round(diff):size(delta_edge,2)+round(diff)-1,:,:);
    delta_edge=delta_edge_3;
    delta_air=zeros(size(delta_edge));
    delta_air(:,:,1)=t_edge(1)-delta_edge(:,:,1);
    delta_air(:,:,2)=t_edge(end)-delta_edge(:,:,end);
end
if nargin<=7 && angle~=0
    delta_edge=imrotate(delta_edge,angle,'nearest','crop');
    delta_air=imrotate(delta_air,angle,'nearest','crop');
end
end