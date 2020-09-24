% LIST_OF_SOUNDCARDS - a script that prints a list of sound cards
% found by the DSP Toolbox
%
% Author: Antonin Novak
% Laboratoire d'Acoustique de l'Universite du Mans
% (LAUM, UMR CNRS 6613), 72085 Le Mans, France.
% email address: antonin.novak@univ-lemans.fr  
% Website: https://ant-novak.com
% October 2019; Last revision: 01-Nov-2019

%% ------------- BEGIN CODE --------------
setpref('dsp','portaudioHostApi',3)

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

disp('Device Names Player:');
disp(device_names_player)

disp('Device Names Recorder:');
disp(device_names_recorder)
%% ------------- END OF CODE --------------






