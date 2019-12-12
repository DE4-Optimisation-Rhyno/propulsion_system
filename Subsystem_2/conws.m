function [g,geq] = conws(x)

N2=x(1);  r=x(2); t=x(3);
 
g(1) = 11-N2;
g(2) = 1-t;
g(3) = -0.8-r;

geq = [];