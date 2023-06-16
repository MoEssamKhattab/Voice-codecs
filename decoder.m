%% Decoder 
%quantization mode
    % 0 => Mid rise
    % 1 => Mid tread
%Line codes
    % 0 => Manchester Signaling
    % 1 => Alternate Mark Inversion Signaling

function [restored_bit_stream, restored_quantized_signal] = decoder(t, PCM_signal, mp_max, mp_min, L, quantization_mode, line_code, n, pulse_amplitude)
    
    %%[1] Decoding the PCM -> bit stream
    restored_bit_stream = correlator_reciever(PCM_signal, n, line_code, pulse_amplitude);
        
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
        error('Not valid!');
    end  

    restored_q_levels_indices = bit2int(restored_bit_stream',bit_frame_size)';
    display(restored_q_levels_indices(1:5));
    
    restored_q_levels_indices = restored_q_levels_indices +1;       %so that we get the correct indices starting from 1,2,3,.. again
    restored_quantized_signal = quantization_levels(restored_q_levels_indices);

    nexttile
    plot(t, restored_quantized_signal);    %Plotting the restored quantized signal
    xlabel('t [sec]');
    ylabel('Amplitude');
    title('The restored quantized signal');

end