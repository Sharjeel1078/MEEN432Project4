% This is the Project 4 Gavin main.m script
clc; clear; close all;

% Add subfolders to MATLAB search path so it can find the functions
addpath(genpath('other_functions'))

%==========================================================================
% Define track and vehicle parameters
% Track parameters
track.radius = 200;
track.width = 15;
track.straight = 900;

% Vehicle parameters
carData.x0 = 0; % initial x position
carData.y0 = 0; % initial y position
carData.vx0 = 0.1; % initial x velocity
carData.vy0 = 0; % initial y velocity
carData.psi0 = 0; % initial psi (rad)
carData.omega0 = 0; % initial angular velocity (rad/s)
carData.mass = 231.33; % initialize the mass of the car (kg)
carData.Inertia = 200; % initialize car inertia (kg*m^2)
carData.length = 1.524; % initialize car length (m)
carData.width = 1; % initialize car width (m)
carData.lr = carData.length / 2; % initialize car rear length (m)
carData.lf = carData.length / 2; % initialize car front length (m)
carData.area = 0.5;             % Frontal area (m^2)
carData.Fyfmax = 10000;
carData.Fyrmax = 10000;
carData.Calpha_f = 40000;                                                     
carData.Calpha_r = 40000;
carData.vx_threshold1 = 1;
carData.wheel_radius = 0.36;    % Wheel radius (m)
carData.wheel_inertia = 0.5*7*carData.wheel_radius^2;      % Wheel Inertia (kg*m^2)
carData.Calpha_f = 40000;       % N/rad front initial tire stiffness
carData.Calpha_r = 40000;       % N/rad rear initial tire stiffness
carData.C_lambda = 50;          % nominal stiffness (N/kg)
carData.lambda_max = 0.1;       % max tire slip ratio
carData.tire_mu = 1.0;
carData.kt_constant = 0.38;     % (Nm/Arms)
carData.kv_peak_load = 14.16;   % (rpm/Vdc)

% friction and drag parameters
Cd = 0.36;                      % Drag coefficient
mu_s = 0.8;                     % Static Friction coefficient
Cr = 0.01;                      % Rolling resistance coefficient
rho = 1.225;                    % Air density (kg/m^3)

% max values and efficiencies
T_max = 200;                    % Max wheel torque (Nm)
max_engine_torque = 1000;       % max torque the engine can give (Nm)
max_brake_torque = 20000;        % Max brake torque (Nm)
motor_speed_limit = 7000;       % Max motor speed (rpm)
brake_torque_adjustor = 0.36;   % Adjusts brake torque for optimized operations 
regen_braking_efficiency = 0.7; % Regen braking efficiency (unitless)

% battery parameters
datBat.numParallel = 74;        % Number of battery cells in parallel
datBat.numSeries = 96;          % Number of battery cells in series
datBat.C = 4.5;                 % Charge of a single battery cell (Amp*hrs)
datBat.cell_voltage = 3.6;      % Voltage of a single battery cell (V)
datBat.Rint = 0.1695;           % Internal resistance of the car's battery
datBat.inverter_eff = 0.98;     % Efficiency of the battery inverter

datBat.SOC = [0, 0.01, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1]; % state of charge
datBat.OCV = [0, 3.1, 3.55, 3.68, 3.74, 3.76, 3.78, 3.85, 3.9, 3.95, 4.08, 4.15]; % open circuit voltage

% motor parameters
%Electric Motor Data - corresponds to the HVH250-090 Electric Motor
scaleFactor = 0.75;
datMotor.rpm = [0,  1000,2000,3000,4000,5000,6000,7000,8000,9000,10000,11000, 12000];
datMotor.maxtorque = [0, 0, 0, 0, 0, 0,  0,  0,  0,  0,   0,   0,     0;
             280, 280, 280, 220, 160, 110,  95,  75,  60,  55,   50,   40,     0;
             280, 280, 275, 255, 240, 180, 140, 125,  95,  75,   70,   50,     0;
             280, 280, 275, 260, 250, 220, 180, 150, 125, 100,   80,   70,     0;
             280, 280, 275, 260, 250, 230, 200, 175, 140, 120,  100,   75,     0] * scaleFactor;
datMotor.vbus = [250, 350, 500, 600, 700] * scaleFactor;

datMotor.eta_torque = (0:25:325) * 280/325 * scaleFactor;
datMotor.eta_speed = 0:500:10000;
datMotor.eta_speed(1) = 10;
datMotor.eta_val = [0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000,0.740000000000000;
    0.860000000000000,0.940000000000000,0.96000000000000,0.940000000000000,0.940000000000000,0.940000000000000,0.920000000000000,0.920000000000000,0.900000000000000,0.900000000000000,0.880000000000000,0.860000000000000,0.860000000000000,0.860000000000000,0.860000000000000,0.840000000000000,0.820000000000000,0.800000000000000,0.780000000000000,0.760000000000000,0.740000000000000;
    0.840000000000000,0.940000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.960000000000000,0.940000000000000,0.940000000000000,0.940000000000000,0.940000000000000,0.920000000000000,0.920000000000000,0.920000000000000,0.920000000000000,0.920000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.880000000000000,0.880000000000000;
    0.840000000000000,0.920000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.940000000000000,0.940000000000000,0.940000000000000,0.940000000000000,0.940000000000000,0.940000000000000,0.920000000000000,0.920000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.880000000000000;
    0.820000000000000,0.900000000000000,0.940000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.940000000000000,0.940000000000000,0.940000000000000,0.920000000000000,0.900000000000000,0.900000000000000,0.880000000000000,0.880000000000000,0.880000000000000;
    0.820000000000000,0.880000000000000,0.940000000000000,0.940000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.940000000000000,0.940000000000000,0.920000000000000,0.920000000000000,0.900000000000000,0.900000000000000,0.880000000000000,0.860000000000000,0.860000000000000;
    0.800000000000000,0.880000000000000,0.920000000000000,0.940000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.940000000000000,0.940000000000000,0.920000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000;
    0.800000000000000,0.860000000000000,0.900000000000000,0.940000000000000,0.940000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.940000000000000,0.920000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000;
    0.780000000000000,0.860000000000000,0.900000000000000,0.920000000000000,0.940000000000000,0.940000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.96000000000000,0.940000000000000,0.920000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000;
    0.780000000000000,0.860000000000000,0.900000000000000,0.920000000000000,0.920000000000000,0.940000000000000,0.940000000000000,0.940000000000000,0.96000000000000,0.940000000000000,0.940000000000000,0.920000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000;
    0.760000000000000,0.860000000000000,0.880000000000000,0.900000000000000,0.920000000000000,0.940000000000000,0.940000000000000,0.940000000000000,0.940000000000000,0.940000000000000,0.920000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000;
    0.740000000000000,0.840000000000000,0.860000000000000,0.900000000000000,0.920000000000000,0.920000000000000,0.940000000000000,0.940000000000000,0.940000000000000,0.940000000000000,0.920000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.9000000000000000;
    .740000000000000,0.840000000000000,0.860000000000000,0.880000000000000,0.900000000000000,0.920000000000000,0.920000000000000,0.940000000000000,0.920000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000;
    0.720000000000000,0.820000000000000,0.860000000000000,0.880000000000000,0.900000000000000,0.900000000000000,0.920000000000000,0.920000000000000,0.920000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000];
datMotor.eta_val = datMotor.eta_val .* datMotor.eta_val;
datMotor.inertia = 0.5; % Kg-m^2

% GEAR PARAMETERS
gear_ratio = 5; % Gear ratio of the powertrain
input_gear_inertia = 0.03; % Powertrain output gear inertia (kg*m^2)
output_gear_inertia = 0.1; % Powertrain input gear inertia (kg*m^2)

% Desired Velocities
v_des_turn = 10; % m/s
v_des_straight = 15; % m/s

% other parameters
g = 9.81;                       % Gravity (m/s^2)
initial_velocity = 0;           % Initial velocity for integration (m/s)

%==========================================================================
% Generate track
[track_x, track_y, inner_x, inner_y, outer_x, outer_y] = plotRaceTrack(track);

%==========================================================================
% Assign parameters to the Simulink model workspace (use the settings saved
% in the simulink model)
stopTime = 60; %  stop time of the simulation (s)                           SET THE SIMULATION TIME HERE
set_param('simulink', 'SolverType', 'Fixed-step', 'Solver', 'ode4', 'FixedStep', '0.005', 'StopTime', string(stopTime));
assignin('base', 'track', track); 
assignin('base', 'initialSpeed', initial_velocity);

% Run Simulink Model
out = sim('simulink');

%==========================================================================
% Extract and Plot Simulation Results
time = out.tout; % Simulation time
carData.x = out.X.Data; % get x pos from sim
carData.y = out.Y.Data; % get y pos from sim
carData.vx = out.velocity.Data; % get the x velocity from the sim
carData.psi = out.psi.Data; % get the psi value from the sim
carData.omega = out.omega.Data; % get the psi value from the sim
carData.SOC = out.SOC.Data; % get the SOC data from the sim

%==========================================================================
% Animate vehicle on track
animateVehicle(carData.x, carData.y, carData.psi, carData.vx, carData.length, carData.width);

%==========================================================================
% Provide the raceStat information
[loops_completed, completion_time, left_track] = raceStat(carData.x, carData.y, time, inner_x, inner_y, outer_x, outer_y);

%==========================================================================
% ENERGY CONSUMPTION CALCULATION
% total number of cells * cell capacity * state of charge
energy_consumed = (datBat.numParallel * datBat.numSeries * datBat.C) * carData.SOC(end);
energy_kWh = energy_consumed / (3.6*(10^6)); % Convert Joules to kWh
disp(['Total Energy Consumed: ', num2str(energy_kWh), ' kWh']);

%==========================================================================
% Show track grade results
% make them into column vectors
track_x = track_x(:);
track_y = track_y(:);

% calculate the grade and height from the get_grade_function
[gradePct, height] = get_grade_function(track_x, track_y);

% determine the total distance along the track
dx   = diff(track_x);
dy   = diff(track_y);
dist = [0; cumsum( sqrt(dx.^2 + dy.^2) )];

% Plot the height and grade functions
figure('Color','w','Position',[100 100 600 500]);

% Height profile
subplot(2,1,1);
plot(dist, height, 'LineWidth', 1.5);
grid on;
xlim([0,3057])
xlabel('Distance along track (m)');
ylabel('Height');
title('Track Height Profile');

% Grade profile
subplot(2,1,2);
plot(dist, gradePct, 'LineWidth', 1.5);
grid on;
xlim([0,3057])
xlabel('Distance along track (m)');
ylabel('Grade (%)');
title('Track Grade Profile');

%==========================================================================
% PLOT THE SOC RESULTS
figure;
plot(time, carData.SOC, 'g', 'LineWidth', 1.5);
ylim([0 100])
xlabel('Time (s)'); 
ylabel('State of Charge (%)');
title('State of Charge');