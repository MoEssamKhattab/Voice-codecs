% Quantization Mode
    % 0 => Mid rise
    % 1 => Mid tread

function [quantized_signal, mean_sqr_q_error, bit_stream] = quantizer(input_signal, t, mp_max, mp_min, L, quantization_mode)
    
    delta = (mp_max-mp_min)/L;  %step size

    if(quantization_mode == 0)  %mid rise
        %Initializing quantization levels
        min_q_level = mp_min + delta/2;
        max_q_level = mp_max - delta/2;
        quantization_levels = min_q_level : delta : max_q_level;
        
        %clipping the input signal at the boundries of the quantization
        %levels === mapping the values outside the boundries of the
        %quantization levels into these boundries 
        modified_input_signal = max(min_q_level, min(input_signal,max_q_level));

        %Mid rise to mid tread => so that we can map the amplitudes between
        %the middle threshold, in case it = zero (signal amplitudes centered around 0),
        % and the first quantization level under that threshold
        % to -ve values instead of +ve values (having correct mapping)
        modified_input_signal = modified_input_signal + delta/2;
        
        index = quantization(modified_input_signal, delta);
        
    elseif(quantization_mode == 1)  %Mid tread
        %Initializing quantization levels
        min_q_level = mp_min+delta;
        max_q_level = mp_max;
        quantization_levels = min_q_level : delta : max_q_level;
        
        %clipping the input signal at the boundries of the quantization
        %levels
        modified_input_signal = max(min_q_level, min(input_signal,max_q_level));
        
        index = quantization(modified_input_signal, delta);
    else
        warning('Not valid!');        
    end
    
    quantized_signal = quantization_levels(index); %the actual quantized signal

    %figure of input signal and the quantized signal
    nexttile
    plot(t, input_signal);
    hold on
    stairs(t,quantized_signal);
    legend('Input Signal', 'Quantized Signal');
    xlabel('t[sec]');
    ylabel('Amplitude');
    title('input signal vs. quantized signal');

    %the mean square quantization error
    q_error = quantized_signal - input_signal;  
    mean_sqr_q_error = mean(q_error.^2);

    %A stream of bits representing the quantized signal
    % here we map the quantization levels indices into binary values
    % represinting the bit stream (since the indices are positive intger, easy to be mapped into binary numbers and vice versa)
    
    index = index-1;    %for 0 to be included in binary representation of the indices
    bit_frame_size = ceil(log2(L));    %ciel is used in case L is not binary weighted
    
    bit_stream = int2bit(index,bit_frame_size);
    %display(bit_stream(:, 1:5));
    bit_stream = reshape(bit_stream, 1, numel(bit_stream));
    
    display(index(1:5));
    display(bit_frame_size);
    display('Bit stream: ');
    display(bit_stream(1:20));
    
end