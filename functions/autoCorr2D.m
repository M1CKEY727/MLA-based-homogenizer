function corr=autoCorr2D(signal)
P1=FT2Dc(signal);
corr=IFT2Dc(P1.*conj(P1));
end