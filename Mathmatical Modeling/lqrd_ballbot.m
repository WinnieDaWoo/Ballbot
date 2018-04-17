%% Discrete Ballbot LQR controls
% by Adam Woo

clear all; close all; clc;

m = 10;         % mass of chassis (kg)
M = 1;          % mass of ball (kg)
l = .1;        % length to center mass of chassis (m)
g = -9.81;      % gravity (m/s)
d = 1;          % damping factor
start = 0;      % x-axis initial location (m)
dest = 0;       % x-axis destination (m)
angle = pi/64;   % initial angle from verticle (rads)
r=0;

t=10;                 % Simulation Duration (seconds)
Ts=1/100;          % Sampling Interval (seconds)
tspan=(0:Ts:t)';
tlen=length(tspan);

A = [0          1             0             0;
    0         -d/M         -m*g/M           0;
    0           0             0             1;
    0        -d/(M*l)   -(m+M)*g/(M*l)      0];

B = [  0;
      1/M;
       0;
     1/(M*l)];

C = [0   1   0   0;
     0   0   1   0];

D = [0;
     0];

Q = [10 0 0 0;
    0 1 0 0;
    0 0 10 0;
    0 0 0 10];

R = .001;

K = lqrd(A,B,Q,R,Ts)

% L = [0.1819;
%     0.0161;
%     0.0000;
%    -0.0002]

%% Discrete simulation

x=zeros(tlen,size(A,1));
x(1,:) = [start; 0; pi+angle; 0];

x_hat=zeros(tlen,size(A,1));
x_hat(1,:) = [start; 0; pi+(angle*rand(1)); 0];

y=zeros(tlen,size(C,1));
y(1,2)=pi+angle;
y_hat=zeros(tlen,size(C,1));

for i = 2:tlen
    x(i-1,3)=x(i-1,3)+rand(1)/(32*pi)-rand(1)/(32*pi);
    
    error = x(i-1,:)'-[dest; 0; pi; 0];
    x(i,:)=(((A-B*K)*(error))*Ts)+x(i-1,:)';
    y(i,:)=x(i,:)*C';

    %TODO: Full State Estimator  
%     u=(-K*x_hat(i-1,:)')+r;
%     x_hat(i,:)=(((A*x_hat(i-1,:)')+(B*u))*Ts)+L*(y(i-1)-y_hat(i-1));
%     y_hat(i)=x(i,:)*C';
% 
%     x(i,:)=(((A*x(i-1,:)')+(B*u))*Ts);
%     y(i)=x(i,:)*C';
    
end

%% Draw Simulation
close all;
for k=1:1/(10*Ts):length(tspan)
    drawballbot(x(k,:),m,M,l);
end

figure;
subplot(2,1,1);
[AX,H1,H2] = plotyy(tspan,x(:,1),tspan,(x(:,3)-pi)*(180/pi),'plot');
grid on
set(get(AX(1),'Ylabel'),'String','ball position (m)')
set(get(AX(2),'Ylabel'),'String','chassis angle (degrees)')
title('Ballbot Positions with State-Feedback Control and Noise')

subplot(2,1,2);
[AX,H1,H2] = plotyy(tspan,x(:,2),tspan,x(:,4)*(180/pi),'plot');
grid on
set(get(AX(1),'Ylabel'),'String','ball velocity (m/s)')
set(get(AX(2),'Ylabel'),'String','chassis angle (degrees/s)')
title('Ballbot Velocities with State-Feedback Control and Noise')