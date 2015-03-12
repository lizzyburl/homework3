% Homework 1
% Lizzy Burl, Ethan Hill, Jorge Chang, James Burgess
% Part 2

clear;
    
lower = 30;
upper = 8000;
M = 24;

% 16,000 Hz means that 1 ms = 16 samples
% 25 ms = 400 samples
for soundFile = 1:9

    GetMFCC(sprintf('%da.wav',soundFile), lower, upper, M);
    GetMFCC(sprintf('%db.wav',soundFile), lower, upper, M);
    
end