function result=freqShift(compamp,theta,area,lambda,f)
freq=FT2Dc(compamp);
delta=lambda*f/area;
displace=tand(theta)/lambda;
delta_pitch=displace./delta;
freq=imtranslate(freq,round(delta_pitch));
result=IFT2Dc(freq);
end