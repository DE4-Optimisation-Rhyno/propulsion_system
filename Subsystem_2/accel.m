function [f] = accel(x)
N2=x(1);  r=x(2); %t=x(3);
% Define acceleration
v2=((r*((2*pi)./60))*((11./N2)*2500));

f=-(v2./3.09);