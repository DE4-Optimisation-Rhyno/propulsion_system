function [g,geq] = conc(xF,mu,Mt,g,epsilon)

t=xF(1); r=xF(2); N2=xF(3); Ft=xF(4);

g(1) = t-3.09;
g(2) = v2-0.972;
g(3) = r-800;
g(4) = N2-300;
g(5) = epsilon-Ft;

geq = [];