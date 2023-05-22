%%%% Main %%%%

[signal, fm] = audioread('shakal.mp3');
input_signal = signal(:,1);   % choose only the left channel
sound(input_signal, fm);
fs = 20e2;
L = 256;
quantization_mode  = 0;
pulse_amplitude = 1;
line_code = 0;
bit_rate = 1;
n = 100;
downsample_ratio = round(fm/fs);

[sampled_signal] = sampler(input_signal, fm, fs);
mp_max = max(sampled_signal);
mp_min = min(sampled_signal);
t = linspace(0, length(sampled_signal)*downsample_ratio/fm, length(sampled_signal));
[quantized_signal, mean_sqr_q_error, bit_stream] = quantizer(sampled_signal, t, mp_max, mp_min, L, quantization_mode);

[PCM_t, PCM_signal] = encoder(bit_stream, pulse_amplitude, line_code, bit_rate, n) ;

[restored_bit_stream, restored_quantized_signal] = decoder(t, PCM_signal, mp_max, mp_min, L, quantization_mode, line_code, n, pulse_amplitude);
sound(restored_quantized_signal, fm/downsample_ratio);
