%% DE4 Optimisation: Subsystem 3: Propulsion 
%
% This script performs multi-objective optimisation of a cantilever 
% beam. It minimises the volume and maximises the force that can be 
% applied with respect to length, width and height subject to stress, 
% deflection and geometry constraints. 
% 
% Two strategies are used and plotted, namely a weighted-sum
% approach and constraint-based approach. 
%
% Original Author: DBoyle
% Modified by: Omer Ali
% v1.0
% 1/12/2018

clear
close all
fclose all;
clc
%% Initialize parameters and inputs
% E = 2300000000;     % 2.3 GPa
% sigmay = 45000000;  % 45 MPa
% x0 = [1;0.1;0.1];
% xlb = [0.3;0.001;0.001];
% xub = [2;2;2];
% F0 = 1;
% Flb = 1;
% Fub = 10000;

v1= 0;
P=500;
mm=4.08;
N1=11;
n1=2500;
mu=0.71;
Mt=500+mm;
g=9.81;

x0 = [0.01;1;11];
xlb = [0;0;11];
xub = [60;800;300];

F0 = 1;
Flb = 1;
Fub = 10000;


%% Optimize for V only
options = optimset('Algorithm','sqp');
w = [1,0];
[xoptV,foptV] = fmincon(@(xF) accelws(xF,mu,Mt,g,w),[x0;F0],[],[],[],[],[xlb;Flb],[xub;Fub],@(xF) conws(xF),options);
foptVF = Ft(xoptV,mu,Mt,g);
%% Optimize for F only
w = [0,1];
[xoptF,foptF] = fmincon(@(xF) accelws(xF,mu,Mt,g,w),[x0;F0],[],[],[],[],[xlb;Flb],[xub;Fub],@(xF) conws(xF),options);
foptFV = accel(xoptF);
%% Optimize with a weighted sum
n = 21;     % Number of Pareto points to produce
% wsweights = linspace(0,1,n); % Note that this only results in 2 points...
wsweights = linspace(0.9995,1,n);
xws = zeros(n,4); 
fws = zeros(n,3); % 1st col V, 2nd col F, 3rd col weighted obj
for i = 1:n
    w = [wsweights(i), 1-wsweights(i)];
    [xopt,fopt] = fmincon(@(xF) accelws(xF,mu,Mt,g,w),[x0;F0],[],[],[],[],[xlb;Flb],[xub;Fub],@(xF) conws(xF),options);
    xws(i,:) = xopt; 
    fws(i,3) = fopt;
    fws(i,1) = accel(xws(i,:));
    fws(i,2) = xws(i,4);
end
%% Optimize with a constraint-based approach
highestF = -foptF;
lowestF = -foptVF;
conspace = lowestF + linspace(0,1,n)*(highestF-lowestF);
xc = zeros(n,4); fc = zeros(n,2);
for i = 1:n
    epsilon = conspace(i);
    [xc(i,:),f] = fmincon(@(xF) accel(xF),[x0;F0],[],[],[],[],[xlb;Flb],[xub;Fub],@(xF) conc(xF,mu,Mt,g,epsilon),options);
    fc(i,1) = f;
    fc(i,2) = xc(i,4);
end
%% Plot Pareto frontiers
plot(fws(:,1),fws(:,2),'ro')
xlabel('V'); ylabel('F');
hold on
plot(fc(:,1),fc(:,2),'b+')
plot(foptFV,-foptF,'k*')
plot(foptV,-foptVF,'k*')
legend({'Weighted-sum','Constraint-based'},'Location','SouthEast')