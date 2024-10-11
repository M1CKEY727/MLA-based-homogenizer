N=1000;
D=4.1e-2;
rate=D/N;
lambda=1310e-6;
k0=2*pi/(lambda*10);%波数
%单模光纤
sL=40; %单模光纤长度
a0=4.1e-3;%单模光纤纤芯半径
nclS=1.4500;%包层折射率
ncoS=1.4544;%纤芯折射率
lambdap=2*lambda/(nclS+ncoS);
%%
phase=exp(1i*2*pi);
fibermask=drawCircle(a0/rate,0,0,N,N).*phase;
imshow(angle(fibermask),[])
fibermask=fibermask(N/2,:);

beamAmp=1;
beamSize=a0;
beamStd=beamSize/2.85;
beam=GaussianBeam(beamAmp,beamStd,lambda);
beams=GaussianBeam.waistProfile(beam,N,rate);
beams=beams(N/2,:);

distance=100e-3;
step=distance/lambdap;
for ii=1:round(step)
    F=beams.*fibermask;
    F=transform(F, [rate,D], lambda,lambdap , [rate, rate]);
end


