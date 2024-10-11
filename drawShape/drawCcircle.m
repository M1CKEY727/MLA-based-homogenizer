function II=drawCcircle(r,a,b,W,L)
I64=drawRing(r,r+1,a,b,W,L);
coor=find(I64>0);
[num,~]=size(coor);
II=zeros(W,L,num);
for ii=1:num
    A=zeros(W,L);
    A(coor(ii))=I64(coor(ii));
    II(:,:,ii)=A;
end
end