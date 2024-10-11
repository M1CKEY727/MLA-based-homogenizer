classdef Diffuser < handle  
    properties
        diffuserAngle
        cohLength
        sigma_r
        sigma_f
    end
    methods (Static = true)  
    function diffuser = Diffuser(diffuserAngle,lambda)
        diffuser.diffuserAngle=diffuserAngle;
        phase_grad=deg2rad(diffuserAngle)*2*pi/lambda;
        diffuser.cohLength=pi/phase_grad;
        diffuser.sigma_f = 2.5 * diffuser.cohLength;
        diffuser.sigma_r = sqrt(4 * pi * diffuser.sigma_f^4 / diffuser.cohLength^2);
    end

    function diffuserSingle(diffuser)
        diffuser.sigma_r=single(diffuser.sigma_r);
        diffuser.sigma_f=single(diffuser.sigma_f);
    end

    function diffuserGPUArray(diffuser)
        diffuser.sigma_r=gpuArray(diffuser.sigma_r);
        diffuser.sigma_f=gpuArray(diffuser.sigma_f);
    end

    function [phase1,phase2] = generateDiffuser(diffuser,delta,beamSize)
        L1=delta*beamSize(2);
        L2=delta*beamSize(1);
        
        dfx1=1/L1; 
        dfy1=1/L2; 
        fx1=linspace(-1/(2*delta),1/(2*delta)-dfx1,beamSize(2));
        fy1=linspace(-1/(2*delta),1/(2*delta)-dfy1,beamSize(1));
        fx1=fftshift(fx1);
        fy1=fftshift(fy1);
        if beamSize(1)~=1&&beamSize(2)~=1
        [FX1,FY1]=meshgrid(fx1,fy1); 
        else
            FX1=0;
            FY1=fy1;
        end

        F=exp(-pi^2*diffuser.sigma_f^2*(FX1.^2+FY1.^2)); 
        
        % make 2 random screens
        
        fie=(ifft2(F.*(randn(beamSize(1),beamSize(2))+1j*randn(beamSize(1),beamSize(2))))... 
        *diffuser.sigma_r/sqrt(dfx1*dfy1))*(beamSize(1)*beamSize(2))*dfx1*dfy1;
        
        %{
        fie=(ifft2(F.*(randn(beamSize(1),beamSize(2))+1j*randn(beamSize(1),beamSize(2))))... 
        *diffuser.sigma_r/dfx1)*(beamSize(1)*beamSize(2))*dfx1^2;
        %}
        % 返回相位屏
        phase1 = exp(1j * real(fie));
        phase2 = exp(1j * imag(fie));
    end
    end
end