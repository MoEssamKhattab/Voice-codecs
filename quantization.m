function [index] = quantization(input_signal, delta)
    %The quantization we implement here is actually mapping the
    %amplitudes to the indices of the corresponding quantization levels
    %in the 'quantization_levels' vector that we already intialized      
    %the reason why we map the amplitudes to their corresponding
    %indices instead of the quantization levels themselves, is that the
    %indices are non-negative int values that could be easily
    %represented by their binary values constructing the bit_stream
    %which is the output of the quantizer, unlike the values of the
    %quantization levels which could be negative and non-int (more complex to be represented by their binary values)
    
    index = fix(input_signal/(delta/2));    %comparing to the threshold

    %the odd indices represent the threshols instead of the
    %quantization levels, so each must be mapped to the nearest larger
    %even index (representing the corresponding quantization level)
    index(mod(index,2)~=0) = sign(index(mod(index,2)~=0)).*(abs(index(mod(index,2)~=0))+1);
    
    %all indices now are even intgers only, must be divided by 2
    index = index./2;
    if (min(index)<=0)  %to ensure having accepted indices: 1,2,3,...
        index = index - min(index)+1;
    end
end