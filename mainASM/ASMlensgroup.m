function beam_o=ASMlensgroup(beam_i,lensgroup,distance,area,lambda,rate)
for ii=1:length(lensgroup)
    beam_i = transform(beam_i, area(ii), lambda, distance(ii), [rate, rate]);
    if ~isempty(lensgroup{ii}.thick_edge)
        beam_i=ASMinLens(beam_i,lensgroup{ii},lambda,area(ii));
    else
        beam_i=beam_i.*lensgroup{ii}.phase;
    end
end
beam_o=transform(beam_i, area(end), lambda, distance(end), [rate, rate]);
end