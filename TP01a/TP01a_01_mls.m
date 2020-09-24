clc; close all; clearvars;
addpath('../_functions');

% load the names of the sound card
[Device_Name_IN, Device_Name_OUT] = Device_Names();

%% sampling rate
fs = 48e3;

%% MLS signal
N = 17;      % order of the mls
M = 2^N - 1; % one period length

buffer = ones(N,1); % shif register

% loop through the shift register
mls_signal = zeros(M,1);
for k = 1:M
    mls_signal(k) = buffer(end);
    
    temp = xor(buffer(17), buffer(3));
    
    buffer = [temp; buffer(1:end-1)];
end

% mls is by defaults a sequence of 0s and 1s
% let's make it an audio signal from -1 to 1
s_org = 2*mls_signal - 1;


%% measurements
input_channels = [1 2];
% repeat 3 periods of mls signal
acquired_signals = measurement([s_org; s_org; s_org], fs, input_channels);


%% WORKING WITH PERIODICAL SIGNALS !!!!!

% select a period of (MLS signal) after a steady state
st_point = M;
u = acquired_signals(st_point+1 : st_point+M, :);

% calculate the Fourier Trasforms
Xs = fft(s_org)./M * 2;
U1 = fft(u(:,1))./M * 2;
U2 = fft(u(:,2))./M * 2;

% FRF of each channel
H1 = U1./Xs;
H2 = U2./Xs;
H = U2./U1;


%% PLOT RESULTS

% frequency axis
f_axis = linspace(0, fs, M+1); f_axis(end) = [];

% plot the FRFs
semilogx(f_axis, 20*log10(abs(H)))



