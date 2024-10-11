classdef Axicons<element
    properties
        apex
    end
    methods (Static = true) 
        function axiscon = Axicons(apex,thickness,diameter,material,waveLength)
            axiscon.curRadius=apex;
            axiscon.thickness=thickness;
            if numel(diameter)==1
                diameter=diameter.*ones(size(apex));
            end
            axiscon.diameter=diameter;
            axiscon.material=material;
            if exist('waveLength','var')
                axiscon.n_curwl=calGlassRI(material,waveLength,'C:\Users\M1CKEY\Documents\Zemax\Glasscat');
            end
        end

        %function axisconThickFcn(axiscon,)
    end
end