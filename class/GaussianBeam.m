classdef GaussianBeam < handle  
    properties
        amplitude;
        beamStd;
        waveLength;
    end
    methods (Static = true)  
    function GSB = GaussianBeam(a, Std,lbd)
        GSB.amplitude=a;
        GSB.beamStd=Std;
        GSB.waveLength=lbd;
    end
    % 返回一个描述2D光束剖面的函数的采样
    function profile = waistProfile(beam,N,delta)
        if numel(delta)==1
            delta=[delta,delta];
        end
        x=linspace(-N*delta(1)/2,(N-1)*delta(1)/2,N);
        y=linspace(-N*delta(2)/2,(N-1)*delta(2)/2,N);
        [X,Y]=meshgrid(x,y);
        profile=beam.amplitude * exp(-(X.^2+Y.^2) / (2 * beam.beamStd^2));
    end
    % 返回在任意平面上的高斯光束场
    function profile = defocused(beam, position,N,delta)
        if position==0
            profile=GaussianBeam.waistProfile(beam,N,delta);
            return
        end
        x=linspace(-N*delta(1)/2,(N-1)*delta(1)/2,N);
        [X,Y]=meshgrid(x,x);
        % 计算光束腰部
        waist = sqrt(2) * beam.beamStd;
        % 计算波数
        wavenumber = 2 * pi / beam.waveLength;
        % 计算光束半径、曲率半径和Gouy相位
        beamRad = GaussianBeam.wz(position, waist, beam.waveLength);
        beamRoc = GaussianBeam.roc(position, waist, beam.waveLength);
        GouyPhase = GaussianBeam.gouyPhase(position, waist, beam.waveLength);
        profile=beam.amplitude * sqrt(waist / beamRad) ...
            * exp(-(X.^2+Y.^2) / beamRad.^2) ...
            .* exp(1j * wavenumber * position ...
            + 1j * wavenumber * (X.^2+Y.^2) / (2 * beamRoc) ...
            - 1j * GouyPhase);
    end
    
    % 计算任意轴向位置的光束半径
    function wz = wz(position, waist, wavelength)
        % 计算Rayleigh范围
        zR = pi * waist^2 / wavelength;
        wz = waist * sqrt(1 + (position / zR).^2);
    end
    
    % 计算任意轴向位置的曲率半径
    function roc = roc(position, waist, wavelength)
        % 计算Rayleigh范围
        zR = pi * waist^2 / wavelength;
        if position ~= 0
            roc = position * (1 + (zR / position)^2);
        else
            roc = 0;
        end
    end
    
    % 计算高斯光束的Gouy相位
    function gouyPhase = gouyPhase(position, waist, wavelength)
        % 计算Rayleigh范围
        zR = pi * waist^2 / wavelength;
        gouyPhase = atan(position / zR);
    end

    function beam_noised = beamNoise(beam_no_noise,ratio,ratio2)
        beamAmp=abs(beam_no_noise)+randn(size(beam_no_noise))*ratio.*(abs(beam_no_noise)+ratio2);
        phase=angle(beam_no_noise)+randn(size(beam_no_noise))*ratio;
        beam_noised=beamAmp.*exp(1i*phase);
    end
    end  
end