clc
close all
clear all

% Data:
filename = 'Speech_sample.wav';          % name of input file
delay_dispersion = 0.0155;               % this defines the amount of reverberation
max_delay = delay_dispersion * 4;        % this should be several times the delay dispersion
num_delays = 1000;                       % number of echoes. Should be large for realistic reverberation

% Processing:
[x, fs] = audioread(filename);                              % read file
N = length(x);
t = 1:1/fs:11;
delays = round(rand(1,num_delays) * max_delay * fs);
amplitudes = exp(-delays / delay_dispersion / fs);                                                  % exponential profile
stem(delays, amplitudes), title('Impulse response'), xlabel('Delay'), ylabel('Amplitude')           % plot impulse response
amplitudes = 0.7 * amplitudes + 0.3 * rand(size(amplitudes));                                       % add some randomness in amplitudes
delays = [1 delays];                                            % add clean sound...
amplitudes = [1 amplitudes];                                    % ...with unit amplitude
h = zeros(1, ceil(max_delay * fs));
h(delays) = amplitudes;
y = conv2(x, h(:));                      % use conv2 so that it works for mono or stereo x
clc
disp('Playing original audio');
soundsc(x, fs)                           % play dry sound
pause(15)
disp('Playing reverberated audio');
soundsc(y, fs)                           % play reverberated sound

X = fft(x); 
Y = fft(y);

k = 1 : N;

figure,         % Input and output audio signal
subplot(2,1,1), plot(t(1:20000), x(1:20000)), title('Input audio signal'), xlabel('t'), ylabel('Input audio amplitude')
subplot(2,1,2), plot(t(1:20000), y(1:20000)), title('Reverberated audio signal'), xlabel('t'), ylabel('Output audio amplitude')

figure,          % Magnitude & Phase of input and output
subplot(2,2,1), plot(k(1:1000), mag2db(abs(X(1:1000)))), title('Magnitude of I/p audio'), xlabel('k'), ylabel('FFT Magnitude of I/p audio (|X|)')
subplot(2,2,2), plot(k(1:1000), angle(X(1:1000))), title('Phase of I/p audio'), xlabel('k'), ylabel('Phase of I/p audio (∠X)')
subplot(2,2,3), plot(k(1:1000), mag2db(abs(Y(1:1000)))), title('Magnitude of reverberated audio'), xlabel('k'), ylabel('FFT Magnitude of reverberated audio (|Y|)')
subplot(2,2,4), plot(k(1:1000), angle(Y(1:1000))), title('Phase of reverberated audio'), xlabel('k'), ylabel('Phase of reverberated audio (∠Y)')

figure,          % Magnitude plot of input and output
subplot(2,1,1), plot(mag2db(abs(X(1:20000)))), title('Magnitude of Input audio'), xlabel('k'), ylabel('FFT Magnitude of I/p audio (|X|)')
subplot(2,1,2), plot(mag2db(abs(Y(1:20000)))), title('Magnitude of reverberated audio'), xlabel('k'), ylabel('FFT Magnitude of reverberated audio (|Y|)')
