function [handle_audio_player, handle_audio_recorder] = initiate_sound_card()
% INITIATE_SOUND_CARD - a function that creates objects for audio player
% and audio recorder (DSP system toolbox) and returns their handles
%
% Syntax: [handle_audio_player, handle_audio_recorder] = initiate_sound_card()
%
% Inputs:
%    function does not take any input
%
% Outputs:
%    handle_audio_player    - handle of the audio player
%    handle_audio_recorder  - handle of the audio recorder
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

global IMDEA_sound_card

handle_audio_player = dsp.AudioPlayer( ...
    'DeviceName'              , IMDEA_sound_card.Device_Name_OUT, ...
    'SampleRate'              , IMDEA_sound_card.fs, ...
    'BufferSizeSource'        , 'Property', ...
    'BufferSize'              , IMDEA_sound_card.BufferSize, ...
    'QueueDuration'           , 0);

handle_audio_recorder = dsp.AudioRecorder( ...
    'DeviceName'            , IMDEA_sound_card.Device_Name_IN, ...
    'SampleRate'            , IMDEA_sound_card.fs, ...
    'BufferSizeSource'      , 'Property', ...
    'BufferSize'            , IMDEA_sound_card.BufferSize, ...
    'SamplesPerFrame'       , IMDEA_sound_card.BufferSize, ...
    'QueueDuration'         , 0, ...
    'ChannelMappingSource'  , 'Property', ...
    'ChannelMapping'        , IMDEA_sound_card.in_channels);

%% ------------- END CODE --------------

