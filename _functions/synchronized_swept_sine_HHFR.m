function HHFR = synchronized_swept_sine_HHFR(dist_signal, f1, L, N, N_prering, N_samples, fs)
% SYNCHRONIZED_SWEPT_SINE_HHFR
% Extract Higher Harmonic Frequency Responses out of distorted signal dist_signal
%
% Syntax:  y = fadeIn_fadeOut(x,fdIn,fdOut)
%
% Inputs:
%    in - input signal (column vector)
%    f1 - start frequency of the swept-sine
%    L  - sxept-sine parameter
%    N  - number of higher harmonics
%    N_prering  - number of samples at the beginning of higher impulse responses 
%    N_samples  - number of samples of higher impulse responses 
%    fs - sampling frequency
%
% Outputs:
%    HHFR - Higher Harmonic Frequency Responses
%

% Author: Antonin NOVAK
% Laboratoire d'Acoustique de l'Universite du Mans (LAUM) - UMR CNRS n.6613
% email address: antonin.novak@univ-lemans.fr  
% Website: https://ant-novak.com
% Nov 2019; Last revision: 07-Nov-2019

%------------- BEGIN CODE --------------

% -- Deconvolution (get the impulse response)

% spectra of the swept-sine signal in analytic form
S = synchronized_swept_sine_spectra(f1, L, fs, length(dist_signal));
% spectra of the output signal
Y = fft(dist_signal)./fs;
% frequency-domain deconvolution
H = Y./S; h = ifft(H, 'symmetric');

% -- separation of higher impulse responses
dt = L.*log(1:N);     % positions of higher harmonic IRs [seconds]

N_signals = size(dist_signal, 2);
HHFR = cell(1, N_signals);
for n = 1 : N_signals
    hIR = synchronized_swept_sine_IR_separation(h(:,n), dt*fs, N_samples, N_prering);
    HHFR{n} = fft(hIR);
end

%------------- END OF CODE -------------










