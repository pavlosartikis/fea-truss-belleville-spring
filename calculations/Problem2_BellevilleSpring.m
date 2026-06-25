%% Problem 2 - Belleville Spring: Spring Constant (k) Calculation
% Evaluates the Norton (1996) closed-form force-deflection equation for a
% conical disc spring and differentiates it numerically (second-order
% central finite difference) to obtain the spring constant k at the
% target deflection.

clear; clc;

% Spring Parameters
Do = 200;       % Outer diameter (mm)
Di = 82;        % Inner diameter (mm)
t = 8;          % Thickness (mm)
h = 6.7;        % Cone height (mm)
E = 200000;     % Young's Modulus (N/mm^2)
mu = 0.3;       % Poisson's ratio

Rd = Do/Di;
K1 = (6/(pi*log(Rd)))*((Rd-1)^2/Rd^2);

% Force Function (Norton, 1996)
F = @(delta)(4*E*delta)/(K1*Do^2*(1-mu^2))*((h-delta)*(h-delta/2)*t+t^3);

% Central Finite Difference Approximation of k at delta = 3.72 mm
d = 3.72;
delta0 = 0.372;     % Step size (10% of delta0)
delta1 = d-delta0;  % 3.348 mm
delta2 = d+delta0;  % 4.092 mm

F1 = F(delta1);
F0 = F(d);
F2 = F(delta2);

k = (F2-F1)/(2*delta0);

fprintf('K1 = %.4f\n', K1);
fprintf('F(3.348) = %.2f N\n', F1);
fprintf('F(3.720) = %.2f N\n', F0);
fprintf('F(4.092) = %.2f N\n', F2);
fprintf('k at delta = 3.72 mm = %.2f N/mm\n', k);
