% Homework 1
% Lizzy Burl, Ethan Hill, Jorge Chang, James Burgess

%% Part 1: Building Your Own Spectrogram

[x, fs, nbits] = wavread('rex7.wav');
plot(x);
sound(x, fs);

X = fft(x);
log_x_squared = log(real(X).^2+imag(X).^2);

winsize = 256;
clear M
shift = 20
c = 1
h = hamming(256);
for i = 1:shift:length(x)-winsize
    Xwindowed = fft(x(i:i+winsize-1).*h, winsize);
    Lwindowed = log(real(Xwindowed).^2+imag(Xwindowed).^2);
    M(:,c) = Lwindowed;
    c = c + 1;
end
i = 1:length(x)
pcolor(M); shading('flat');
axis([1,size(M,2),1,128]);
xlabel('Time');
ylabel('Frequency');
%axis([1500 2000 1 128])

mn=min(min(M));
M=M-mn;

% find the max of L. Map L to a number between 0 and 128 (at first)
% and then subtract 50 (-50 to 78)
mx=max(max(M));
M=floor(M/mx*128)-50;
% map all numbers below 1 to 1, all numbers above 64 to 64
M(find(M<1))=1;
M(find(M>64))=64;

