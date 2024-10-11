function fn=fresnelnum(lens,lambda)
f=focalLength(lens);
d=min(lens.diameter);
fn=d^2/4/lambda/f;
end