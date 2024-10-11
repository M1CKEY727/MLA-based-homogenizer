%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�ú������ڼ��㵥ģ������϶�ģ���˵ĸ�ģʽ���ϵ�������򴫲�����
%�������:ncoM:n of core of Multimode fiber ��ģ������о������
%         nclM:n of cladding of Multimode fiber ��ģ���˰���������
%         ncoS:n of core of Singlemode fiber ��ģ������о������
%         nclM:n of cladding of Singlemode fiber ��ģ���˰���������
%         lambda:����
%         a:��ģ������о�뾶
%         a0:��ģ������о�뾶
%�������:etav:��ģʽ���ϵ����ɵ�����
%         beta:��ģʽ���򴫲�������ɵ�����
%         Vm:��ģ���˹�һ��Ƶ��
%         Vs:��ģ���˹�һ��Ƶ��
%         w:��ģ�����ڸ�˹��������
%�ο�����:[1]�ӵ�. ����SMS���˽ṹ�˲������о�������[D].���������̴�ѧ,2015.
%        :[2]������. ��ģ-��ģ-��ģ���˽ṹ�ڹ��ۻ������󿵸�����еĴ���Ӧ���о�[D].
%            ���������̴�ѧ,2021. 
%         [3]Chrisada Sookdhis,Ting Mei,Hery Susanto Djie. Wavelength Monitoring With Low-Contrast Multimode Interference Waveguide[J]. 
%            IEEE Photonics Technology Letters,2005,17(4).
function [etav,beta,Vm,Vs,w]=coupleCoe(ncoM,nclM,ncoS,nclS,lambda,a,a0)
%���㲨��
k0=2*pi/lambda;
%�����ģ���˹�һ��Ƶ��
Vm=k0*a*sqrt(ncoM^2-nclM^2);
%���㵥ģ���˹�һ��Ƶ��
Vs=k0*a0*sqrt(ncoS^2-nclS^2);
%����ģʽ��
M=floor(Vm/pi);
%��ģ�����ڸ�˹��������
w=a0*(0.65+1.619*Vs^(-1.5)+2.879*Vs^(-6))/sqrt(log(2));
%%
%���㼤��ϵ��
mode=linspace(1,M,M);
u=(mode-1/4)*pi;
g=w/a;
c1=sqrt(Vm^2-u.^2);
numerator=2*exp(-1*(g^2)*(u.^2)/2)*(g^2);
c=((besselk(1,c1)).^2)./((besselk(0,c1)).^2);%ϵ��
coor=isnan(c);
c(coor)=1;
denominator=(besselj(1,u)).^2+c.*(besselj(0,u)).^2;
etav=numerator./denominator;%����ϵ��
%�������򴫲�����
We=2*a+lambda*((ncoM^2-nclM^2)^(-0.5))/pi;%��Ч���
beta=k0*ncoM-((mode+1).^2)*pi*lambda/(4*ncoM*(We^2));%���򴫲�����
end