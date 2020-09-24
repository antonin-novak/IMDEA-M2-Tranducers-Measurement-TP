clc; close all; clearvars;

%%
fs = 50e3;      % sampling frequency [Hz]
R = 2.2;        % value of the resistor R [Ohm]  
devN = 'Dev1';  % name of the Data Acquisition Device

%% DISPLACEMENT SENSOR sensitivity
disp_sens = 2e-3; % [m/V] Panasonic HG-C1030
% disp_sens = 6e-3; % [m/V] Panasonic HG-C1050

%% MEASUREMENT

NIses = daq.createSession('ni');
NIses.Rate = fs;
NIses.DurationInSeconds = 5; % 5 seconds of acquisition
NIses.addAnalogInputChannel(devN, 'ai0', 'Voltage'); % U0
NIses.addAnalogInputChannel(devN, 'ai1', 'Voltage'); % UR
NIses.addAnalogInputChannel(devN, 'ai2', 'Voltage'); % X
in = NIses.startForeground();

%%
u0 =           in(:,1); % voltage accross Loudspeaker and Resistor [V]
uR =           in(:,2); % oltage accross Resistor [V]
x  = disp_sens*in(:,3); % displacement [m]

u = u0 - uR;  % voltage accross Loudspeaker [V]
i = uR / R;   % current through the Loudspeaker [A]

%%
subplot(311); plot(u); ylabel('voltage [V]');
subplot(312); plot(i); ylabel('current [A]');
subplot(313); plot(x); ylabel('displacement [m]');


