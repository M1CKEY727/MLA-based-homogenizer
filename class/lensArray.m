classdef lensArray < Lens  
    properties

    end
    methods (Static = true)  
        function LensArray = Lens(curRadius,thickness,diameter,material,waveLength)
            LensArray.curRadius=curRadius;
            LensArray.thickness=thickness;
            LensArray.diameter=diameter;
            LensArray.material=material;
            if exist('waveLength','var')
                LensArray.n_curwl=calGlassRI(material,waveLength,'C:\Users\M1CKEY\Documents\Zemax\Glasscat');
            end
        end

        function lensArrayThickFcn2(lensarray,N,num,type,angle,valid_l,deviation)
            if ~isinteger(N)
                N2=ceil(N);
            end
            if ~isinteger(num)
                num2=ceil(num);
            end
            Lens.lensArrayThickFcn(lensarray,N2,num2,type,angle,valid_l,deviation)
            if size(lensarray.thick_edge,1)>N*num
                lensarray.thick_edge=lensarray.thick_edge(1:round(N*num),1:round(N*num),:);
                lensarray.thick_air=lensarray.thick_air(1:round(N*num),1:round(N*num),:);
            end
        end
    end
end