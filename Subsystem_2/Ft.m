function [f] = Ft(x,P,mu,Mc,g)
N2=x(1);  r=x(2); %t=x(3);

A=(((r*((2*pi)./60))*((11./N2)*2500))./3.09);
% Define mass total
f=((((P./(((2*pi)./60)*((11./N2)*2500)))./(r*sin(0.785398)))./(-A+(mu*g)))-Mc)/100;