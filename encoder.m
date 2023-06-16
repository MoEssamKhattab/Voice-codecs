%% Encoder
% 0 => Manchester Signaling
% 1 => Alternate Mark Inversion Signaling

function [PCM_t, PCM_signal] = encoder(fs, R, bit_stream, pulse_amplitude, line_code, bit_rate, n) %n #samples/bit === the number of samples representing each bit
    Tb = 1/bit_rate;    %bit duration
    Ts = 1/fs;

    if (Ts < R*Tb)
        warning("Not valid! the sampling period must be larger than the bit frame total duration!");
    end

    t_total = length(bit_stream) * Tb;  %total time duration of all bits
    n_total = n*length(bit_stream);
    t_step = Tb / n;
    PCM_t = 0 : t_step : t_total-t_step;
    
    PCM_signal = zeros(1, n_total);
    A = pulse_amplitude;    %for simplicity

    if(line_code == 0)  %Manchester Signaling
        for i=1 : length(bit_stream)
            if (bit_stream(i)==1)
                PCM_signal((i-1)*n +1 : (i-1)*n+(n/2)) = A;
                PCM_signal((i-1)*n+(n/2)+1 : i*n) = -A;
            else
                PCM_signal((i-1)*n +1 : (i-1)*n+(n/2)) = -A;
                PCM_signal((i-1)*n+(n/2)+1 : i*n) = A;
            end
        end
        
        figure_title = 'Manchester Signaling';
    
    elseif(line_code == 1)  %  AMI Signaling
        for i=1 : length(bit_stream)
            if (bit_stream(i)==1)
                PCM_signal((i-1)*n +1 : i*n) = A;
                A = -A;
            % for 0 bits, the PCM signal is already initialized by zeros
            end
        end
        figure_title = 'AMI Signaling';
    end

    nexttile
    plot(PCM_t(1: 20*n),PCM_signal(1 : 20*n));    %Plotting the first 10 bits only
    xlabel('bits');
    ylabel('Amplitude');
    title(strcat(figure_title, ' first 20 bits'));
end
