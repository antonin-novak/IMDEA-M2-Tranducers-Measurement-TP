clc; close all; clearvars;
addpath('../_functions');

% load the names of the sound card
[Device_Name_IN, Device_Name_OUT] = Device_Names();

%%
fs = 48e3;

%% SWEPT-SINE
f1 = 100;            % start frequency
f2 = 15000;          % end frequency
T = 10;              % time duration
[s,t,L] = synchronized_swept_sine(f1, f2, T, fs);
s = fadeIn_fadeOut(s, 0.1, 0.01, fs);

%% measurements
input_channels  = [1 2];
latency_channel = 1;
acquired_signals = measurement_with_latency([s; zeros(0.2*fs,1)], fs, input_channels, latency_channel);

y = acquired_signals(:,2);


%% Nonlinear swetpt-sine

%% -- Deconvolution (get the impulse response)

% spectra of the swept-sine signal in analytic form
S = synchronized_swept_sine_spectra(f1, L, fs, length(y));
% spectra of the output signal
Y = fft(y)./fs;
% frequency-domain deconvolution
H = Y./S; h = ifft(H, 'symmetric');


%% -- separation of higher impulse responses
N = 3;                % number of higher harmonics to show
dt = L.*log(1:N);     % positions of higher harmonic IRs [seconds]
hm = synchronized_swept_sine_IR_separation(h, dt*fs, 2^13, 2^12);


%% -- Higher Harmonic FRF
hm_sym = [hm(2^12+1:end,:); hm(1:2^12,:)];
Hm = fft(hm_sym);


%% PLOT RESULTS

% frequency axis
freq_axis = linspace(0,fs,length(Hm)+1); freq_axis(end) = [];


figure;
semilogx(freq_axis, 20*log10(abs(Hm)),'linewidth',2)
set(gca,'XLim',[f1 N*f2]);

xlabel('Frequency [Hz]')
ylabel('Amplitude [dB]')
title(['Higher Harmonics'])
ylim([-80 0]);

