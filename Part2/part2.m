% Homework 1
% Lizzy Burl, Ethan Hill, Jorge Chang, James Burgess
% Part 2

clear;

<<<<<<< HEAD
=======
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
>>>>>>> origin/master


% 16,000 Hz means that 1 ms = 16 samples
% 25 ms = 400 samples
for soundFile = 1:9
    GetMFCC(sprintf('%da.wav',soundFile));
    GetMFCC(sprintf('%db.wav',soundFile));
end