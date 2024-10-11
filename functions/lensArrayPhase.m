%计算微透镜阵列相位（已弃用，请使用Lens类）
function phase=lensArrayPhase(r,l,t, n, lambda, N,num)
    singleLens=lensPhase([r,inf],l,l, t, n, lambda, N,'square');
    phase = repmat(singleLens, num, num);
end