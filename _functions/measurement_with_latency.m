function input_signal = measurement_with_latency(output_signal,fs,input_channels,latency_channel)
%MEASUREMENT_WITH_LATENCY
% Measures the response of the device under test (DUT) (input_signal) to
% the signal (output_signal) while taking into account the latency of the
% sound-card. The signal is preceded by a short 1 kHz burst signal that is
% acquired to the latency_channel. The estimated latency is next removed
% from the output_signal.
%
% Syntax:  input_signal = measurement_with_latency(output_signal,fs,input_channels,latency_channel)
%
% Inputs:
%    input_signal    - signal to be sent to the output of the sound card
%                     (input to the DUT)
%    fs              - sampling frequency of the sound card
%    output_signal   - vector of input channels to be recorded
%    latency_channel - the channel in which the latecny is measured
%                      (must be included in input_channels
%
% Outputs:
%    input_signal    - signal acquired at the input of the sound card
%                      (output of the DUT)
%
% Author: Antonin NOVAK
% Laboratoire d'Acoustique de l'Universite du Mans (LAUM) - UMR CNRS n.6613
% email address: antonin.novak@univ-lemans.fr
% Website: http://ant-novak.com
% July 2016; Last revision: 04-Nov-2019

%



%% check if the latency channel is a member of input channels
if ismember(latency_channel, input_channels)
    latency_channel_pos = find(latency_channel==input_channels, 1);
else
    disp('latency_channel must be a member of input_channels, latency will not be taken into account');
    return
end


%%
BufferSize = 1024;

N_input_channels  = length(input_channels);
N_output_channels = size(output_signal, 2);

% read the names of the selected sound cards
[Device_Name_IN,Device_Name_OUT] = Device_Names();

handle_audio_player = dsp.AudioPlayer( ...
    'DeviceName'            , Device_Name_OUT, ...
    'SampleRate'            , fs, ...
    'BufferSizeSource'      , 'Property', ...
    'BufferSize'            , BufferSize, ...
    'QueueDuration'         , 0);

handle_audio_recorder = dsp.AudioRecorder( ...
    'DeviceName'            , Device_Name_IN, ...
    'SampleRate'            , fs, ...
    'NumChannels'           , N_input_channels, ...
    'BufferSizeSource'      , 'Property', ...
    'BufferSize'            , BufferSize, ...
    'SamplesPerFrame'       , BufferSize, ...
    'ChannelMappingSource'  , 'Property', ...
    'ChannelMapping'        , input_channels, ...
    'QueueDuration'         , 0);



% synchronize on burst signal
T  = 1;                 % time of the burst
f0 = 1e3;               % burst main frequency
t  = (0:1/fs:T-1/fs)';  % time axis

% burst signal
burst = 0.5*real(exp(-(1000*(t-T/2)).^2 + 1i*2*pi*f0*t));

% insert the burst at the beginning of the output_signal
output_signal = [burst; output_signal];
N_samples  = size(output_signal, 1); 


% add zeros to the end of the input signal to match  
% an integer number of buffers
N_Buffers = ceil(size(output_signal, 1) / BufferSize);
output_signal_temp = zeros(N_Buffers*BufferSize, N_output_channels);
output_signal_temp(1:N_samples) = output_signal;

% prepare an empty array for output signals
input_signal = zeros(N_Buffers*BufferSize, N_input_channels);

% loop buffer by buffer to send and record signals
for n = 1 : N_Buffers
    
    % acquire a new buffer
    in_buffer = step(handle_audio_recorder);
    input_signal((n-1)*BufferSize+1:n*BufferSize,:) = in_buffer;
    
    % send a new buffer
    audio = output_signal_temp((n-1)*BufferSize+1:n*BufferSize,:);
    step(handle_audio_player,audio);
      
end

% cut added zeros (to match the length of the signals)
input_signal = input_signal(1:N_samples, :);

pause(handle_audio_player.QueueDuration);  % Wait until audio plays to the end
pause(handle_audio_recorder.QueueDuration);  % Wait until audio records to the end
release(handle_audio_player);  % close audio output device, release resources
release(handle_audio_recorder);  % close audio input device, release resources


% estimate the latency from the burst signal
out_burst = input_signal(1:T*fs, latency_channel_pos);
[~,pos] = max(out_burst);
latency = round(pos - T/2*fs);

input_signal = input_signal(fs+1+latency:end,:);





