clc; close all; clear all;
% OSCILLOSCOPE - a program that works as an oscilloscope and signal
% generator (sine wave)
%
% Other m-files required: all subfunctions are saved in 'functions' folder
% MAT-files required: all data files are saved in 'data' folder
%
% Author: Antonin Novak
% Laboratoire d'Acoustique de l'Université du Mans
% (LAUM, UMR CNRS 6613), 72085 Le Mans, France.
% email address: antonin.novak@univ-lemans.fr
% Website: https://ant-novak.com
% October 2019; Last revision: 27-Oct-2019

%% ------------- BEGIN CODE --------------

global IMDEA_oscilloscope IMDEA_sound_card IMDEA_generator fs
addpath('functions');

% open a window with sound card settings
[DeviceName_player, DeviceName_recoreder] = change_sound_card();

% set the sampling rate fs and the buffer size
fs = 48000;
BufferSize = 4096;


%% IMDEA_sound_card object (structure)

IMDEA_sound_card.fs                = fs     ; % sampling frequency
IMDEA_sound_card.Device_Name_OUT   = DeviceName_player;
IMDEA_sound_card.Device_Name_IN    = DeviceName_recoreder;
IMDEA_sound_card.BufferSize        = BufferSize;
IMDEA_sound_card.out_channels      = [1 2];
IMDEA_sound_card.in_channels       = [1 2];

%% IMDEA_oscilloscope object (structure)

IMDEA_oscilloscope.trigger         = 1; % 1=off, 2=generator, 3=external
IMDEA_oscilloscope.trigger_channel = IMDEA_sound_card.in_channels(1);
IMDEA_oscilloscope.buffer          = zeros(BufferSize,length(IMDEA_sound_card.in_channels));
IMDEA_oscilloscope.last_buffer     = IMDEA_oscilloscope.buffer; % copy of the old buffer (needed only for the trigger ON)
IMDEA_oscilloscope.pause           = 0;
IMDEA_oscilloscope.active_channels = ones(size(IMDEA_sound_card.in_channels));


%% IMDEA_generator object (structure)

IMDEA_generator.f           = 1000;
IMDEA_generator.A           = 1;
IMDEA_generator.phase       = zeros(BufferSize, 1);
IMDEA_generator.t           = 1/fs : 1/fs : (BufferSize)/fs;
% start from 1/fs is usually not recommended,
% but here it helps to keep the phase contiuous from buffer to buffer
%%

try
    [handle_to_audio_player, handle_to_audio_recorder] = initiate_sound_card();
catch
    try % if sound card not found call change_sound_card()
        change_sound_card();
        [handle_to_audio_player, handle_to_audio_recorder] = initiate_sound_card();
    catch
        error('Selected sound card has not been found.');
    end
end
%%
disp(['Used Audio Player: ' DeviceName_player]);
disp(['Used Audio Recorder' DeviceName_recoreder]);


%% FIGURE and UI CONTROLS

[oscilloscope_figure_handle, plot_lines] = create_figure_with_controls();

%%


%%

PLAY = 1;
phi = zeros(1,BufferSize);

while PLAY
    IMDEA_oscilloscope.last_buffer = IMDEA_oscilloscope.buffer;
    
    % generate new buffer
    IMDEA_generator.phase = mod(2*pi*IMDEA_generator.f*IMDEA_generator.t + IMDEA_generator.phase(end), 2*pi);
    audio = IMDEA_generator.A * sin(IMDEA_generator.phase).';
    
    % send the generated signal to the sound card outputs
    step(handle_to_audio_player, audio);
    % receive new buffer for the oscilloscope
    IMDEA_oscilloscope.buffer = step(handle_to_audio_recorder);
    
    
    if ~IMDEA_oscilloscope.pause
        % trigger (number of samples to shift the buffer)
        plot_data = trigger_shift(IMDEA_oscilloscope.last_buffer);
    end
    
    
    % update each plot-line
    for n_channel = 1:length(IMDEA_sound_card.in_channels)
        if IMDEA_oscilloscope.active_channels(n_channel)
            set(plot_lines(n_channel), 'Ydata', plot_data(:,n_channel));
            set(plot_lines(n_channel), 'Visible', 'on');
        else
            set(plot_lines(n_channel), 'Visible', 'off');
        end
    end
    
    drawnow;
    
    
end

% close the oscilloscope figure
delete(oscilloscope_figure_handle);
 
% release the sound cards
pause(handle_to_audio_player.QueueDuration);  % Wait until audio plays to the end
release(handle_to_audio_player);    % close audio output device, release resources
delete (handle_to_audio_player);    % close audio iput device, release resources
release(handle_to_audio_recorder);
delete (handle_to_audio_recorder);


clear all;




%% ------------- END CODE --------------



