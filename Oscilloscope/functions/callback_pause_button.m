function callback_pause_button(src, ~)
% CALLBACK_PAUSE_BUTTON - a callback function from button uicontrol 
% to pause the oscilloscope
%
% Is a subfunction of: create_figure_with_controls.m
%
% Author: Antonin Novak
% Laboratoire d'Acoustique de l'Université du Mans
% (LAUM, UMR CNRS 6613), 72085 Le Mans, France.
% email address: antonin.novak@univ-lemans.fr  
% Website: https://ant-novak.com
% October 2019; Last revision: 27-Oct-2019

%% ------------- BEGIN CODE --------------    

global IMDEA_oscilloscope

    IMDEA_oscilloscope.pause = ~IMDEA_oscilloscope.pause;
    if IMDEA_oscilloscope.pause
        set(src, 'String'         , 'Play');
        set(src, 'BackgroundColor', [1 0 0]);
    else
        set(src, 'String'         , 'Pause');
        set(src, 'BackgroundColor', [0 1 0]);
    end        

end

%% ------------- END CODE --------------    
