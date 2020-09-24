function callback_freq_change(src, ~)
% CALLBACK_FREQ_CHANGE - a callback function from edit uicontrol 
% to change frequency
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

global IMDEA_generator fs

% set the frequency
IMDEA_generator.f = str2double(get(src,'String'));

% check the frequency limits and modify back he edit field
% (1 Hz - fs/2 Hz)
IMDEA_generator.f = min(max(IMDEA_generator.f, 1), fs/2);
set(findobj('Tag','freq_edit'), 'String', num2str(IMDEA_generator.f,'%5.1f'));

end

%% ------------- END CODE --------------

