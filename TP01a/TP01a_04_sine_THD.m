clc; close all; clearvars;
addpath('../_functions');

% load the names of the sound card
[Device_Name_IN, Device_Name_OUT] = Device_Names();

%%
fs = 48e3;

%% Sine
f0 = 500;    % sine frequency
T  = 3;      % time duration

t = (0:1/fs:T-1/fs)';
s = sin(2*pi*f0*t);


%% measurements
input_channels  = [1 2];
latency_channel = 1;
acquired_signals = measurement_with_latency(s, fs, input_channels, latency_channel);

%%
y = acquired_signals(fs+1:2*fs, 2);
Y = fft(y)./length(y) * 2;


%% PLOT RESULTS
freq_axis = linspace(0,fs,length(Y)+1); freq_axis(end) = [];

figure;
semilogx(freq_axis,20*log10(abs(Y)),'linewidth',2)
set(gca,'XLim',[20 20e3]);

xlabel('Frequency [Hz]')
ylabel('Amplitude [dB]')
ylim([-80 0]);







