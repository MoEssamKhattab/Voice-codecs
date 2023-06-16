%% Decoder 
%quantization mode
    % 0 => Mid rise
    % 1 => Mid tread
%Line codes
    % 0 => Manchester Signaling
    % 1 => Alternate Mark Inversion Signaling

function [restored_bit_stream, restored_quantized_signal] = decoder(t, PCM_signal, mp_max, mp_min, L, quantization_mode, line_code, n, pulse_amplitude)
    A = pulse_amplitude; %for simplicity
    
    %[1] Decoding the PCM -> bit stream
    restored_bit_stream = zeros(1, length(PCM_signal)/n);
    bit = zeros(1,n);   %Current bit in the PCM signal
    index = 1;          %index of the current bit in the restored bit stream 
    
    if(line_code == 0)  %Manchester
        pulse_1 = [A*ones(1,n/2) , -A*ones(1,n/2)];     % pulse 1 shape in Manchester code
        pulse_0 = [-A*ones(1,n/2) , A*ones(1,n/2)];     % pulse 0 shape in Manchester code
        
        for i=1 : n : length(PCM_signal)-n+1
            bit = PCM_signal(i:i+n-1);
            %%Corellating each bit with 0&1 pulse shapes
            corr_with_1 = xcorr(bit, pulse_1);
            corr_with_0 = xcorr(bit, pulse_0);
            
            index = floor(i/n)+1;

            if (max(corr_with_1) > max(corr_with_0))
                restored_bit_stream(index) = 1;
            else
                restored_bit_stream(index) = 0;
            end
        end
        
    elseif (line_code == 1) %AMI
        %pulse 1 shapes will be correlated with the absolute value of the current bit 
        pulse_1 = A*ones(1,n);
        pulse_0 = zeros(1,n);

        for i=1 : n : length(PCM_signal)-n
            bit = PCM_signal(i:i+n-1);    %current bit

            %%Corellating each bit with 0&1 pulse shapes
            corr_with_1 = xcorr(abs(bit), pulse_1);
            corr_with_0 = xcorr(bit, pulse_0);

            index = floor(i/n)+1;
            
            if (max(corr_with_1) > max(corr_with_0))
                restored_bit_stream(index) = 1;
            else
                restored_bit_stream(index) = 0;
            end
        end
    end
        
    %% [2] Dequantization
    delta = (mp_max-mp_min)/L;
    bit_frame_size = ceil(log2(L));

    if(quantization_mode == 0)  %mid rise
        %Quantization levels
        min_q_level = mp_min+delta/2;
        max_q_level = mp_max - delta/2;
        quantization_levels = min_q_level : delta : max_q_level;
    
    elseif(quantization_mode == 1)  %Mid tread
        %Quantization levels
        min_q_level = mp_min+delta;
        max_q_level = mp_max;
        quantization_levels = min_q_level : delta : max_q_level;
    else
        error('Not valid');
    end  

    restored_q_levels_indices = bit2int(restored_bit_stream',bit_frame_size)';
    display(restored_q_levels_indices(1:5));
    
    restored_q_levels_indices = restored_q_levels_indices +1;       %so that we get the correct indices starting from 1,2,3,.. again
    restored_quantized_signal = quantization_levels(restored_q_levels_indices);


    nexttile
    plot(t, restored_quantized_signal);    %Plotting the restored quantized signal

end