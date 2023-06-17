%f = the original signal frequency
%fs = the new sampling rate

function [t, sampled_signal] = sampler(input_signal, fm, fs)
    n = round(fm/fs);    %the downsampling factor must be an integer
    sampled_signal = downsample(input_signal,n);    %decreases sample rate by integer factor
    t = linspace(0, length(sampled_signal)*n/fm, length(sampled_signal));
end