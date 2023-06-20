fs = 100;
t = -5 : 1/fs : 5;
input_signal = 5 * sin(20*t);
L = 10;

quantization_mode  = 1;
pulse_amplitude = 1;
line_code = 1;
bit_rate = 1000;
n = 1000;

[quantized_signal, mean_sqr_q_error, bit_stream,  mp_max, mp_min, R] = quantizer(input_signal, t, L, quantization_mode);

[PCM_t, PCM_signal] = encoder(fs, R, bit_stream, pulse_amplitude, line_code, bit_rate, n) ;

[restored_bit_stream, restored_quantized_signal] = decoder(t, PCM_signal, mp_max, mp_min, L, quantization_mode, line_code, n, pulse_amplitude);