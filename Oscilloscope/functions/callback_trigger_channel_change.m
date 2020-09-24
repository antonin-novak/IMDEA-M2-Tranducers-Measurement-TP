function callback_trigger_channel_change(src, ~)
% CALLBACK_TRIGGER_CHANNEL_CHANGE - a callback function from popup uicontrol
% to change the trigger channel
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

    IMDEA_oscilloscope.trigger_channel = src.Value;

end

%% ------------- END CODE --------------  
