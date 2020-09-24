function output_signal = block_measurement(input_signal, input_channels)
%MEASUREMENT
% Measures the response of the device under test (DUT) (output_signal) to
% the signal (input_signal).
%
% Syntax:  output_signal = measurement(input_signal,fs,input_channels)
%
% Inputs:
%    input_signal    - signal to be sent to the output of the sound card
%                     (input to the DUT)
%    fs              - sampling frequency of the sound card
%    input_channels  - vector of input channels to be recorded
%
% Outputs:
%    output_signal - signal acquired at the input of the sound card
%                    (output of the DUT)
%
% Author: Antonin Novak
% Laboratoire d'Acoustique de l'Université du Mans
% (LAUM, UMR CNRS 6613), 72085 Le Mans, France.
% email address: antonin.novak@univ-lemans.fr
% Website: https://ant-novak.com
% October 2019; Last revision: 27-Oct-2019

%% ------------- BEGIN CODE --------------
global IMDEA_sound_card BufferSize

handle_audio_player = dsp.AudioPlayer( ...
    'DeviceName',IMDEA_sound_card.Device_Name_OUT, ...
    'SampleRate',IMDEA_sound_card.fs, ...
    'BufferSizeSource','Property', ...
    'BufferSize',BufferSize, ...
    'QueueDuration',0);

handle_audio_recorder = dsp.AudioRecorder( ...
    'DeviceName',IMDEA_sound_card.Device_Name_IN, ...
    'SampleRate',IMDEA_sound_card.fs, ...
    'NumChannels',max(input_channels), ...
    'BufferSizeSource','Property', ...
    'BufferSize',BufferSize, ...
    'SamplesPerFrame',BufferSize, ...
    'QueueDuration',0);

% prepaer an empty vector for recorder
output_signal = zeros(size(input_signal,1),length(input_channels));

% get the number of buffers
N_buffers = ceil(size(input_signal,1)/BufferSize);

% pad the last buffer with zeros
signal = zeros(N_buffers * BufferSize, size(input_signal,2));
signal(1:size(input_signal,1), :) = input_signal;

% buffer loop
for k = 1 : N_buffers
    in_buffer = step(handle_audio_recorder);
    
    audio = signal((k-1)*BufferSize+1:k*BufferSize,:);
    step(handle_audio_player,audio);
    
    
    output_signal((k-1)*BufferSize+1:k*BufferSize,:) = in_buffer(:,input_channels);
end


pause(handle_audio_player.QueueDuration);  % Wait until audio plays to the end
pause(handle_audio_recorder.QueueDuration);  % Wait until audio records to the end
release(handle_audio_player);  % close audio output device, release resources
release(handle_audio_recorder);  % close audio input device, release resources

%% ------------- END CODE --------------
