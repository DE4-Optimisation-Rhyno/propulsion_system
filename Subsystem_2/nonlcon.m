% function [g,geq] = beamconc(xF,E,sigmay,epsilon)
% % Define 3 elements of x vector as individual variables length, width, height
% l = xF(1); w = xF(2); h = xF(3); F = xF(4);
% % Define each constraint as an element of the vector g
% g(1) = w-l/10;
% g(2) = h-l/10;
% g(3) = (6*F*l^3)/(w*h^2)-sigmay;
% g(4) = (F*l^3)/(3*E*(w*h^3/12)) - 0.005;
% g(5) = epsilon-F;
% % Since there are no equality constraints, we create "geq" as an empty vector
% geq = [];

function [g,geq] = conc(xF,mu,Mt,g,epsilon)

t=xF(1); r=xF(2); N2=xF(3); Ft=xF(4);

g(1) = t-3.09;
g(2) = v2-0.972;
g(3) = r-800;
g(4) = N2-300;
g(5) = epsilon-Ft;

geq = [];

function [g,geq] = conws(xF)

t=xF(1); r=xF(2); N2=xF(3); Ft=xF(4);

g(1) = t-3.09;
g(2) = (r*((2*pi)/60)*((11/N2)*2500))-0.972;
g(3) = r-800;
g(4) = N2-300;

geq = [];

function [f] = accelws(xF,mu,Mt,g,w)
% Define 3 elements of x vector as individual variables length, width, height
t=xF(1); r=xF(2); N2=xF(3); Ft=xF(4);

% Define volume
% V = L*W*H;
A=(r*((2*pi)/60)*((11/N2)*2500))/t;
NFt=(P/((2*pi)/60)*((11/N2)*2500))/r + (mu*(Mt*g))
f = w(1)*A - w(2)*NFt;

function [f] = accel(xF)
t=xF(1); r=xF(2); N2=xF(3); Ft=xF(4);
% Define acceleration
A=(r*((2*pi)/60)*((11/N2)*2500))/t;

function [f] = Ft(xF,mu,Mt,g)
t=xF(1); r=xF(2); N2=xF(3); Ft=xF(4);
% Define force total
NFt=(P/((2*pi)/60)*((11/N2)*2500))/r + (mu*(Mt*g))

