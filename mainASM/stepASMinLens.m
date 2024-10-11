function result=stepASMinLens(beam,lens,lambda,area,piece)
rate=area./size(beam);

%if length(unique(lens.thick_edge(:,:,1)))~=1
    F=stepAS(beam,area,lambda,lens.thick_edge(:,:,1),rate,[1,lens.n_curwl(1)],piece);
%else
    %F=beam;
%end
for ii=1:length(lens.thickness)
    F=transform(F,area,lambda,lens.thick_mid(ii)+ ...
        min(min(lens.thick_edge(:,:,ii+1))),rate,lens.n_curwl(ii));%传播到下一个平面
    if ii~=length(lens.thickness)
        F=stepAS(F,area,lambda,lens.thick_edge_max(ii+1)-lens.thick_edge(:,:,ii+1),rate,[lens.n_curwl(ii),lens.n_curwl(ii+1)],piece);
    else
        if length(unique(lens.thick_edge(:,:,ii+1)))==1
            result=F;
            return;
        end
        result=stepAS(F,area,lambda,lens.thick_edge_max(ii+1)-lens.thick_edge(:,:,ii+1),rate,[lens.n_curwl(ii),1],piece);
    end
end
end