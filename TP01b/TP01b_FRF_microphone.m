clc; close all; clearvars;

devN = 'Dev2';   % name of the Data Acquisition Device
fs = 200e3;      % sampling frequency [Hz]

amplitude = 0.5;

f1 = 1000;
f2 = 50000;

%% MULTI-TONE

% time duration of the multi-tone signal [s]
T = 2;  
t = (0:1/fs:T-1/fs).';

% log spaced unique integer frequencies
frequencies = unique(round(logspace(log10(f1), log10(f2), 300))).'; 

s = 0;
for l = 1:length(frequencies)
    s = s + sin(2*pi*frequencies(l)*t + rand*2*pi);
end
s = s./max(abs(s)); % scaling the signal to -1 +1


%% MEASUREMENT

NIses = daq.createSession('ni');
NIses.Rate = fs;
NIses.addAnalogOutputChannel(devN,     0, 'Voltage'); % out
NIses.addAnalogInputChannel (devN, 'ai0', 'Voltage'); % in 1
NIses.addAnalogInputChannel (devN, 'ai1', 'Voltage'); % in 2


NIses.queueOutputData(s*amplitude);
in = NIses.startForeground();


%% Extract data from the swept-sine

start_point = 1e4;
in1 = in(start_point+1:start_point+fs,1); 
in2 = in(start_point+1:start_point+fs,2); 

In1 = fft(in1)./length(in1)*2;
In2 = fft(in2)./length(in2)*2;


In1x = In1(frequencies+1);
In2x = In2(frequencies+1);

%%
figure;
subplot(211)
semilogx(frequencies,20*log10(abs(In2x./In1x)))
grid on
xlabel('Frequency, Hz')
ylabel('Amplitude [dB]')
xlim([f1 f2])

subplot(212)
semilogx(frequencies,angle(In2x./In1x))
grid on
xlabel('Frequency, Hz')
ylabel('Phase [rad]')
xlim([f1 f2])



