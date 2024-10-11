clc;
clear;
close all;
N=2000;
area=7.5;
lambda=647e-6;
addpath('plane wave\')
delta=area/N;
X=linspace(-area/2,area/2,N);
[XX,YY]=meshgrid(X,X);
beamStd=2.4;
beam=GaussianBeam(1,beamStd,lambda);
profile=GaussianBeam.waistProfile(beam,N,[delta,delta]);

diffuserAngle=1.5;   %散射片散射角度
diffuser=Diffuser(diffuserAngle,lambda);
%{
phase_grad=deg2rad(diffuserAngle)*2*pi/lambda;
cohLength=pi/phase_grad;
sigma_f = 2.5*cohLength;
sigma_r = sqrt(4 * pi * sigma_f^4 / cohLength^2);
%}
N=gpuArray(single(N));
Diffuser.diffuserSingle(diffuser)
Diffuser.diffuserGPUArray(diffuser)
delta=gpuArray(single(delta));
phase=Diffuser.generateDiffuser(diffuser,delta,[N,N]);
phase1=angle(gather(phase));
phase1=unwrap(phase1,[],2);
phase1=unwrap(phase1,[],1);
%imshow(angle(phase),[])
%colormap jet
%cb1=colorbar;

%%
%{
phase_mean=ones(N,N);
%phase_fft=fftshift(fft(phase),1);
for ii=1:(size(phase,1)-size(phase,2))
    phase_mean=phase_mean.*phase(ii:ii+N-1,:);
    %imshow(angle(phase(ii:ii+N-1,:)),[])
end
%phase_mean=exp(1i*angle(phase_mean)/(size(phase,1)-size(phase,2)));
corr=autoCorr2D(phase(ii:ii+N-1,:));
imshow(abs(corr),[])

%%
%imshow(angle(phase_mean),[])
corr_beam=autoCorr2D(profile);
imshow(abs(corr_beam),[])
%%
corr_beams=corr_beam.*corr;
%II=transform(corr_beams,area,lambda,0,[area/N,area/N]);
F=FT2Dc(corr_beam.*corr);
imshow(abs(F),[])
%%
%}
%{
set(cb1,'YTick',gather(linspace(min(min(angle(phase))), ...
    max(max(angle(phase))),3))); %色标值范围及显示间隔
set(cb1,'YTickLabel',{'-π','0','π'}) %具体刻度赋值
set(cb1,'FontName','Times New Roman','FontSize',25)
filename=['散射片仿真/' num2str(diffuserAngle) '.pdf'];
%}
%print(['散射片仿真/' num2str(diffuserAngle) '°.eps'],'-depsc','-r600');
%saveas(gca, ['散射片仿真/' num2str(diffuserAngle) '°.eps'], 'epsc');
%exportgraphics(gca,filename)
%set(gcf,'paperpositionmode','auto');
%print(gcf,'-depsc2','file.pdf');


phase1=phase1(1:N,1:N);
[gradX,gradY]=gradient(phase1,X,X);
thetaX1=rad2deg(lambda/2/pi*gradX);
maxX=max(max(thetaX1));
minX=min(min(thetaX1));
thetaX1=(thetaX1-minX)/(maxX-minX);
histX=imhist(thetaX1);
histX=histX/max(histX);
Theta=linspace(minX,maxX,256);
figure
set(gcf,'position',[0 0 500 500])
bar(Theta,histX,'FaceColor',([250,127,111])/256)
%xticks([-1,-0.5,-0.25,0,0.25,0.5,1])
hold on
plot([diffuserAngle/2,diffuserAngle/2,-diffuserAngle/2, ...
    -diffuserAngle/2], ...
    [0,histX(round((diffuserAngle/2-minX)/(maxX-minX)*256)), ...
    histX(round((diffuserAngle/2-minX)/(maxX-minX)*256)),0], ...
    'LineStyle','--','LineWidth',3,'Color',([130,176,210])/256)
hold off
grid on
set(gca,'FontName','Times New Roman','FontSize',25,'LineWidth',2)
ylabel('Frequency distribution','FontName','Times New Roman','FontSize',25)
xlabel('Scattering angle/°','FontName','Times New Roman','FontSize',25)
filename=['散射片仿真/' num2str(diffuserAngle) 'curve.pdf'];
axis square
set(gca,'looseInset',[0 0 0 0])
exportgraphics(gca,filename)

pos=get(gca,'Position');


figure
imshow(phase1,[])

set(gcf,'position',[0 0 500 500])
pos2=get(gca,'position');
pos2(3:4)=pos(3:4);
pos2(1)=0;
pos2(2)=pos(2);
colormap jet
cb2=colorbar('LineWidth',2);
minP=min(min(phase1));
maxP=max(max(phase1));
phase2=(phase1-minP)/(maxP-minP);
minX=ceil(minP/pi);
maxX=floor(maxP/pi);
set(cb2,'YTick',gather(linspace(minX*pi,maxX*pi,maxX-minX+1))); %色标值范围及显示间隔
ticks=num2cell(gather(linspace(minX,maxX,maxX-minX+1)));
tickss=cell(size(ticks));
for ii=1:length(ticks)
    ticks{ii}=[num2str(ticks{ii}) '\pi'];
end
set(cb2,'YTickLabel',ticks) %具体刻度赋值
set(cb2,'FontName','Times New Roman','FontSize',25)
set(gca,'position',pos2)
axis square
filename=['散射片仿真/' num2str(diffuserAngle) 'unwrapped.pdf'];
exportgraphics(gca,filename)
%{
num=256;
gradl=zeros(size(gradX,1),size(gradX,2),num);
hist=zeros(256,num);
hhist=zeros(256,256);
delta_angle=(maxX-minX)/256;
[TX,TY]=meshgrid(Theta,Theta);
[tt,rr]=cart2pol(TX,TY);
for ii=1:num
    alpha=ii;
    gradl(:,:,ii)=gradX.*cos(alpha)+gradY.*sin(alpha);
    thetaL=rad2deg(lambda/2/pi*gradl(:,:,ii));
    maxL=max(max(thetaL));
    minL=min(min(thetaL));
    thetaL=(thetaL-minL)/(maxL-minL);
    hist(:,ii)=imhist(thetaL);
    hist(:,ii)=hist(:,ii)/max(hist(:,ii));
end
theta=linspace(1,90,num);
%}
%%
thetaX=rad2deg(lambda/2/pi*gradX);
thetaY=rad2deg(lambda/2/pi*gradY);
sz=200;
%quiver3(ones(length(1:sz:2000)),ones(length(1:sz:2000)),ones(length(1:sz:2000),1)*(1:sz:2000),ones(size(thetaX(1:sz:2000,1:sz:2000))),thetaX(1:sz:2000,1:sz:2000),thetaY(1:sz:2000,1:sz:2000))

thetaZ=acosd(sqrt(1-cosd(thetaX).^2-cosd(thetaY).^2));

maxZ=max(max(thetaZ));
minZ=min(min(thetaZ));
thetaZ1=(thetaZ-minZ)/(maxZ-minZ);
delta2=1/area*lambda*100;
%%
%{
figure(1)
imshow(thetaZ,[])
hist=imhist(thetaZ1);
figure(2)
plot(linspace(minZ,maxZ,256),hist,"LineWidth",2,'Color','r')
xlabel('角度/°','FontSize',20)
ylabel('像素数量','FontSize',20)
grid on
hold on
plot([diffuserAngle,diffuserAngle],
[0,hist(round(diffuserAngle/maxZ*256))],
'LineStyle','--','LineWidth',3,'Color','b')
    
    P1=FT2Dc(phase);
    corr=IFT2Dc(P1.*conj(P1));
    %corr=abs(corr);
    %corr=(corr-min(min(corr)))./(max(max(corr))-min(min(corr)));
    subplot(1,2,1)
    p1=FT2Dc(corr);
    mesh(abs(corr))
    %mesh(corr)
    x=linspace(-N/2*delta,(N/2-1)*delta,N);
    [X,Y]=meshgrid(x,x);
    R=exp(-(X.^2+Y.^2)/(diffuser.cohLength)^2);
    p=FT2Dc(R);
    subplot(1,2,2)
    mesh(R)
    phase=angle(gather(phase));
    phase=unwrap(phase,[],2);
    phase=unwrap(phase,[],1);
    [gradX,gradY]=gradient(phase,x,x);
    %imshow(gradY,[])
    %subplot(1,2,2)
    %mesh(R)
    %a=fftshift(fft2(phase));
    %imshow(abs(a).^2,[]);
    %{
    
    phase=unwrap(phase,[],2);
    phase=unwrap(phase,[],1);
    x=linspace(-N/2*delta,(N/2-1)*delta,N);
    %subplot(1,2,2)
    subplot(1,2,2)
    imshow(phase,[])
    %}
    %{
    gradi=gradient(phase,x,x);
    xx=rad2deg(atan(linspace(min(min(gradi)),max(max(gradi)),256)*(640e-6)/2/pi));
    grad=(gradi-min(min(gradi)))./(max(max(gradi))-min(min(gradi)));
    hist=imhist(grad);
    subplot(1,2,2)
    plot(xx,hist)
    %}
    %imshow(gradi,[])
    %a=rad2deg(atan(max(max(abs(gradi)))*640e-6/2/pi));
    %disp(a)
%end
    %}
    