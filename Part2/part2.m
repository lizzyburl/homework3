% Homework 1
% Lizzy Burl, Ethan Hill, Jorge Chang, James Burgess

clear;



% 16,000 Hz means that 1 ms = 16 samples
% 25 ms = 400 samples
for soundFile = 1:9
    GetMFCC(sprintf('%da.wav',soundFile));
    GetMFCC(sprintf('%db.wav',soundFile));
end