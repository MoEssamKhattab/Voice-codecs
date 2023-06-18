%The function of the sampler here is actually a downsampling of an already
%oversampled signal (a simulation of the A/D sampler)

%fm = the original (oversampled) signal frequency
%fs = the required sampling rate
%Fs = the new sammpling rate

function [t, sampled_signal, Fs] = sampler(input_signal, fm, fs)
    n = round(fm/fs);    %the downsampling factor must be an integer
    sampled_signal = downsample(input_signal,n);    %decreases sample rate by integer factor
    Fs = fm/n;          %the new sampling rate
    t = linspace(0, length(sampled_signal)/Fs, length(sampled_signal));
end

% the new sampling rate (Fs) is not always exactly the required sampling
% rate (fs), since the the downsampling factor must be rounded to an intger