function input_signal = measurement(output_signal, fs, input_channels)
%MEASUREMENT
% Measures the response of the device under test (DUT) (input_signal) to
% the signal (output_signal).
%
% Syntax:  input_signal = measurement(output_signal, fs, input_channels)
%
% Inputs:
%    output_signal    - output signal to be sent to the output of 
%                       the sound card (input to the DUT)
%    fs               - sampling frequency of the sound card
%    input_channels   - vector of input channels to be recorded
%
% Outputs:
%    input_signal    - input signal acquired at the input of the sound card
%                      (output of the DUT)
%
% Author: Antonin NOVAK
% Laboratoire d'Acoustique de l'Universite du Mans (LAUM) - UMR CNRS n.6613
% email address: antonin.novak@univ-lemans.fr
% Website: http://ant-novak.com
% July 2016; Last revision: 04-Nov-2019


BufferSize = 1024;
N_samples  = size(output_signal, 1); 

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

% release all the memory blocked by the sound card and DSP toolbox
pause(handle_audio_player.QueueDuration);  % Wait until audio plays to the end
pause(handle_audio_recorder.QueueDuration);  % Wait until audio records to the end
release(handle_audio_player);  % close audio output device, release resources
release(handle_audio_recorder);  % close audio input device, release resources

