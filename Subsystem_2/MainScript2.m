clc 
clear 



lb = [11,0.6];
ub = [300,0.8];

A = [];
b = [];
Aeq = [];
beq = [];

x0 = [100,0.7];
% x0 = [11,0.8,3.09];

P=500.00;
mu=0.71;
Mc=160.000;
g=-9.81;
w=[1,0];

%Initial Guess Acceleration + Motor Mass values
disp(['Initial Acceleration: ' num2str(accelws(x0,P,mu,Mc,g,w))])
w=[0,1];
disp(['Initial Motor Mass: ' num2str(accelws(x0,P,mu,Mc,g,w))])

%% Optimize for Acceleration
disp('Acceleration Optimized')
w=[1,0];
options = optimset('Algorithm','sqp');
x = fmincon(@(x0) accelws(x0,P,mu,Mc,g,w),x0,A,b,Aeq,beq,lb,ub,@(x) conws(x,P,mu,Mc,g),options)

optAccel=accelws(x,P,mu,Mc,g,w)
w=[0,1];
optMotorMass=accelws(x,P,mu,Mc,g,w)

%% Optimize for Motor Mass
disp('Motor Mass Optimized')
w=[0,1];
options = optimset('Algorithm','sqp');
x = fmincon(@(x0) accelws(x0,P,mu,Mc,g,w),x0,A,b,Aeq,beq,lb,ub,@(x) conws(x,P,mu,Mc,g),options);

optMotorMass=accelws(x,P,mu,Mc,g,w)
w=[1,0];
optAccel=accelws(x,P,mu,Mc,g,w)

%% Optimize with a weighted sum
n = 21;     % Number of Pareto points to produce
% wsweights = linspace(0,1,n); % Note that this only results in 2 points...
wsweights = linspace(0.9995,1,n);
xws = zeros(n,2); 
fws = zeros(n,3); % 1st col V, 2nd col F, 3rd col weighted obj
for i = 1:n
    w = [wsweights(i), 1-wsweights(i)];
    [xopt] = fmincon(@(x0) accelws(x0,P,mu,Mc,g,w),x0,A,b,Aeq,beq,lb,ub,@(x) conws(x,P,mu,Mc,g),options);
    fopt=Ft(xopt,P,mu,Mc,g);
    
    xws(i,:) = xopt 
    fws(i,3) = Ft(xws(i,:),P,mu,Mc,g)
    fws(i,1) = accel(xws(i,:))
    fws(i,2) = fopt
end
%% Plot Pareto frontiers
plot(fws(:,2),fws(:,1),'ro')
xlabel('Mass of Motor'); ylabel('Acceleration');
hold on

