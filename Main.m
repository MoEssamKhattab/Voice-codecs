%% Test case I
%{
%Reading the audio signal
[signal, fm] = audioread('input_audio.wav');
input_signal = signal(:,1);   %only the left channel of the input signal
sound(input_signal, fm);

%Sampler
fs = 40e2;  %the required sampling rate
[t, sampled_signal, Fs] = sampler(input_signal, fm, fs);

%Quantizer
quantization_mode  = 0;     %Mid-rise
L = 256;                    %the number of quantization levels
[quantized_signal, mean_sqr_q_error, bit_stream, mp_max, mp_min, R] = quantizer(sampled_signal, t, L, quantization_mode);

%Encoder
pulse_amplitude = 5;
line_code = 1;
bit_rate = 10000;
n = 100;
[PCM_t, PCM_signal] = encoder(Fs, R, bit_stream, pulse_amplitude, line_code, bit_rate, n) ;

%Neither Channel nor regenerative repeaters are included (in this test case)

%Decoder
[restored_bit_stream, restored_quantized_signal] = decoder(t, PCM_signal, mp_max, mp_min, L, quantization_mode, line_code, n, pulse_amplitude);
sound(restored_quantized_signal, Fs);
%}

%% Test case II

%Reading the audio signal
[signal, fm] = audioread('input_audio.wav');
input_signal = signal(:,1);   %only the left channel of the input signal
sound(input_signal, fm);

%Sampler
fs = 50e2;  %the required sampling rate
[t, sampled_signal, Fs] = sampler(input_signal, fm, fs);

%Quantizer
quantization_mode  = 1;
L = 256;                    %the number of quantization levels
[quantized_signal, mean_sqr_q_error, bit_stream, mp_max, mp_min, R] = quantizer(sampled_signal, t, L, quantization_mode);

%Encoder
line_code = 1;
pulse_amplitude = 5;
bit_rate = 10000;
n = 100;
[PCM_t, PCM_signal] = encoder(Fs, R, bit_stream, pulse_amplitude, line_code, bit_rate, n) ;

%Channel
N0 = 4;     %noise power (variance)
noisy_signal = AWGN_channel(PCM_t, PCM_signal, N0, n);

%Regenerative repeaters
regenerated_PCM_signal = regenerative_repeater(PCM_t, noisy_signal, n, line_code, pulse_amplitude);

%Decoder
[restored_bit_stream, restored_quantized_signal] = decoder(t, regenerated_PCM_signal, mp_max, mp_min, L, quantization_mode, line_code, n, pulse_amplitude);
sound(restored_quantized_signal, Fs);

%audiowrite("restored_signal.wav", restored_quantized_signal, Fs)
%%uncomment to export the restored signal file