% 定义图像大小  
image_size = [100, 100];  
  
% 定义六边形的顶点坐标  
hexagon_vertices = [  
    image_size(2)/2 + 20 0;        % 第一个顶点，向右偏移20个单位  
    image_size(2)/2 + 10 17.32;    % 第二个顶点  
    image_size(2)/2 - 20 0;        % 第三个顶点，向左偏移20个单位  
    image_size(2)/2 - 10 17.32;    % 第四个顶点  
    image_size(2)/2 34.64;         % 第五个顶点，向上偏移34.64个单位（根号3 * 边长）  
    image_size(2)/2 + 10 17.32     % 第六个顶点，与第二个顶点对称  
];  
  
% 创建一个空白的图像矩阵  
image_matrix = zeros(image_size);  
  
% 使用polygon函数在图像矩阵上绘制六边形  
% 'r' 表示红色，但在这里我们不关心颜色，因为我们是创建掩模  
% 'FillMode' 设置为 'nonzeros'，这样多边形内部会被填充为1  
image_matrix = imfill(impolygon(image_matrix, hexagon_vertices(:,1), hexagon_vertices(:,2), 'r', 'FillMode', 'nonzeros'), 'holes');  
  
% 现在，image_matrix中的六边形区域被填充为1，其余区域为0  
% 你可以使用这个掩模来进行进一步的操作，比如在这个区域填充特定的值  
image_matrix(image_matrix == 1) = 255; % 将六边形区域填充为白色（255）  
  
% 显示结果  
imshow(image_matrix);