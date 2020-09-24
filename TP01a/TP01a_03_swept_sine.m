clc; close all; clearvars;
addpath('../_functions');

% load the names of the sound card
[Device_Name_IN, Device_Name_OUT] = Device_Names();

%%
fs = 48e3;

%% SWEPT-SINE
f1 = 20;            % start frequency
f2 = 20e3;          % end frequency
T = 5;              % time duration

t = (0:1/fs:T-1/fs)';
L = T/log(f2/f1);
s = sin(2*pi*f1*L*(exp(t/L)));

% add a fade-in and fade-out to the signal
s = fadeIn_fadeOut(s,0.1,0.01,fs);

%% measurements
input_channels = [1 2];
acquired_signals = measurement([s; zeros(0.2*fs,1)], fs, input_channels);
 

%% LINEAR APPROACH (swept-sine)

% frequency axis
f_axis = linspace(0,fs,length(acquired_signals)+1).'; f_axis(end) = [];

% calculate the Fourier Trasform
Xs = 1/2*sqrt(L./f_axis).*exp(1i*2*pi*f_axis*L.*(1 - log(f_axis/f1)) - 1i*pi/4); Xs(1) = Inf; % protect from devision by zero
U1 = fft(acquired_signals(:,1))./fs;
U2 = fft(acquired_signals(:,2))./fs;

% FRF of each channel
H1 = U1./Xs;
H2 = U2./Xs;
H = U2./U1;

%% PLOT RESULTS


figure();
semilogx(f_axis, 20*log10(abs(H1)));
title('Channel 1');
xlabel('Frequency [Hz]');
xlim([20 20e3]);

figure();
semilogx(f_axis, 20*log10(abs(H2)));
title('Channel 2');
xlabel('Frequency [Hz]');
xlim([20 20e3]);

figure();
semilogx(f_axis, 20*log10(abs(H)));
title('Frequency Response Function');
xlabel('Frequency [Hz]');
xlim([20 20e3]);





