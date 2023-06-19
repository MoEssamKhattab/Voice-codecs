function [regenerated_PCM_signal] = regenerative_repeater(t, PCM_signal, n, line_code, pulse_amplitude)
    
    A = pulse_amplitude; %for simplicity
    pulse = zeros(1,n);   %Current pulse in the PCM signal
    regenerated_PCM_signal = zeros(1, length(PCM_signal));   %initializing the regenerated PCM signal

    if(line_code == 0)  %Manchester code
        pulse_1 = [A*ones(1,n/2) , -A*ones(1,n/2)];     % pulse 1 shape in Manchester code
        pulse_0 = [-A*ones(1,n/2) , A*ones(1,n/2)];     % pulse 0 shape in Manchester code
        
        for i=1 : n : length(PCM_signal)-n+1
            pulse = PCM_signal(i:i+n-1);
            %%Corellating each pulse with 0&1 pulse shapes
            corr_with_1 = xcorr(pulse, pulse_1);
            corr_with_0 = xcorr(pulse, pulse_0);
            
            if (max(corr_with_1) > max(corr_with_0))
                regenerated_PCM_signal(i:i+n-1) = pulse_1;
            else
                regenerated_PCM_signal(i:i+n-1) = pulse_0;
            end
        end
        
    elseif (line_code == 1) %AMI code
        %pulse 1 shapes will be correlated with the absolute value of the current pulse 
        pulse_1 = A*ones(1,n);
        pulse_0 = zeros(1,n);

        for i=1 : n : length(PCM_signal)-n
            pulse = PCM_signal(i:i+n-1);    %current pulse

            %%Corellating each pulse with 0&1 pulse shapes
            corr_with_1 = xcorr(abs(pulse), pulse_1);
            corr_with_0 = xcorr(pulse, pulse_0);
            
            if (max(corr_with_1) > max(corr_with_0))
                regenerated_PCM_signal(i:i+n-1) = A;
                A = -A;
            end
            %for the 0, the regenerated_PCM_signal is already initialized
            %by zeros
        end
    else
        error('Not valid!');
    end

    nexttile
    plot(t(1: 20*n),regenerated_PCM_signal(1: 20*n));
    hold on
    xlabel('t [sec]');
    ylabel('Amplitude');
    title('Regenerated PCM signal first 20 bits');
    legend('Regenerative repeater output');
end