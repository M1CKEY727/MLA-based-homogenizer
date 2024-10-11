function [FWHM,radius,peakmap,num,uniformity,SD]=spotAna(Inorm,waist,d,delta)
    [meanFWHM,radius]=calMeanDia(Inorm,gather(ceil(d/delta)*0.75),waist);
    FWHM=meanFWHM*delta;
    peakmap=findPeak(Inorm);
    [row,~]=find(peakmap==1);
    num=size(row,1);
    Im=Inorm(peakmap);
    uniformity=1-(max(Im)-min(Im))./(max(Im)+min(Im));
    SD=std(Im,0,'all');
end