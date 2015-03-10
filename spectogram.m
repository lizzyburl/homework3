% Homework 1
% Lizzy Burl, Ethan Hill, Jorge Chang, James Burgess

%% Part 1: Building Your Own Spectrogram
clear;
[x, fs, nbits] = wavread('rex8.wav');
plot(x);
sound(x, fs);

X = fft(x);
log_x_squared = log(real(X).^2+imag(X).^2);

winsize = 256;
clear M
shift = 20;
c = 1;
h = hamming(256);
for i = 1:shift:length(x)-winsize
    Xwindowed = fft(x(i:i+winsize-1).*h, winsize);
    Lwindowed = log(real(Xwindowed).^2+imag(Xwindowed).^2);
    L(:,c) = Lwindowed;
    c = c + 1;
end
i = 1:length(x);
pcolor(L); shading('flat');
axis([1,size(L,2),1,128]);
xlabel('Time');
ylabel('Frequency Step');
%axis([1500 2000 1 128])

mn=min(min(L));
L=L-mn;

% find the max of L. Map L to a number between 0 and 128 (at first)
% and then subtract 50 (-50 to 78)
mx=max(max(L));
L=floor(L/mx*128)-50;
% map all numbers below 1 to 1, all numbers above 64 to 64
L(find(L<1))=1;
L(find(L>64))=64;


% 16,000 Sampling Frequency / 256 Bins = 62.5  Hz / Bin
freqPerBin = 62.5;
threshold = 480;
timeSteps = 50;
lowFreq = 300;
highFreq = 700;
lowIndex = floor(lowFreq/freqPerBin);
highIndex = floor(highFreq/freqPerBin);
bandRangeSum = sum(L(lowIndex:highIndex, :),1);

thresholdPass = bandRangeSum > threshold;
timeStepFilter = ones(1, timeSteps);

exSounds = strfind(thresholdPass, timeStepFilter);
if (isempty(exSounds))
    disp('Rex has not been called');
else
    fprintf('Rex was called at time step : %d\n', exSounds(1));
end