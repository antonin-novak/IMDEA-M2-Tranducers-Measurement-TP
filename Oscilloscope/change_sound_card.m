function [last_soundcard_player, last_soundcard_recorder] = change_sound_card()
% CHANGE_SOUND_CARD - a function that saves the name of selected sound
% card to a data file 
% Syntax:  [DeviceName_player, DeviceName_recoreder] = change_sound_card()
%
% Inputs:
%    function does not take any input
%
% Outputs:
%    DeviceName_player      ...  name of the sound card player
%    DeviceName_recoreder   ... name of the sound card recorder
%
% Other m-files required: get_list_of_soundcards.m
% Subfunctions: selection_player, selection_recorder
% MAT-files required: 'data/last_timestamp.mat'
%
% Author: Antonin Novak
% Laboratoire d'Acoustique de l'Université du Mans
% (LAUM, UMR CNRS 6613), 72085 Le Mans, France.
% email address: antonin.novak@univ-lemans.fr  
% Website: https://ant-novak.com
% October 2019; Last revision: 27-Oct-2019

%% ------------- BEGIN CODE --------------
addpath('functions');
setpref('dsp','portaudioHostApi',3)

% file name of the data file
data_file_name = 'data/last_timestamp.mat';

% load names of last used soundcard_player and soundcard_recorder
load(data_file_name, 'last_soundcard_player', 'last_soundcard_recorder');

% create a new figure
handle_sundcard_figure = figure(...
    'Units'        , 'normalized', ...
    'Position'     , [0.4 0.3 0.3 0.2], ...
    'Name'         , 'Sound Card Selector', ...
    'NumberTitle'  , 'off', ...
    'ToolBar'      , 'none', ...
    'MenuBar'      , 'none', ...
    'WindowStyle'  , 'modal');

% get list of available sound cards (input and output)
[device_names_player, device_names_recorder] = get_list_of_soundcards();

% find the last used sound card output and set the index of the list
[idx_last_sound_player,~]   = find(ismember(device_names_player, last_soundcard_player));
if isempty(idx_last_sound_player)
    idx_last_sound_player = 1;
end

% find the last used sound card input and set the index of the list
[idx_last_sound_recorder,~] = find(ismember(device_names_recorder, last_soundcard_recorder));
if isempty(idx_last_sound_recorder)
    idx_last_sound_recorder = 1;
end

%% Save the sound cards (before selecting)
% this part of code is run in case a user closes the window without
% selecting the sound card.
last_soundcard_player   = device_names_player{idx_last_sound_player};
last_soundcard_recorder = device_names_recorder{idx_last_sound_recorder};
save(data_file_name, 'last_soundcard_recorder', 'last_soundcard_player', '-append');
% DeviceName_player = last_soundcard_player;
% DeviceName_recoreder = last_soundcard_recorder;



%% Sound Player selector
% text 'Sound Player'
uicontrol(handle_sundcard_figure, ...
    'Style'     , 'text', ...
    'Units'     , 'normalized', ...
    'Position'  , [0.05 0.7 0.25, 0.1], ...
    'String'    , 'Sound Player');

% popup menu of available output sound cards
uicontrol(handle_sundcard_figure, ...
    'Style'     , 'popupmenu', ...
    'Units'     , 'normalized', ...
    'Position'  , [0.3 0.7 0.5, 0.1], ...
    'String'    , device_names_player, ...
    'Value'     , idx_last_sound_player, ...
    'Callback'  , @selection_player);

    % function callback when selecting an output sound card
    % -- save the name of the output sound card
    function selection_player(src,~)
        try
            last_soundcard_player = src.String{src.Value};
            save(data_file_name, 'last_soundcard_player', '-append');
            disp([last_soundcard_player ' was saved as a default sound recorder']);
        catch
            err('ERROR: Not able to save the selected card to data/last_timestamp.mat');
        end
    end


%% Sound Recorder selector
% text 'Sound Recorder'
uicontrol(handle_sundcard_figure, ...
    'Style'     , 'text', ...
    'Units'     , 'normalized', ...
    'Position'  , [0.05 0.4 0.25, 0.1], ...
    'String'    , 'Sound Recorder');

% popup menu of available input sound cards
uicontrol(handle_sundcard_figure, ...
    'Style'     , 'popupmenu', ...
    'Units'     , 'normalized', ...
    'Position'  , [0.3 0.4 0.5, 0.1], ...
    'String'    , device_names_recorder, ...
    'Value'     , idx_last_sound_recorder, ...
    'Callback'  , @selection_recorder);

    % function callback when selecting an input sound card
    % -- save the name of the input sound card
    function selection_recorder(src,~)
        try
            last_soundcard_recorder = src.String{src.Value};
            save(data_file_name, 'last_soundcard_recorder', '-append');
            disp([last_soundcard_recorder ' was saved as a default sound recorder']);
        catch
            err('ERROR: Not able to save the selected card to data/last_timestamp.mat');
        end
    end


%% OK button
uicontrol(handle_sundcard_figure, ...
    'Style'     , 'pushbutton', ...
    'Units'     , 'normalized', ...
    'Position'  , [0.3 0.1 0.3, 0.15], ...
    'String'    , 'OK', ...
    'Callback'  , @ok_button);

    % function callback: close the window
    function ok_button(~,~)
        delete(handle_sundcard_figure);
    end



%% wait until the figrue closes
uiwait(handle_sundcard_figure);

%% create a .m file Device_Names for other measurements (TP M2 IMDEA)
create_DeviceNames_file(last_soundcard_player, last_soundcard_recorder);



end

%% ------------- END CODE --------------

