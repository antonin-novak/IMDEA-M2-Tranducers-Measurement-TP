function [device_names_player, device_names_recorder] = get_list_of_soundcards()
% GET_LOST_OF_SOUNDCARDS - a function that returns a list of sound cards
% found by the DSP Toolbox
% Syntax:  [device_names_player, device_names_recorder] = get_list_of_soundcards()
%
% Inputs:
%    function does not take any input
%
% Outputs:
%    device_names_player   - list of sound cards for output
%    device_names_recorder - list of sound cards for input
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% Author: Antonin Novak
% Laboratoire d'Acoustique de l'Université du Mans
% (LAUM, UMR CNRS 6613), 72085 Le Mans, France.
% email address: antonin.novak@univ-lemans.fr  
% Website: https://ant-novak.com
% October 2019; Last revision: 27-Oct-2019

%% ------------- BEGIN CODE --------------

%% Audio Player
handle_to_audio_player = dsp.AudioPlayer();
device_names_player    = set(handle_to_audio_player,'DeviceName');

release(handle_to_audio_player);
delete (handle_to_audio_player);

%% Audio Recorder
handle_to_audio_recorder = dsp.AudioRecorder();
device_names_recorder    = set(handle_to_audio_recorder,'DeviceName');

release(handle_to_audio_recorder);
delete (handle_to_audio_recorder);


%% ------------- END OF CODE --------------






