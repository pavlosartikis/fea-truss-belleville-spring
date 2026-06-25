%% Problem 1 - Equilibrium Truss
% Solves the 8-DOF planar truss system Ax = b for nodal displacements,
% using either the assignment's fixed parameters or fully custom inputs
% (profile, angle, length, load, material) without touching the matrix
% structure itself.

clear; clc; format long;

% User Menu
disp('1: Use Assignment Settings (45 degrees, L=1000mm)');
disp('2: Use Custom Settings (User-inputted angles/area/load/profile)');
choice = input('Pick 1 or 2: ');

if choice == 1
    theta = 45;     % degrees
    L = 1000;       % mm
    E = 200000;     % MPa = N/mm^2
    P = 20000;      % N
    A = (pi/4) * (15^2 - 12^2); % mm^2
else
    profile = input('Pick a profile: 1: Tubular, 2: Cylindrical: ');
    if profile == 1
        do = input('Choose an outer diameter / mm: ');
        di = input('Choose an inner diameter / mm: ');
        if di > do
            fprintf('Invalid: Inner diameter exceeds outer diameter.\n');
            return;
        end
        A = (pi/4) * (do^2 - di^2);
    else
        d = input('Choose a diameter / mm: ');
        A = (pi/4) * d^2;
    end
    theta = input('Enter the angle / degrees: ');
    L = input('Enter length L / mm: ');
    P = input('Enter the downward load P / N: ');
    E = input('Enter the Youngs Modulus E / MPa: ');
end

angle = (cosd(theta) * sind(theta)) / (1/cosd(theta));

% Define gamma as the simplified term for angle*area
gamma = angle * A;

% Matrix structure follows the simplified nodal equilibrium derivation.
% All member areas are treated as uniform (A). Built from area/angle
% coefficients (gamma, A) rather than pre-computed numeric values, so the
% same structure holds if A or theta change.
Amatrix = [ gamma,        -(A+gamma),  0,      0,           -gamma,      gamma,       0,      0;
           -(A+gamma),     gamma,      A,      0,            gamma,     -gamma,       0,      0;
            0,              0,         gamma, -(2*A+gamma),  0,          A,           0,      0;
            A,              0,        -(A+gamma), gamma,     0,          0,           0,      0;
           -gamma,          gamma,     0,      A,            gamma,     -(A+gamma),   0,      0;
            gamma,         -gamma,     0,      0,           -(A+gamma),  gamma,       A,      0;
            0,              0,        -gamma,  gamma,        0,          0,           gamma, -gamma;
            0,              0,         gamma, -gamma,        A,          0,          -(A+gamma), gamma];

% Load vector b: downwards vertical load P at Node 4.
b = [0; 0; 0; 0; 0; 0; 0; (P*L)/E]; % Load scaled by L/E

x = Amatrix \ b ; % LU decomposition via backslash - stable & efficient
                  % for a small, dense, well-conditioned system

% Printing Results
disp('Matrix A:');
disp(Amatrix);
disp('Displacements:');
names = {'x1(Y)';'x2(X)';'x3(Y)';'x4(X)';'x5(Y)';'x6(X)';'x7(Y)';'x8(X)'};
Results = table(x, 'RowNames', names, 'VariableNames', {'mm'});
disp(Results);
