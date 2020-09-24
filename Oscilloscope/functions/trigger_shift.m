function buffer_plot = trigger_shift(last_buffer)
% TRIGGER_SHIFT - a function that prepares a buffer of data to plot
% for triigered channel
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
% October 2019; Last revision: 05-Nov-2019

%% ------------- BEGIN CODE --------------

global IMDEA_generator IMDEA_sound_card IMDEA_oscilloscope


% trigger selector (off, internal, external)
switch IMDEA_oscilloscope.trigger

    case 1 % off
        
        N_trigger_shift = 0;
    
    case 2 % internal trigger
    
        % trigger is calculated based on the phase of the sine generator
        N_trigger_shift = round(IMDEA_generator.phase(end)/(2*pi*IMDEA_generator.f)*IMDEA_sound_card.fs);
        
        if N_trigger_shift < 0
            N_trigger_shift = 0;
        end
        
        if N_trigger_shift > IMDEA_sound_card.BufferSize
            N_trigger_shift = IMDEA_sound_card.BufferSize;
        end
        
    case 3 % external trigger
        
        % trigger time is estimated as the last 0.9*max value of the last buffer
        n = IMDEA_oscilloscope.trigger_channel;
        buffer_max = max(last_buffer(:,n));
        N_trigger_shift = IMDEA_sound_card.BufferSize - find(last_buffer(:,n)>0.9*buffer_max, 1, 'last') + 1;
        
end

buffer_plot = [IMDEA_oscilloscope.last_buffer(end-N_trigger_shift+1:end,:); IMDEA_oscilloscope.buffer(1:end-N_trigger_shift,:)];

%% ------------- END CODE --------------
