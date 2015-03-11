% Homework 1
% Lizzy Burl, Ethan Hill, Jorge Chang, James Burgess
% Part 2

clear;

% 16,000 Hz means that 1 ms = 16 samples
% 25 ms = 400 samples
for soundFile = 1:10
    [x, fs, nbits] = wavread(sprintf('rex%d.wav',soundFile));
    timeSteps = size(x);
   
    winsize=400;
    shift=160;
    c=1;
    clear L;
    h=hamming(winsize);

    for i=1:shift:length(x)-winsize
         X=fft(x(i:i+winsize-1).*h,winsize);
         L(:,c)=log(real(X).^2+imag(X).^2);
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
end