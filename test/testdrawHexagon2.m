clc;  
clear;  
h = 30;  
side = h * 2 / sqrt(3);  
hexagon = drawHexagon(0, 0, h, [round(3*side), 2 * h], 90);  
%hexagon2 = drawHexagon(0, 0, h, [3 * round(side), 2 * h], 45);
imshow(hexagon,[]);  
  %%
array = repmat(hexagon, [4, 5]);
array_sp =  repmat(0.5*hexagon, [3, 6]);
array2 = padarray(array, [0, h],'symmetric'); 
imshow(array2)

array3 = padarray(array_sp, [round(side/2*3), 0],'symmetric');
if(size(array3,1)<size(array2,1))
    array3(end+1,:)=array3(end,:);
end
imshow(array3)
array=array2+array3;
imshow(array,[])