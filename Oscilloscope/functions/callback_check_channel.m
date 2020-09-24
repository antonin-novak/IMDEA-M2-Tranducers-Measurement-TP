function callback_check_channel(src, ~, n)
% CALLBACK_CHECK_CHANNEL - a callback function from checkbox uicontrol
% to set active channels
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

    IMDEA_oscilloscope.active_channels(n) = get(src,'Value');

end

%% ------------- END CODE --------------
