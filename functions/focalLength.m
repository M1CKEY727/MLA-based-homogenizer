function fl=focalLength(lens)
r=lens.curRadius;
n=lens.n_curwl;
t=lens.thickness;
fl_reci=-(n-1)*(1/r(1)-1/r(2))+(n-1)^2*t/(n*r(1)*r(2));
fl=1/fl_reci;
end
