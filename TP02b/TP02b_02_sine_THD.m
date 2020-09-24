clc; close all; clearvars;
addpath('../_functions');

% load the names of the sound card
[Device_Name_IN, Device_Name_OUT] = Device_Names();

%%
RME_sensitivity = 9.8;
fs = 48e3;

%% Sine
f0 = 1000;             % sine frequency
T = 3;                % time duration

t = (0:1/fs:T-1/fs)';
s = sin(2*pi*f0*t);


%% measurements
input_channels  = [5 6];
acquired_signals = measurement(s, fs, input_channels);

%%
i = RME_sensitivity*acquired_signals(fs+1:2*fs, 2);
I = fft(i)./length(i) * 2;


%% PLOT RESULTS
freq_axis = linspace(0,fs,length(I)+1); freq_axis(end) = [];

figure;
plot(freq_axis,20*log10(abs(I)),'linewidth',2)
set(gca,'XLim',[0 10e3]);

xlabel('Frequency [Hz]')
ylabel('Amplitude [dB]')
ylim([-80 20]);







