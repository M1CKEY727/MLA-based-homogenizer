function I=imnorm(I0)
I=(I0-min(min(I0)))./(max(max(I0))-min(min(I0)));
end