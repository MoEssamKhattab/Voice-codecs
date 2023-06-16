% the basic function of the correlator reciever is to extract the correct
% bit stream representing the indices of the quantization levels of the
% quantized signal from the recieved PCM signal

function [restored_bit_stream] = correlator_reciever(PCM_signal, n, line_code, pulse_amplitude)
    A = pulse_amplitude; %for simplicity
    
    restored_bit_stream = zeros(1, length(PCM_signal)/n);
    pulse = zeros(1,n);   %Current pulse in the PCM signal
    index = 1;          %index of the current bit in the restored bit stream 
    
    if(line_code == 0)  %Manchester code
        pulse_1 = [A*ones(1,n/2) , -A*ones(1,n/2)];     % pulse 1 shape in Manchester code
        pulse_0 = [-A*ones(1,n/2) , A*ones(1,n/2)];     % pulse 0 shape in Manchester code
        
        for i=1 : n : length(PCM_signal)-n+1
            pulse = PCM_signal(i:i+n-1);
            %%Corellating each pulse with 0&1 pulse shapes
            corr_with_1 = xcorr(pulse, pulse_1);
            corr_with_0 = xcorr(pulse, pulse_0);
            
            index = floor(i/n)+1;

            if (max(corr_with_1) > max(corr_with_0))
                restored_bit_stream(index) = 1;
            else
                restored_bit_stream(index) = 0;
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

            index = floor(i/n)+1;
            
            if (max(corr_with_1) > max(corr_with_0))
                restored_bit_stream(index) = 1;
            else
                restored_bit_stream(index) = 0;
            end
        end
    else
        error('Not valid!');
    end  
end