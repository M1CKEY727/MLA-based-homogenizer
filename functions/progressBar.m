%一个可以用在mlx文件或mlapp中的进度条
%N:大小
%percent:值
%parent:父对象，可以没有输入
function progressBar(N,percent,parent)
bar=zeros(N(1),N(2));
num=percent*N(2);
bar(:,1:round(num))=0.6;
if exist('parent','var')
    imshow(bar,'Parent',parent);
else
    imshow(bar);
end
end