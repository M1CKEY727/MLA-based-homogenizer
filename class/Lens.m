classdef Lens < element  
    properties
        curRadius
        conic=0;
        polyCoe=0;
        focallength
    end
    methods (Static = true)  
        function lens = Lens(curRadius,thickness,diameter,material,waveLength)
            if nargin==1
                lens.focallength=curRadius;
            else
                lens.curRadius=curRadius;
                lens.thickness=thickness;
                if numel(diameter)==1
                    diameter=diameter.*ones(size(curRadius));
                end
                lens.diameter=diameter;
                lens.material=material;
                if exist('waveLength','var')
                    lens.n_curwl=calGlassRI(material,waveLength,'..\3rd\glassCat');
                    if lens.n_curwl==0
                        lens.n_curwl=calGlassRI(material,waveLength,'3rd\glassCat');
                    end
                end
            end
        end
        
        function indexOfLens(lens,waveLength,path)
            lens.n_curwl=calGlassRI(lens.material,waveLength,path);
        end

        function lensGPUArray(lens)
            lens.thick_edge=gpuArray(lens.thick_edge);
            lens.thick_mid=gpuArray(lens.thick_mid);
            lens.thick_air=gpuArray(lens.thick_air);
            lens.thick_edge_max=gpuArray(lens.thick_edge_max);
            lens.n_curwl=gpuArray(lens.n_curwl);
            lens.phase=gpuArray(lens.phase);
        end

        function lensSingle(lens)
            lens.thick_edge=single(lens.thick_edge);
            lens.thick_mid=single(lens.thick_mid);
            lens.thick_air=single(lens.thick_air);
            lens.thick_edge_max=single(lens.thick_edge_max);
            lens.n_curwl=single(lens.n_curwl);
            lens.phase=single(lens.phase);
        end
        
        function lensReverse(lens)
            lens.curRadius=flip(lens.curRadius);
            lens.thickness=flip(lens.thickness);
            lens.material=flip(lens.material);
            lens.diameter=flip(lens.diameter);
            if ~isempty(lens.thick_edge)
                lens.thick_edge=flip(lens.thick_edge,3);
                lens.thick_air=flip(lens.thick_air,3);
                lens.thick_mid=flip(lens.thick_mid);
                lens.thick_edge_max=flip(lens.thick_edge_max);
            end
            if ~isempty(lens.n_curwl)
                lens.n_curwl=flip(lens.n_curwl);
            end
        end

        function lensMinus(lens)
            lens.thick_edge=-lens.thick_edge;
            lens.thick_air=-lens.thick_air;
            lens.thick_mid=-lens.thick_mid;
            lens.thick_edge_max=-lens.thick_edge_max;
        end
        
        function lensPhase_paraxial(lens,area,delta,lambda)
            imsize=round(area./[delta delta]);
            x=linspace(-area/2,area/2-delta,imsize(2));
            y=linspace(-area/2,area/2-delta,imsize(1));
            [X,Y]=meshgrid(x,y);
            gama=-1i*pi/lambda/lens.focallength;
            lens.phase=exp(gama*(X.^2+Y.^2));
        end

        function phase=lensPhase(lens,D,lambda,N,type,P0)
            if nargin==5
                P0=zeros(1,2);
            end
            % 生成采样点的2D网格
            x = linspace(-D/2, D/2-D/N, N);
            if strcmp(type,'square')
                diameter=lens.diameter*sqrt(2);
            else
                diameter=lens.diameter;
            end
            [X, Y] = meshgrid(x+P0(1), x+P0(2));
            n=calMaterialRI(lens.material,lambda);
            % 初始化用于存储相位差的数组
            delta_edge = zeros(N, N, size(lens.thickness, 2) + 1);
            delta_mid = zeros(N, N, size(lens.thickness, 2));
            delta = zeros(N, N, size(lens.thickness, 2));
            delta_air = sum(lens.thickness,2)*ones(N,N);
            % 初始化相位矩阵
            phase = ones(N, N);
            
            
            % 初始化用于存储边缘厚度的数组
            t_edge = zeros(1, size(lens.thickness, 2) + 1);
            
            % 计算边缘相位差
             for ii = 1:size(lens.thickness, 2)+1
                if ~isinf(lens.curRadius(ii))
                    %num=mod(ii,2);
                    delta_edge(:,:,ii) = sqrt(lens.curRadius(ii)^2 - X.^2 - Y.^2) - sqrt(lens.curRadius(ii)^2 - (diameter(ii)/2)^2);
                    
                    t_edge(ii) = max(max(abs(delta_edge(:,:,ii))));
                    if ii==1
                        if lens.curRadius(ii)>0
                        delta_edge(:,:,ii)=t_edge(ii)-delta_edge(:,:,ii);
                        end
                    else
                        if lens.curRadius(ii)<0
                        delta_edge(:,:,ii)=t_edge(ii)-delta_edge(:,:,ii);
                        end
                    end
                end
            end
            % 计算中间层相位差
            for ii = 1:size(lens.thickness, 2)
                delta_mid(:,:,ii) = (lens.thickness(ii) - t_edge(ii) - t_edge(ii+1)) * ones(N, N);
                if ii==1
                    delta(:,:,ii) = delta(:,:,ii) + delta_edge(:,:,ii) + delta_edge(:,:,ii+1) + delta_mid(:,:,ii);
                else
                    delta(:,:,ii) = delta(:,:,ii) + (t_edge(ii)-delta_edge(:,:,ii)) + delta_edge(:,:,ii+1) + delta_mid(:,:,ii);
                end
                phase = exp(1i * 2 * pi * n(ii) / lambda * delta(:,:,ii)) .* phase;
                delta_air=delta_air-delta(:,:,ii);
            end
            % 乘以空气中的相位差
            lens.phase = phase .* exp(1i * 2 * pi / lambda * delta_air);
        end

        function lensThickFcn(lens,D, N, type,deviation)
            if ~strcmp(lens.type,'MLA')
                lens.type='lens';
            end
            if ~exist('deviation','var')
                deviation=zeros(size(lens.curRadius));
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
            if exist('type','var')&&strcmp(type,'square')
                diameter=lens.diameter*sqrt(2);
            else
                diameter=lens.diameter;
            end
            [X, Y] = meshgrid(x, y);
            
            % 初始化用于存储相位差的数组
            delta_edge = zeros(M, N, size(lens.thickness, 2) + 1);
            delta_air = zeros(M,N,2);
            aper=zeros(M,N,size(lens.thickness, 2) + 1);
            % 初始化用于存储边缘厚度的数组
            delta_mid = lens.thickness;
            t_edge = zeros(1, size(lens.thickness, 2) + 1);
            
            % 计算边缘相位差
            for ii = 1:size(lens.thickness, 2)+1
                if ~isinf(lens.curRadius(ii))
                    delta_edge(:,:,ii) = sqrt(lens.curRadius(ii)^2 - (X+deviation(ii)).^2 - Y.^2)...
                    - sqrt(lens.curRadius(ii)^2 - (diameter(ii)/2)^2);
                    if imag(delta_edge(:,:,ii))~=zeros(size(delta_edge(:,:,ii)))
                        delta_edge(:,:,ii)=real(delta_edge(:,:,ii));
                    end
                    t_edge(ii) = max(max(delta_edge(:,:,ii)));
                    if ii==1
                        if lens.curRadius(ii)>0
                        delta_edge(:,:,ii)=t_edge(ii)-delta_edge(:,:,ii);
                        end
                    else
                        if lens.curRadius(ii)<0
                        delta_edge(:,:,ii)=t_edge(ii)-delta_edge(:,:,ii);
                        end
                    end

                end
                if strcmp(lens.type,'lens')
                    lens_SemiDia=lens.diameter(ii)/2; 
                    aper(:,:,ii)=drawCircle(lens_SemiDia*N/D,0,0,M,N);
                    delta_edge(:,:,ii)=delta_edge(:,:,ii).*aper(:,:,ii);
                end
            end
            delta_air(:,:,1)=t_edge(1)-delta_edge(:,:,1);
            delta_air(:,:,2)=t_edge(end)-delta_edge(:,:,end);
            
            
            % 计算中间层相位差
            for ii = 1:size(lens.thickness, 2)
                if lens.curRadius(ii)<0
                    delta_mid(ii)=delta_mid(ii) - t_edge(ii);
                end
                if lens.curRadius(ii+1)>0
                    delta_mid(ii)=delta_mid(ii) - t_edge(ii+1);
                end
            end
            lens.thick_edge=delta_edge;
            lens.thick_mid=delta_mid;
            lens.thick_air=delta_air;
            lens.thick_edge_max=t_edge;
            lens.aper=aper;
        end

        function lensThickFcnGnr(lens,D, N, type,deviation)
            if ~strcmp(lens.type,'MLA')
                lens.type='lens';
            end
            if ~exist('deviation','var')
                deviation=zeros(size(lens.curRadius));
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
            if exist('type','var')&&strcmp(type,'square')
                diameter=lens.diameter*sqrt(2);
            else
                diameter=lens.diameter;
            end
            [X, Y] = meshgrid(x, y);
            
            % 初始化用于存储相位差的数组
            delta_edge = zeros(M, N, size(lens.thickness, 2) + 1);
            delta_air = zeros(M,N,2);
            aper=zeros(M,N,size(lens.thickness, 2) + 1);
            % 初始化用于存储边缘厚度的数组
            delta_mid = lens.thickness;
            t_edge = zeros(1, size(lens.thickness, 2) + 1);
            
            % 计算边缘相位差
            for ii = 1:size(lens.thickness, 2)+1
                X=X+deviation(ii);
                [~,R]=cart2pol(X,Y);
                if ~isinf(lens.curRadius(ii))
                    delta_edge(:,:,ii) = (R.^2)./(-lens.curRadius(ii)*(1+sqrt(1-(1+lens.conic)*(R.^2)./lens.curRadius(ii)^2)))+polyval(lens.polyCoe,R);
                    t_edge(ii)=((diameter(ii)/2)^2)./(-lens.curRadius(ii)*(1+sqrt(1-(1+lens.conic)*((diameter(ii)/2)^2)./lens.curRadius(ii)^2)))+polyval(lens.polyCoe,(diameter(ii)/2));
                    t_edge=abs(t_edge);
                    if imag(delta_edge(:,:,ii))~=zeros(size(delta_edge(:,:,ii)))
                        delta_edge(:,:,ii)=real(delta_edge(:,:,ii));
                    end
                end
                if ii==1
                    if lens.curRadius(ii)>0
                        delta_edge(:,:,ii)=-delta_edge(:,:,ii);
                    else
                        delta_edge(:,:,ii)=t_edge(ii)-delta_edge(:,:,ii);
                    end
                else
                    if lens.curRadius(ii)>0
                    delta_edge(:,:,ii)=t_edge(ii)+delta_edge(:,:,ii);
                    end
                end
                if strcmp(lens.type,'lens')
                    lens_SemiDia=lens.diameter(ii)/2; 
                    aper(:,:,ii)=drawCircle(lens_SemiDia*N/D,0,0,M,N);
                    %delta_edge(:,:,ii)=delta_edge(:,:,ii).*aper(:,:,ii);
                end
            end
            delta_air(:,:,1)=t_edge(1)-delta_edge(:,:,1);
            delta_air(:,:,2)=t_edge(end)-delta_edge(:,:,end);
            
            
            % 计算中间层相位差
            for ii = 1:size(lens.thickness, 2)
                if lens.curRadius(ii)<0
                    delta_mid(ii)=delta_mid(ii) - t_edge(ii);
                end
                if lens.curRadius(ii+1)>0
                    delta_mid(ii)=delta_mid(ii) - t_edge(ii+1);
                end
            end
            lens.thick_edge=delta_edge;
            lens.thick_mid=delta_mid;
            lens.thick_air=delta_air;
            lens.thick_edge_max=t_edge;
            lens.aper=aper;
        end

        function lensArrayPhase(lens,lambda, N,num)
            singleLens=Lens.lensPhase(lens,lens.diameter,lambda, N,'square');
            lens.phase = repmat(singleLens, num, num);
        end  

        function lensArrayThickFcn(lens,N,num,type,angle,valid_l,deviation)
            lens.type='MLA';
            if exist('deviation','var')
                dev=deviation/(lens.diameter(1)/N);
            else
                dev=0;
            end
            if nargin==3||strcmp(type,'square')
                Lens.lensThickFcn(lens,lens.diameter(1), N, type)
                if ~isinteger(num)
                    num2=num;
                    num=ceil(num);
                end

                lens.thick_edge = repmat(lens.thick_edge, num, num);
                lens.thick_air = repmat(lens.thick_air, num, num);
                NN=N*num;
                if exist('num2','var')
                    NN=round(N*num2);
                    sz=N*num;
                    pos=round((sz-NN)/2);
                    if pos==0
                        pos=1;
                    end
                    lens.thick_edge=lens.thick_edge(pos:pos+NN-1,pos:pos+NN-1,:);
                    lens.thick_air=lens.thick_air(pos:pos+NN-1,pos:pos+NN-1,:);
                end
                if exist('valid_l','var')
                    valid_l_n=round((valid_l)/(lens.diameter(1)/N));
                    
                    square=drawRect([N,N],[valid_l_n,valid_l_n],0,0,0);
                    square=repmat(square, num, num);
                    if exist('num2','var')
                        square=square(pos:pos+NN-1,pos:pos+NN-1);
                    end
                    %coor_0=1-square;
                    
                    for ii=1:2
                        %coor_0=coor_0.*(randn(size(coor_0))/16+1);
                        %square1=square+coor_0;
                        index=round((N-valid_l_n)/2);
                        if index==0
                            index=1;
                        end
                        value=lens.thick_edge(index,index,ii);
                        square1=1-square;
                        lens.thick_edge(:,:,ii)=lens.thick_edge(:,:,ii).*square;
                        lens.thick_edge(:,:,ii)=lens.thick_edge(:,:,ii)+square1.*value;
                        lens.thick_air(:,:,ii)=lens.thick_edge_max(ii)*ones(NN)-lens.thick_edge(:,:,ii);
                    end
                end
            elseif strcmp(type,'hexagon')
                M = round(3*N  / sqrt(3));
                Lens.lensThickFcn(lens,lens.diameter(1), [M,N], 'square')
                if exist('valid_l','var')
                    valid_l_n=round((valid_l)/(lens.diameter(1)/N));
                    hexagon = drawHexagon(0, 0, valid_l_n(1)/2, [M,N], 0);
                else
                    hexagon = drawHexagon(0, 0, N/2, [M,N], 0);
                end
                for ii=1:2
                    lens.thick_edge(:,:,ii)=lens.thick_edge(:,:,ii).*hexagon;
                end
                delta_edge_1 = repmat(lens.thick_edge, [num-2, num-1]);
                delta_edge_2 =  repmat(lens.thick_edge, [num-3, num]);
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
                lens.thick_edge=delta_edge_1+delta_edge_2;
                diff=(size(lens.thick_edge,1)-size(lens.thick_edge,2))/2;
                delta_edge_3=lens.thick_edge(round(diff):size(lens.thick_edge,2)+round(diff)-1,:,:);
                
                lens.thick_edge=delta_edge_3;
                lens.thick_air=zeros(size(lens.thick_edge));
                lens.thick_air(:,:,1)=lens.thick_edge_max(1)-lens.thick_edge(:,:,1);
                lens.thick_air(:,:,2)=lens.thick_edge_max(end)-lens.thick_edge(:,:,end);
            end
            if nargin>=5 && angle~=0
                lens.thick_edge=imrotate(lens.thick_edge,angle,'nearest','crop');
                lens.thick_air=imrotate(lens.thick_air,angle,'nearest','crop');
            end
            lens.thick_edge(:,:,2)=circshift(lens.thick_edge(:,:,2),round(dev),2);
            lens.thick_air(:,:,2)=circshift(lens.thick_air(:,:,2),round(dev),2);
        end
    end
end