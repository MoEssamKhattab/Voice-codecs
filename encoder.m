%% Encoder
% 0 => Manchester Signaling
% 1 => Alternate Mark Inversion Signaling

function [PCM_t, PCM_signal] = encoder(bit_stream, pulse_amplitude, line_code, bit_rate, n) %n #samples/bit === the number of samples representing each bit
    t_total = length(bit_stream)/bit_rate;
    n_total = n*length(bit_stream);
    t_step = t_total / n_total;
    PCM_t = 0 : t_step : t_total;
    
    PCM_signal = zeros(1, length(PCM_t));
    A = pulse_amplitude;    %for simplicity

    if(line_code == 0)  %Manchester Signaling
        for i=1 : length(bit_stream)
            if (bit_stream(i)=='1')
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
            if (bit_stream(i)=='1')
                PCM_signal((i-1)*n +1 : i*n) = -A;
                A = -A;
            end
        end
        figure_title = 'AMI Signaling';
    end

    nexttile
    plot(PCM_t(1: 20*n),PCM_signal(1 : 20*n));    %Plotting the first 10 bits only
    xlabel('bits');
    ylabel('Amplitude');
    title(strcat(figure_title, ' first 10 bits'));
end
