function [ ] = GetMFCC( filepath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in the audio file
    [x, fs, nbits] = wavread(filepath);
    timeSteps = size(x);
    
    % Winsize of 400 samples = 25 ms
    % Shift of 160 = 10 ms
    winsize=400;
    shift=160;
    c=1;  
    
    lower = 30;
    upper = 8000;
    
    M = 24;
    % First, let's dynamically build our filter bank based on the lower
    % frequency and the upper frequency.
    bins = GetBins(lower, upper, M);
    fprintf('%g\n', bins);
    % Create the hamming window
    h=hamming(winsize);
    % For each window
    for i=1:shift:length(x)-winsize
        % Take the fft
        X = fft(x(i:i+winsize-1).*h,winsize);
        
    end

    pause;

end

function [bins] = GetBins(lower, upper, M)
    lower_mel = B(lower);
    upper_mel = B(upper);
    bins_in_mel = zeros(1, M+1);
    bins_in_mel(1) = lower_mel;
    bins_in_mel(M+1) = upper_mel;
    bin_size = (upper_mel - lower_mel)/(M);
    for i = 2:1:M
        bins_in_mel(i) = bins_in_mel(i-1) + bin_size;
    end
    bins = Binv(bins_in_mel);
end

function [b] = B(f)
    b = 1125*log(1 + f/700);
end

function [b_inv] = Binv(f)
    b_inv = 700*(exp(f/1125)-1);
end

% N = number of points in FFT
% fl = Lower frequency of the filterbank
% fh = High frequency of the filterbank
function [f] = F(m, M, bins)
    % M = # of filters (try 24 - 40)
    M = 24;
    % Fs = Sampling frequency (16,000)
    Fs = 16000;
    % N = The number of frequency bins)
    N = 400;
    fl = bins(m);
    fh = bins(m+1);
    if m == 0
        f = 0;
    elseif m == M
        f = N/Fs
    else
        % This might not be right...
        f = N/Fs * Binv(B(fl)+m*((B(fh)-B(fl))/(M+1)));
    end
end

function [h] = H(k, m, M, bins)
    if (k < F(m-1, M, bins))
    end
end