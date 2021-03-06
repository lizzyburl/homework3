% Homework 1
% Lizzy Burl, Ethan Hill, Jorge Chang, James Burgess

%% Part 1: Building Your Own Spectrogram
% 16,000 Sampling Frequency / 256 Bins = 62.5  Hz / Bin
clear;

% These are the parameters.
freqPerBin = 62.5;
threshold = 325;
timeSteps = 45;
lowFreq = 455;
highFreq = 755;
lowIndex = floor(lowFreq/freqPerBin);
highIndex = floor(highFreq/freqPerBin);

for soundFile = 1:10
    [x, fs, nbits] = wavread(sprintf('rex%d.wav',soundFile));
    sound(x, fs);

    X = fft(x);
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
   % i = 1:length(x);
    subplot(5,2, soundFile);
    pcolor(L); shading('flat');
    axis([1,size(L,2),1,40]); %128]);
    xlabel('Time');
    ylabel('Frequency Step');

    mn=min(min(L));
    L=L-mn;

    % find the max of L. Map L to a number between 0 and 128 (at first)
    % and then subtract 50 (-50 to 78)
    mx=max(max(L));
    L=floor(L/mx*128)-50;
    % map all numbers below 1 to 1, all numbers above 64 to 64
    L(find(L<1))=1;
    L(find(L>64))=64;

    % bandRangeSum = Creates a column sum vector in our band frequencies
    % for each timestep
    bandRangeSum = sum(L(lowIndex:highIndex, :),1);
    % Thresholding - Each sum should be greater than said threshold
    thresholdPass = bandRangeSum > threshold;
    % We are making a vector of the length of consecutive timesteps that we
    % want to hear the 'ex' sound in a row (length timeSteps).
    % exSounds represents the locations that these vectors are found. For
    % the most part, exSounds will have a handful of results that are one
    % next to each other if the 'ex' sound was made for more time steps in
    % a row than 'timeSteps.' Therefore, we will just choose the first one.
    timeStepFilter = ones(1, timeSteps);
    exSounds = strfind(thresholdPass, timeStepFilter);
 
    if (isempty(exSounds))
        title(sprintf('% d : Rex has not been called', soundFile));
    else
        title(sprintf('% d : Rex was called at time step : %d\n', soundFile, exSounds(1)));
        line([exSounds(1) exSounds(1)], [lowIndex highIndex], 'LineWidth', 1, 'Color', 'k');
        line([exSounds(1)+timeSteps, exSounds(1)+timeSteps], [lowIndex highIndex], 'LineWidth', 1, 'Color', 'k');
        line([exSounds(1) exSounds(1)+timeSteps], [lowIndex lowIndex], 'LineWidth', 1, 'Color', 'k');
        line([exSounds(1), exSounds(1)+timeSteps], [highIndex highIndex], 'LineWidth', 1, 'Color', 'k');
    end
    clear x X L Lwindowed Xwindowed fs nbits 
end