function n=calGlassRI(glass_material,lambda,glassCatPath)
lambda=lambda*10^3;
n=zeros(size(glass_material,2),size(lambda,2));
for ii=1:size(glass_material,2)
    if strcmp(glass_material{ii},'AIR')
        n(ii,:)=1;
        continue
    end
    [~,dispersionFormula,coefficientsData,flag]=glassSearch(glass_material{ii},glassCatPath);
    if flag
        n(ii,:)=calRI(dispersionFormula,coefficientsData,lambda);
    else
        %warning('no glasscat was found')
    end
end
end