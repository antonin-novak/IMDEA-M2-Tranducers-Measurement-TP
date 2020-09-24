clc; close all; clearvars;
addpath('../_functions');

%%
fs = 10e3;         % sampling frequency [Hz]
R  = 2.2;          % value of the resistor R [Ohm]
devN = 'Dev1';     % name of the Data Acquisition Device
N_samples = 2*fs;  % number of samples of measured responses

%% DISPLACEMENT SENSOR sensitivity
disp_sens = 2e-3; % [m/V] Panasonic HG-C1030
% disp_sens = 6e-3; % [m/V] Panasonic HG-C1050

%% SWEPT-SINE
f1 = 5;             % start frequency
f2 = 500;          % end frequency
T = 10;             % time duration
[s,t,L] = synchronized_swept_sine(f1, f2, T, fs);

% add a fade-in and fade-out to the signal
s = fadeIn_fadeOut(s,0.1,0.01,fs);

%% MEASUREMENT

% amplitudes = [0.01 0.02 0.05 0.1 0.2 0.5 1];
amplitudes = [0.5];

% frequency axis
f_ax = linspace(0, fs, N_samples+1).'; f_ax(end) = [];
U = zeros(N_samples, length(amplitudes));
I = zeros(N_samples, length(amplitudes));
X = zeros(N_samples, length(amplitudes));

for k = 1:length(amplitudes)
    
    %% Data Acquisition
    
    NIses = daq.createSession('ni');
    NIses.Rate = fs;
    NIses.addAnalogOutputChannel(devN,0,'Voltage');
    NIses.addAnalogInputChannel(devN, 'ai0', 'Voltage'); % U0
    NIses.addAnalogInputChannel(devN, 'ai1', 'Voltage'); % UR
    NIses.addAnalogInputChannel(devN, 'ai2', 'Voltage'); % X
    
    NIses.queueOutputData([amplitudes(k)*s; zeros(100,1)]);
    out_signals = NIses.startForeground();
    
    %% Nonlinear swetpt-sine
    
    HHFR = synchronized_swept_sine_HHFR(out_signals, f1, L, 1, 2^11, N_samples, fs);
   
    U0 = HHFR{1}; % Voltage accross Loudspeaker and Resistor
    UR = HHFR{2}; % Voltage accross Resistor
    
    U(:,k) =           U0 - UR;  % Voltage accross the Loudspeaker [V]
    I(:,k) =           UR / R;   % Current through the Loudspeaker [A]
    X(:,k) = disp_sens*HHFR{3};  % Displacement [m]

    %% Plot results
    % u_rms = rms(          u0              -       uR                 );
    u_rms =   rms(out_signals(end-fs:end,1) - out_signals(end-fs:end,2));
    
    figure(1);
    semilogx(f_ax,abs(X(:,k)./U(:,k)), 'DisplayName', ['U_{rms} = ' num2str(u_rms,2) ' V']);
    xlim([f1 f2])
    hold on; legend();
    xlabel('Frequency [Hz]'); ylabel('|X/U| [m/V]');
    
    figure(2);
    semilogx(f_ax,abs(X(:,k)./I(:,k)), 'DisplayName', ['U_{rms} = ' num2str(u_rms,2) ' V']);
    xlim([f1 f2])
    hold on; legend();
    xlabel('Frequency [Hz]'); ylabel('|X/I| [m/A]');
    
end
