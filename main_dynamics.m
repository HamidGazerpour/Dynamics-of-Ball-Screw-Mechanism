clear all; close all; clc;
%------------------------------

omega = 90*2*pi/60;  % rad/s

% required force for cutting:
r_wire = 0.006/2; A_wire = pi*r_wire^2; sigma_wire = 415 *10^6; 
F = sigma_wire * A_wire; % [N]

% Screw diameter:
d0 = 0.034; d1 = 0.0394;  % [mm]
d_ave = (d0+d1)/2;
% Lead of screw
L = 0.01;                
%Cr = F*r + 
alpha_screw = atan(L/(pi*d1));
mu = 0.2;   % the coefficient of static friction 
phi_screw = atan(mu);
Cr = F * d1/2 * tan(alpha_screw + phi_screw);


Jtot = (1437*0.5 + 1530)/(1000)^2;

i=1;
for x = 0:0.1:360
    res1 = MC_03(x);
    t(i) = x;
    time(i) = deg2rad(x)/omega;
    p3(i) = res1.pos;
    v3(i) = res1.vel*omega;
    a3(i) = res1.acc*omega^2;
    
    theta_screw(i) = 2*pi*p3(i)/L;
    omega_screw(i) = 2*pi*v3(i)/L;
    omega_dot_screw(i) = 2*pi*a3(i)/L;

    if (p3(i) >= 0.008 && p3(i) < 0.014) && v3(i) > 0
        Cm(i) = Cr+Jtot*omega_dot_screw(i);
        
    else
        Cm(i) = Jtot*omega_dot_screw(i);
    end
    
    i=i+1;
end

figure;
subplot(4,1,1); plot(time,p3,'r','LineWidth',1);grid;
title('Position of screw'); xlabel('time [s]'); ylabel('p [m]');
subplot(4,1,2); plot(time,v3,'b','LineWidth',1);grid;
title('Velocity of screw'); xlabel('time [s]'); ylabel('v [m/s]');
subplot(4,1,3); plot(time,a3,'g','LineWidth',1);grid;
title('Acceleration of screw'); xlabel('time [s]'); ylabel('a [m/s^2]');
subplot(4,1,4); plot(time,Cm,'r','LineWidth',1);grid; 
title('Required Torque'); xlabel('time [s]'); ylabel('C_{rs} [N.m]');

figure;
subplot(3,1,1); plot(time,theta_screw,'r','LineWidth',1);grid;
title('Angular position of screw'); xlabel('time [s]'); ylabel('\Theta [rad]');
subplot(3,1,2); plot(time,omega_screw,'b','LineWidth',1);grid;
title('Angular velocity of screw'); xlabel('time [s]'); ylabel('\omega [rad/s]');
subplot(3,1,3); plot(time,omega_dot_screw,'g','LineWidth',1);grid;
title('Angular acceleration of screw'); xlabel('time [s]'); ylabel('\alpha [rad/s^2]');

figure;
plot(omega_screw/(2*pi),Cm,'k','LineWidth',1);grid; xlabel('rpm'); ylabel('Motor torque');
