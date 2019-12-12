%clc 
%clear 
tic
disp('Subsystem 2: Start') 

%Define lower & upper-bounds
lb = [11,0.6,1];
ub = [300,0.8,3.09];

A = [];
b = [];
Aeq = [];
beq = [];

%Initial Starting Point, [N2,r]
x0 = [11,0.8,1];

%
P=500.00;
mu=0.71;
Mc=160.000;
g=9.81;
w=[1,0];

%Initial Guess Acceleration + Motor Mass values 
disp(['Initial Acceleration without consideration of constraints: ' num2str(accelws(x0,P,mu,Mc,g,w))])
w=[0,1];
disp(['Initial Motor Mass without consideration of constraints: ' num2str(accelws(x0,P,mu,Mc,g,w))])

%% Optimize for Acceleration
disp('Acceleration Optimized')

%SQP

disp('SQP')
w=[1,0];
tic
options = optimset('Algorithm','sqp');
[x] = fmincon(@(x0) accelws(x0,P,mu,Mc,g,w),x0,A,b,Aeq,beq,lb,ub,@(x) conws(x),options)
toc
optAccel=accelws(x,P,mu,Mc,g,w)
w=[0,1];
optMotorMass=accelws(x,P,mu,Mc,g,w)

%Interior Points
disp('Interior Points')
w=[1,0];
tic
options = optimset('Algorithm','interior-point');
x = fmincon(@(x0) accelws(x0,P,mu,Mc,g,w),x0,A,b,Aeq,beq,lb,ub,@(x) conws(x),options)
toc
optAccel=accelws(x,P,mu,Mc,g,w)
w=[0,1];
optMotorMass=accelws(x,P,mu,Mc,g,w)

toc
disp('Subsystem 2: End') 
