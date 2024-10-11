%%材料名glassName，材料文件路径GlasscatPath
%%例子:H-K9L C:\Users\dawn\Documents\Zemax\Glasscat
%作者:蔡晓勉
%时间:2024
function [fileName,dispersionFormula,coefficientsData,flag]=glassSearch(glassName,GlasscatPath)

    fileName = '';%文件名
    dispersionFormula = [];%色散公式
    coefficientsData = [];%色散系数
    flag = 0;%结果标志，0为没找到，1为找到

    Files = dir(fullfile([GlasscatPath,'\','*.agf']));
    lengthFiles = length(Files);
    for i = 1:lengthFiles
        name = Files(i).name;
        folder = Files(i).folder;
        %加载文件
        fid = fopen([folder,'\',name], 'r'); % 打开文件以供读取
        line_number = 0;
        while ~feof(fid) % 当未到达文件末尾时
            line = fgetl(fid); % 读取一行文本
            line_number = line_number + 1;
            if contains(line, 'NM') % 检查是否包含你的标识符
                %disp(['文件名 ',name,'找到标识符在第 ', num2str(line_number), ' 行：', line]); % 显示包含标识符的行
                data = split(line,' ');
                fileName = name;
                if strcmp(glassName,data(2))% 检查是否有搜索的材料名
                    dispersionFormula = str2double(data(3));
                    flag = 1;
                end
                
            end
            if flag==1
                if contains(line, 'CD')
                    coefficientsData = split(line,' ');
                    coefficientsData = str2double(coefficientsData(2:end));
                    return;
                end
            end
        end
        fclose(fid); % 关闭文件
    end
end