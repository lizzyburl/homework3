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
    % Create the hamming window
    h=hamming(winsize);
    % For each window
    for i=1:shift:length(x)-winsize
        % Take the fft
        X = fft(x(i:i+winsize-1).*h,winsize);
        L(:,c) = log(real(X).^2+imag(X).^2);
        c=c+1;
    end

    % do rescaling (4)
    % find the floor of L, reset to be 0
    mn=min(min(L));
    L=L-mn;

    % find the max of L.  Map L to a number between 0 and 128 (at first)
    % and then subtract 50 (-50 to 78)
    mx=max(max(L));
    L=floor(L/mx*128)-50;

    % map all numbers below 1 to 1, all numbers above 64 to 64
    L(find(L<1))=1;
    L(find(L>64))=64;
    pause;

end

function [b] = B(f)
    b = 1125*log(1 + f/7000);
end

function [b_inv] = Binv(f)
    b_inv = 700*exp(f/1125-1)
end

% N = number of points in FFT
% fl = Lower frequency of the filterbank
% fh = High frequency of the filterbank
function [f] = F(m)
    % M = # of filters (try 24 - 40)
    M = 24;
    % Fs = Sampling frequency (16,000)
    Fs = 16000;
    % N = The number of frequency bins)
    N = 400;
    % fl = 20 Hz. The low point of human hearing
    fl = 20
    % fh = 16000 Hz. Also our sampling frequency
    fh = 16000
    if m == 0
        f = 0;
    else
        % This might not be right...
        f = N/Fs * Binv(B(fl)+m*((B(fh)-B(fl))/(M+1)));
    end
end

function [h] = H(k, m)
    if (k < f(m-1))
    end
end