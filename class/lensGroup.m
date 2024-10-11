classdef lensGroup < handle 
    properties
        group
    end
    methods (Static = true)  
        function lensgroup=lensGroup(varargin)
            lensgroup.group=varargin;
        end
    end
end