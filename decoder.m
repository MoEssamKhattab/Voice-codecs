%% Decoder 
%quantization
    % 0 => Mid rise
    % 1 => Mid tread
%Encoding
    % 0 => Manchester Signaling
    % 1 => Alternate Mark Inversion Signaling

function [restored_bit_stream, restored_quantized_signal] = decoder(t, PCM_signal, mp_max, mp_min, L, quantization_mode, line_code, n, pulse_amplitude)
    A = pulse_amplitude; %for simplicity
    
    %decoding the PCM -> bit stream
    restored_bit_stream = zeros(1, round(length(PCM_signal)/n));
    bit = zeros(1,n);
    
    if(line_code == 0)  %Manchester
        pulse_1 = [A*ones(1,n/2) , -A*ones(1,n/2)];
        pulse_0 = [-A*ones(1,n/2) , A*ones(1,n/2)];
        
        for i=1 : n : length(PCM_signal)-n
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
        pulse_1 = A*ones(1,n);          %the correlation is to be with the absolute value of the current bit
        pulse_0 = zeros(1,n);

        for i=1 : n : length(PCM_signal)-n
            bit = PCM_signal(i:i+n-1);    %current bit

            %%Corellating each bit with 0&1 pulse shapes
            corr_with_1 = xcorr(abs(bit), abs(pulse_1));
            corr_with_0 = xcorr(bit, pulse_0);

            index = floor(i/n)+1;
            
            if (max(corr_with_1) > max(corr_with_0))
                restored_bit_stream(index) = 1;
            else
                restored_bit_stream(index) = 0;
            end
        end
    end
        
    %% dequantizing
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
    end  

    restored_q_levels_size = floor(log2(L));
    restored_q_levels_indices = zeros(1,restored_q_levels_size);

    for i=1 : bit_frame_size: length(restored_bit_stream)-bit_frame_size+1
        index = fix((i-1)/bit_frame_size)+1;
        restored_q_levels_indices(index) = bin2dec(num2str(reshape(restored_bit_stream(i:i+bit_frame_size-1)',1,[])));

    end
    display(restored_q_levels_indices(1:10));

    restored_quantized_signal = quantization_levels(restored_q_levels_indices);


    nexttile
    plot(t, restored_quantized_signal);    %Plotting the restored quantized signal

end