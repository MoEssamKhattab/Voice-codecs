%%%% Main %%%%

[signal, fm] = audioread('shakal.mp3');
input_signal = signal(:,1);   % choose only the left channel of the input signal
sound(input_signal, fm);
fs = 20e2;
L = 256;
R = ceil(log2(L));
quantization_mode  = 0;
pulse_amplitude = 5;
line_code = 1;
bit_rate = 1000;
n = 100;
downsample_ratio = round(fm/fs);

[t, sampled_signal] = sampler(input_signal, fm, fs);
mp_max = max(sampled_signal);
mp_min = min(sampled_signal);

[quantized_signal, mean_sqr_q_error, bit_stream] = quantizer(sampled_signal, t, mp_max, mp_min, L, quantization_mode);

[PCM_t, PCM_signal] = encoder(fs, R, bit_stream, pulse_amplitude, line_code, bit_rate, n) ;

N0 = 1;
noisy_signal = AWGN_channel(PCM_t, PCM_signal, N0, n);

regenerated_PCM_signal = regenerative_repeater(PCM_t, PCM_signal, n, line_code, pulse_amplitude);

[restored_bit_stream, restored_quantized_signal] = decoder(t, PCM_signal, mp_max, mp_min, L, quantization_mode, line_code, n, pulse_amplitude);
sound(restored_quantized_signal, fm/downsample_ratio);
