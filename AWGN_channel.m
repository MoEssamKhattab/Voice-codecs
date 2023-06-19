function [noisy_signal] = AWGN_channel(t, signal, N0, n)  %N0 noise power in dB
    signal_power = pow2db(mean(abs(signal).^2));
    snr = signal_power/N0;
    noisy_signal = awgn(signal,snr,signal_power);

    nexttile
    plot(t(1: 20*n), noisy_signal(1 : 20*n));   %plotting the first 20 pulses of the PCM signal
    hold on
    xlabel('t [sec]');
    ylabel('Amplitude');
    title('Noisy PCM signal first 20 bits');
    legend('Channel output');
end