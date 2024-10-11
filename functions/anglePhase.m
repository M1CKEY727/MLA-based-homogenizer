function phase=anglePhase(angle,waveLength,area,delta)
k=2*pi/waveLength;
phi_gradX=deg2rad(angle(1))*k;
phi_gradY=deg2rad(angle(2))*k;
phase_gradX=phi_gradX*ones(area./delta);
phase_gradY=phi_gradY*ones(area./delta);
phase=DepthFromGradient(phase_gradX,phase_gradY);
end