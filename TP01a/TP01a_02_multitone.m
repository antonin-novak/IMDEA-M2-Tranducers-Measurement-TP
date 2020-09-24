clc; close all; clearvars;
addpath('../_functions');

% load the names of the sound card
[Device_Name_IN, Device_Name_OUT] = Device_Names();

%%
fs = 48e3;

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

input_channels = [1 2];
acquired_signals = measurement(s, fs, input_channels);
 

%% WORKING WITH PERIODICAL SIGNALS !!!!!

% select a period of signal (1 second) after a steady state
st_point = fs;
u = acquired_signals(st_point+1 : st_point+fs, :);

% calculate the Fourier Trasform
X_all = fft(s(1:fs))./length(s) * 2;
U1all = fft(u(:,1))./length(u) * 2;
U2all = fft(u(:,2))./length(u) * 2;

% select only the points at which we made the measurement
U1 = U1all(frequencies+1, :);
U2 = U2all(frequencies+1, :);
Xs = X_all(frequencies+1, :);

% FRF of each channel
H1 = U1./Xs;
H2 = U2./Xs;
H = U2./U1;

%% PLOT RESULTS

% frequency axis
f_axis = linspace(0,fs,length(u)+1).'; f_axis(end) = [];

figure();
semilogx(f_axis, 20*log10(abs(U2all)));
title('Channel 2 spectrum');
xlabel('Frequency [Hz]');
xlim([20 20e3]);

figure();
semilogx(frequencies, 20*log10(abs(H)));
title('Frequency Response Function');
xlabel('Frequency [Hz]');
xlim([20 20e3]);





