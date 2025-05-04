clearvars; close all;
%==============================================================================================================================
% Track initialization
track.straight = 900;
track.radius   = 200;
track.width    = 15;

%==============================================================================================================================
% Vehicle Parameters
carData.wheel_radius  = 0.36;
carData.wheel_inertia = 0.5 * 7 * (carData.wheel_radius^2);
carData.C_lambda      = 50;
carData.lambda_max    = 0.1;
carData.tire_mu       = 1.0;
carData.kt_constant   = 0.38;
carData.kv_peak_load  = 14.16;
carData.x0        = 0;
carData.y0        = 0;
carData.vx0       = 0.1;
carData.vy0       = 0;
carData.psi0      = 0;
carData.omega0    = 0;
carData.mass      = 231.33;
carData.Inertia   = 200;
carData.length    = 1.524;
carData.width     = 1;
carData.lr        = 0.5 * carData.length;
carData.lf        = 0.5 * carData.length;
carData.area      = 0.5;
carData.Fyfmax    = 10000;
carData.Fyrmax    = 10000;
carData.Calpha_f  = 40000;
carData.Calpha_r  = 40000;
carData.vx_threshold1 = 1;

%==============================================================================================================================
% Battery Data
datBat.numParallel   = 74;
datBat.numSeries     = 96;
datBat.C             = 4.5;
datBat.cell_voltage  = 3.6;
datBat.Rint          = 0.1695;
datBat.inverter_eff  = 0.98;
datBat.SOC           = [0, 0.01, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1];
datBat.OCV           = [0, 3.1, 3.55, 3.68, 3.74, 3.76, 3.78, 3.85, 3.9, 3.95, 4.08, 4.15];

%==============================================================================================================================
% Drag, Friction, Torque data
Cd   = 0.36;
mu_s = 0.8;
Cr   = 0.01;
rho  = 1.225;
T_max                = 200;
max_engine_torque    = 1000;
max_brake_torque     = 20000;
motor_speed_limit    = 7000;
brake_torque_adjustor = 0.36;
regen_braking_efficiency = 0.7;

%==============================================================================================================================
% Inital Parameters
scaleFactor = 0.75;
datMotor.rpm        = 0:1000:12000;
datMotor.maxtorque  = [...
    0,0,0,0,0,0,0,0,0,0,0,0,0;
    280,280,280,220,160,110,95,75,60,55,50,40,0;
    280,280,275,255,240,180,140,125,95,75,70,50,0;
    280,280,275,260,250,220,180,150,125,100,80,70,0;
    280,280,275,260,250,230,200,175,140,120,100,75,0
] * scaleFactor;
datMotor.vbus       = [250, 350, 500, 600, 700] * scaleFactor;
datMotor.eta_torque = linspace(0, 280, 13) * scaleFactor;
datMotor.eta_speed  = [10, 500:500:10000];
datMotor.eta_val = [
    0.740,0.740,0.740,0.740,0.740,0.740,0.740,0.740,0.740,0.740,0.740,0.740,0.740,0.740,0.740,0.740,0.740,0.740,0.740,0.740,0.740;
    0.860,0.940,0.960,0.940,0.940,0.940,0.920,0.920,0.900,0.900,0.880,0.860,0.860,0.860,0.860,0.840,0.820,0.800,0.780,0.760,0.740;
    0.840,0.940,0.960,0.960,0.960,0.960,0.960,0.940,0.940,0.940,0.940,0.920,0.920,0.920,0.920,0.920,0.900,0.900,0.900,0.880,0.880;
    0.840,0.920,0.960,0.960,0.960,0.960,0.960,0.960,0.960,0.940,0.940,0.940,0.940,0.940,0.940,0.920,0.920,0.900,0.900,0.900,0.880;
    0.820,0.900,0.940,0.960,0.960,0.960,0.960,0.960,0.960,0.960,0.960,0.960,0.940,0.940,0.940,0.920,0.900,0.900,0.880,0.880,0.880;
    0.820,0.880,0.940,0.940,0.960,0.960,0.960,0.960,0.960,0.960,0.960,0.960,0.940,0.940,0.920,0.920,0.900,0.900,0.880,0.860,0.860;
    0.800,0.880,0.920,0.940,0.960,0.960,0.960,0.960,0.960,0.960,0.960,0.960,0.940,0.940,0.920,0.900,0.900,0.900,0.900,0.900,0.900;
    0.800,0.860,0.900,0.940,0.940,0.960,0.960,0.960,0.960,0.960,0.960,0.940,0.920,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900;
    0.780,0.860,0.900,0.920,0.940,0.940,0.960,0.960,0.960,0.960,0.960,0.940,0.920,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900;
    0.780,0.860,0.900,0.920,0.920,0.940,0.940,0.940,0.960,0.940,0.940,0.920,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900;
    0.760,0.860,0.880,0.900,0.920,0.940,0.940,0.940,0.940,0.940,0.920,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900;
    0.740,0.840,0.860,0.900,0.920,0.920,0.940,0.940,0.940,0.940,0.920,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900;
    0.720,0.820,0.860,0.880,0.900,0.900,0.920,0.920,0.920,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900,0.900];
datMotor.inertia    = 0.5;
gear_ratio           = 5;
input_gear_inertia   = 0.03;
output_gear_inertia  = 0.1;
v_des_turn    = 10;
v_des_straight = 15;
g = 9.81;
initial_velocity = 0;

%==============================================================================================================================
% Track generation
[track_x, track_y, inner_x, inner_y, outer_x, outer_y] = plotRaceTrack(track);
stopTime = 60;
set_param('simulink', 'SolverType','Fixed-step', ...
    'Solver','ode4', 'FixedStep','0.005', 'StopTime',string(stopTime));
assignin('base','track',track);
assignin('base','initialSpeed',initial_velocity);
out = sim('simulink');

%==============================================================================================================================
% Output values
time           = out.tout;
carData.x      = out.X.Data;
carData.y      = out.Y.Data;
carData.vx     = out.velocity.Data;
carData.psi    = out.psi.Data;
carData.omega  = out.omega.Data;
carData.SOC    = out.SOC.Data;

%==============================================================================================================================
% Vehicle animation
animateVehicle(carData.x, carData.y, carData.psi, carData.vx, carData.length, carData.width);

%==============================================================================================================================
% Data
[loops_completed, total_time, left_track] = raceStat(carData.x, carData.y, time, inner_x, inner_y, outer_x, outer_y);

%==============================================================================================================================
% energy calculated
energy_consumed = datBat.numParallel * datBat.numSeries * datBat.C * carData.SOC(end);
energy_kWh = energy_consumed / (3.6e6);
disp(['Energy total : ', num2str(energy_kWh), ' kWh']);

%==============================================================================================================================
% track grade
track_x = track_x(:);
track_y = track_y(:);
[gradepercent, height] = track_grade(track_x, track_y);
dx = diff(track_x);
dy = diff(track_y);
dist = [0; cumsum(sqrt(dx.^2 + dy.^2))];

%==============================================================================================================================
% figures
figure('Color','w','Position',[100 100 700 800]);
subplot(3,1,1);
plot(dist, height, 'LineWidth', 1.5);
grid on;
xlim([0, 3057]);
xlabel('Distance around the track (m)');
ylabel('Height');
title('Track height per distance (m)');

subplot(3,1,2);
plot(dist, gradepercent, 'LineWidth', 1.5);
grid on;
xlim([0, 3057]);
xlabel('Distance around the track (m)');
ylabel('Grade (%)');
title('Track grade per distance (m)');

subplot(3,1,3);
plot(time, carData.SOC, 'g', 'LineWidth', 1.5);
grid on;
ylim([0 100]);
xlabel('Time (s)');
ylabel('SOC (%)');
title('SOC over time');