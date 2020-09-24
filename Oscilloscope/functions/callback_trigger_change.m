function callback_trigger_change(src, ~)
% CALLBACK_TRIGGER_CHANGE - a callback function from popup uicontrol
% to change the trigger type
%
% Is a callback function of: create_figure_with_controls.m
%
% Author: Antonin Novak
% Laboratoire d'Acoustique de l'Université du Mans
% (LAUM, UMR CNRS 6613), 72085 Le Mans, France.
% email address: antonin.novak@univ-lemans.fr  
% Website: https://ant-novak.com
% October 2019; Last revision: 27-Oct-2019

%% ------------- BEGIN CODE --------------  

global IMDEA_oscilloscope

    IMDEA_oscilloscope.trigger = src.Value;

    trigger_channel_popup_menu = findobj('Tag', 'trigger_channel');

    % if external trigger (value 3), the trigger channel need to be
    % enabled. If no, or internal trigger is selected, disable it
    if src.Value == 3
        set(trigger_channel_popup_menu, 'Enable', 'on'); 
    else
        set(trigger_channel_popup_menu, 'Enable', 'off'); 
    end
end

%% ------------- END CODE --------------  
