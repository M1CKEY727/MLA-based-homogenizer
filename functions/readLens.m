function lens=readLens(lensPath,waveLength)
fid=fopen(lensPath,'r');
while ~feof(fid) % 当未到达文件末尾时
    line = fgetl(fid); % 读取一行文本
    if contains(line, 'T') % 检查是否包含你的标识符
        type = split(line,' ');
        type=type(2);
    end
    if contains(line, 'r') % 检查是否包含你的标识符
        radius = split(line,' ');
        radius = str2double(split(radius(2),',')');
    end
    if contains(line, 't') % 检查是否包含你的标识符
        thickness = split(line,' ');
        thickness = str2double(split(thickness(2),',')');
    end
    if contains(line, 'd') % 检查是否包含你的标识符
        diameter = split(line,' ');
        diameter = str2double(split(diameter(2),',')');
    end
    if contains(line, 'm') % 检查是否包含你的标识符
        material = split(line,' ');
        material = split(material(2),',')';
    end
end
if exist("waveLength","var")
    lens=Lens(radius,thickness,diameter,material,waveLength);
else
    lens=Lens(radius,thickness,diameter,material);
end
lens.type=type;