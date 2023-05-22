% Quantization Mode
% 0 => Mid rise
% 1 => Mid tread

function [quantized_signal, mean_sqr_q_error, bit_stream] = quantizer(input_signal, t, mp_max, mp_min, L, quantization_mode)
    
    delta = (mp_max-mp_min)/L;

    if(quantization_mode == 0)  %mid rise
        %Quantization levels
        min_q_level = mp_min+delta/2;
        max_q_level = mp_max - delta/2;
        quantization_levels = min_q_level : delta : max_q_level;
        
        %clipping the input signal at the boundries of the quantization
        %levels
        modified_input_signal = max(min_q_level, min(input_signal,max_q_level));

        %Mid rise to mid tread => in order to map the nearst -ve value to
        %the middle threshold (could be zero, to a -ve value instead of a +ve value)
        modified_input_signal = modified_input_signal + delta/2;
        
        index = fix(modified_input_signal/(delta/2));    %comparing to the threshold
        index(mod(index,2)~=0) = sign(index(mod(index,2)~=0)).*(abs(index(mod(index,2)~=0))+1);
        index = index./2;
        if (min(index)<=0)
            index = index - min(index)+1;
        end
        quantized_signal = quantization_levels(index);

    elseif(quantization_mode == 1)  %Mid tread
        %Quantization levels
        min_q_level = mp_min+delta;
        max_q_level = mp_max;
        quantization_levels = min_q_level : delta : max_q_level;
        
        %clipping the input signal at the boundries of the quantization
        %levels
        modified_input_signal = max(min_q_level, min(input_signal,max_q_level));
        
        index = fix(modified_input_signal/(delta/2));    %comparing to the threshold
        index(mod(index,2)~=0) = sign(index(mod(index,2)~=0)).*(abs(index(mod(index,2)~=0))+1);
        index = index./2;
        if (min(index)<=0)
            index = index - min(index)+1;
        end
        quantized_signal = quantization_levels(index);
        
    end
    
    %figure of input signal and the quantized signal
    nexttile
    plot(t, input_signal);
    hold on
    stairs(t,quantized_signal);
    legend('Input Signal', 'Quantized Signal');
    xlabel('t[sec.]');
    ylabel('Amplitude');
    title('input signal vs. quantized signal');

    %the mean square quantization error
    q_error = quantized_signal - input_signal;  
    mean_sqr_q_error = mean(q_error.^2);

    %A stream of bits representing the quantized signal
    % here we map the quantization levels indices into binary values
    % represinting the bit stream (since the indices are positive intger, easy to be mapped into binary numbers and vice versa)
    
    bit_frame_size = ceil(log2(L));    %ciel is used in case L is not binary weighted
    bit_stream = reshape(dec2bin(index,bit_frame_size)',1,[]);
    display(index(1:10));
    display('Bit stream: ');
    display(bit_stream);
    
end