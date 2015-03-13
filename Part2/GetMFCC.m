function [ cep_matrix ] = GetMFCC( filepath, lower, upper, M )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    tic;
% Read in the audio file
    [x, fs, nbits] = wavread(filepath);
    % Winsize of 400 samples = 25 ms
    % Shift of 160 = 10 ms
    winsize=400;
    shift=160;
      
    % First, let's dynamically build our filter bank based on the lower
    % frequency and the upper frequency.
    bins = GetBins(lower, upper, M);
    % Create the hamming window
    h=hamming(winsize);
    % For each window
    j = 1;
    len = 1;
    for i=1:shift:length(x)-winsize
        len = len + 1;
    end
    cep_matrix = zeros(13, len);
    for i=1:shift:(length(x)-winsize)
        % Take the fft for one timestep
        X = fft(x(i:i+winsize-1).*h,winsize);
        c = zeros(13,1);
        for coeff = 0:12
            c(coeff+1) = C(coeff, M, bins, X);
        end
        disp(c)
        cep_matrix(:, j) = c;
        fprintf('%d   ', j);
        j = j + 1;
    end
    t = toc;
    fprintf('Time: %d\n\n', t);
    pcolor(cep_matrix);
    title(filepath);
    figure();
end

%% Get the pre-defined bins dynamically

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

%% Functions to convert to mel and back
function [b] = B(f)
    b = 1125*log(1 + f/700);
end

function [b_inv] = Binv(f)
    b_inv = 700*(exp(f/1125)-1);
end

%% F
% m: the frequency bin
% M: The ubmer of frequency bins
% The intervals for the frequency bins
function [f] = F(m, M, bins)
    % Fs = Sampling frequency (16,000)
    Fs = 16000;
    % N = The number of points in FFT
    N = 400;
    if m == 0
        f = 0;
    elseif m == M
        f = N/Fs;
    else
        % fl = Lower frequency of the filterbank
        fl = bins(m+1);
        % fh = High frequency of the filterbank
        fh = bins(m+2);
        % This might not be right...
        f = N/Fs * Binv(B(fl)+m*((B(fh)-B(fl))/(M+1)));
    end
end

%% H
% m: the freqency bin
% k: The timestep in the window
% M: The total number of bins
% bins: The edges of each bin
function [h] = H(k, m, M, bins)
    if (k < F(m-1, M, bins))
        h = 0;
    elseif ((k >= F(m-1, M, bins))&&(k<=F(m, M, bins)))
        %h = (2*(k-F(m-1,M,bins)))/((F(m+1,M,bins)-F(m-1,M,bins))*(F(m,M,bins)-F(m-1,M,bins)));
        h = (k-F(m-1,M,bins))/(F(m,M,bins)-F(m-1,M,bins));
    elseif ((k >= F(m, M, bins))&&(k<=F(m+1, M, bins)))
        %h = (2*(F(m+1,M,bins)-k))/((F(m+1,M,bins)-F(m-1,M,bins))*(F(m+1,M,bins)-F(m,M,bins)));
        h = (F(m+1, M, bins)-k)/(F(m+1, M, bins)-F(m, M, bins));
    else
        h = 0;
    end
end

%% S 
% m: the freqency bin
% M: The total number of bins
% bins: The edges of each bin
% X: 
function [s] = S(m, M, bins, X)

sum = 0;
for k = 0:length(X)-1
    %disp(k);
    %disp((real(X(k+1))^2+imag(X(k+1))^2)*H(k, m, M, bins));
    sum = sum + (real(X(k+1))^2+imag(X(k+1))^2)*H(k, m, M, bins);
end
s = log(sum);
end

%% C
% n: The cepstral coefficient
% M: The total number of bins
% bins: The edges of each bin
% X: The time frame
function [c] = C(n, M, bins, X)
    c = 0;
    for m = 1:M-1
        c = c + S(m, M, bins, X)*cos(pi*n*(m - .5)/M);
    end 
end
