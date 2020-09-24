function create_DeviceNames_file(Device_Name_OUT, Device_Name_IN)
% CREATE_DEVICENAMES_FILE - a function that creates an editable file
% 'Device_Names.m' with names of the sound cards. The file 'Device_Names.m'
% is next used by other matlab cards working with sound card.
%
% Syntax: buffer_plot = trigger_shift(last_buffer)
%
% Inputs:
%    last_buffer  ... (n-1) buffer
%
% Outputs:
%    buffer_plot  ... new buffer
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
% November 2019; Last revision: 05-Nov-2019

%% ------------- BEGIN CODE --------------  

fileID = fopen('../_functions/Device_Names.m','w');

fprintf(fileID,'%s\n','function [Device_Name_IN, Device_Name_OUT] = Device_Names()');
fprintf(fileID,'%s\n','');
fprintf(fileID,'%s\n','');
fprintf(fileID,'%s\n',['Device_Name_IN = ''' Device_Name_IN ''';']);
fprintf(fileID,'%s\n',['Device_Name_OUT = ''' Device_Name_OUT ''';']);

fclose(fileID);

%% ------------- END CODE --------------  
