clc; close all; clearvars;

fs = 50e3;      % sampling frequency [Hz]
R = 2.2;        % value of the resistor R [Ohm]  
devN = 'Dev1';  % name of the Data Acquisition Device

%% DISPLACEMENT SENSOR sensitivity
% disp_sens = 2e-3; % [m/V] Panasonic HG-C1030
disp_sens = 6e-3; % [m/V] Panasonic HG-C1050

%% MULTI-TONE

T = 2;  % time duration of the multi-tone signal [s]
t = (0:1/fs:T-1/fs).';

frequencies = unique(round(logspace(log10(20),log10(20e3),300))).'; % log spaced unique integer frequencies

s = 0;
for l = 1:length(frequencies)
    s = s + sin(2*pi*frequencies(l)*t + rand*2*pi);
end
s = s./max(abs(s)); % scaling the signal to -1 +1


%% MEASUREMENT

NIses = daq.createSession('ni');
NIses.Rate = fs;
NIses.addAnalogOutputChannel(devN,0,'Voltage');
NIses.addAnalogInputChannel(devN, 'ai0', 'Voltage'); % U0
NIses.addAnalogInputChannel(devN, 'ai1', 'Voltage'); % UR
NIses.addAnalogInputChannel(devN, 'ai2', 'Voltage'); % X

NIses.queueOutputData(s);
in = NIses.startForeground();

%%


start_point = 1e4;
u0 =           in(start_point+1:start_point+fs,1); % voltage accross Loudspeaker and Resistor [V]
uR =           in(start_point+1:start_point+fs,2); % voltage accross Resistor [V]
x  = disp_sens*in(start_point+1:start_point+fs,3); % displacement [m]

U0all = fft(u0)./length(u0)*2;
URall = fft(uR)./length(uR)*2;
Xall  = fft(x)./length(x)*2;

U0 = U0all(frequencies+1);
UR = URall(frequencies+1);
X = Xall(frequencies+1);

%%

U = U0 - UR; % Voltage accross the Loudspeaker (freq. domain)
I = UR/R;    % Current through the Loudspeaker (freq. domain)

Z = U./I;

semilogx(frequencies, abs(Z));





