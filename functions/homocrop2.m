function croppedI=homocrop2(I,rect)
if numel(size(I))==3
    I=rgb2gray(I);
end
I=imnorm(double(I));
croppedI=I(rect(3):rect(4),rect(1):rect(2));
end