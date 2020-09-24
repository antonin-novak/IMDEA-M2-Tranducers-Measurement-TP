function callback_amplitude_change(src, ~)
% CALLBACK_AMPLITUDE_CHANGE - a callback function from edit uicontrol 
% to change amplitude
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

global IMDEA_generator

% set the frequency
IMDEA_generator.A = str2double(get(src,'String'));

% check the amplitude limits and modify back he edit field
% (0 - 1)
IMDEA_generator.A = min(max(IMDEA_generator.A, 0), 1);
set(findobj('Tag','amplitude_edit'), 'String', num2str(IMDEA_generator.A,'%5.1f'));


end

%% ------------- END CODE --------------

