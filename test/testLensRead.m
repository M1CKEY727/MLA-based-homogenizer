clc
clear
lambda=640e-6;

N=1000;
D=4;
beam=drawRect([N,1],N/3,0,0,1);

piece=200;

scan1=readLens('lens.txt',lambda);
scan2=readLens('lens.txt',lambda);
%lens2.curRadius=-lens2.curRadius;
%scan1.diameter=[lens1.diameter lens2.diameter lens3.diameter lens4.diameter];
Lens.lensReverse(scan1)
delta=D/N;
Lens.lensThickFcn(scan1,D,[1,N]);
Lens.lensGPUArray(scan1);
Lens.lensSingle(scan1);
Lens.lensThickFcn(scan2,D,[1,N]);
Lens.lensGPUArray(scan2);
Lens.lensSingle(scan2);
tic
F=transform(beam,[delta,D],lambda,10,[delta,delta]);
afterLens=stepASMinLens(F,scan1,lambda,[delta,D],piece);
F=transform(afterLens,[delta,D],lambda,50,[delta,delta],1,1);
F=transform(F,[delta,D],lambda,50,[delta,delta],1,1);
afterLens=stepASMinLens(F,scan2,lambda,[delta,D],piece);
F=transform(afterLens,[delta,D],lambda,(0:1:100)',[delta,delta]);
toc
figure
imshow((abs(F).^2)',[])
