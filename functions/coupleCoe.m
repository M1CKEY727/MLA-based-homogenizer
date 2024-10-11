%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%该函数用于计算单模光纤耦合多模光纤的各模式耦合系数和纵向传播常数
%输入参数:ncoM:n of core of Multimode fiber 多模光纤纤芯折射率
%         nclM:n of cladding of Multimode fiber 多模光纤包层折射率
%         ncoS:n of core of Singlemode fiber 单模光纤纤芯折射率
%         nclM:n of cladding of Singlemode fiber 单模光纤包层折射率
%         lambda:波长
%         a:多模光纤纤芯半径
%         a0:单模光纤纤芯半径
%输出参数:etav:各模式耦合系数组成的向量
%         beta:各模式纵向传播常数组成的向量
%         Vm:多模光纤归一化频率
%         Vs:单模光纤归一化频率
%         w:单模光纤内高斯光束半宽高
%参考文献:[1]钟迪. 基于SMS光纤结构滤波器的研究与制作[D].哈尔滨工程大学,2015.
%        :[2]梁海东. 单模-多模-单模光纤结构在骨折患者术后康复监测中的传感应用研究[D].
%            哈尔滨工程大学,2021. 
%         [3]Chrisada Sookdhis,Ting Mei,Hery Susanto Djie. Wavelength Monitoring With Low-Contrast Multimode Interference Waveguide[J]. 
%            IEEE Photonics Technology Letters,2005,17(4).
function [etav,beta,Vm,Vs,w]=coupleCoe(ncoM,nclM,ncoS,nclS,lambda,a,a0)
%计算波数
k0=2*pi/lambda;
%计算多模光纤归一化频率
Vm=k0*a*sqrt(ncoM^2-nclM^2);
%计算单模光纤归一化频率
Vs=k0*a0*sqrt(ncoS^2-nclS^2);
%计算模式数
M=floor(Vm/pi);
%单模光纤内高斯光束半宽高
w=a0*(0.65+1.619*Vs^(-1.5)+2.879*Vs^(-6))/sqrt(log(2));
%%
%计算激励系数
mode=linspace(1,M,M);
u=(mode-1/4)*pi;
g=w/a;
c1=sqrt(Vm^2-u.^2);
numerator=2*exp(-1*(g^2)*(u.^2)/2)*(g^2);
c=((besselk(1,c1)).^2)./((besselk(0,c1)).^2);%系数
coor=isnan(c);
c(coor)=1;
denominator=(besselj(1,u)).^2+c.*(besselj(0,u)).^2;
etav=numerator./denominator;%激励系数
%计算纵向传播常数
We=2*a+lambda*((ncoM^2-nclM^2)^(-0.5))/pi;%有效宽度
beta=k0*ncoM-((mode+1).^2)*pi*lambda/(4*ncoM*(We^2));%纵向传播常数
end