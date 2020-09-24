clc; close all; clearvars;
addpath('../_functions');

% load the names of the sound card
[Device_Name_IN, Device_Name_OUT] = Device_Names();

%%
RME_sensitivity = 9.8;
fs = 48e3;         % sampling frequency [Hz]
R  = 2.2;          % value of the resistor R [Ohm]  


%% Multi-tone signal
                         
% define the time support                         
T = 3;
t = (0:1/fs:T-1/fs).';

% define the multi-tone signal
f1            = 20;
f2            = 20e3;
N_frequencies = 100;

frequencies = unique(round(logspace(log10(f1), log10(f2), N_frequencies)));
s = zeros(length(t),1);
for f0 = frequencies
    s = s + sin(2*pi*f0*t + 2*pi*rand);
end
s = s./max(abs(s));

input_channels = [5 6];
acquired_signals = RME_sensitivity*measurement(s, fs, input_channels);
 

%% WORKING WITH PERIODICAL SIGNALS !!!!!

start_point = fs;
u0 = acquired_signals(start_point+1:start_point+fs,1); % voltage [V]
uR = acquired_signals(start_point+1:start_point+fs,2); % voltage [V]

U0all = fft(u0)./length(u0)*2;
URall = fft(uR)./length(uR)*2;

U0 = U0all(frequencies+1);
UR = URall(frequencies+1);

w = 2*pi*frequencies.';

U=U0-UR;
I = UR/R;
Z = U./I;
semilogx(frequencies, imag(Z)./w)



