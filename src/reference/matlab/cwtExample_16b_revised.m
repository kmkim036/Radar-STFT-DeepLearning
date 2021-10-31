% code which is revised by kmkim from cwtExample_16b.m

% need to install wavelet toolbox before
% youtube link: https://www.youtube.com/watch?v=GV34hKXDw_c

i = 1;

%Copyright 2016 The MathWorks, Inc.
%% Load a signal
load eqData.mat;
figure(i);
i = i + 1;
plot(t, kobe);
grid on;
xlabel('Time (mins)');
ylabel('Vertical Acceleration nm/sq.sec');
title('Earthquake Signal');
axis tight

%% Time Frequency using Spectrogram.
figure(i);
i = i + 1;
spectrogram(kobe, [], [], [], Fs, 'yaxis');

%% Spectrogram using shorter window
figure(i);
i = i + 1;
spectrogram(kobe, 128, [], [], Fs, 'yaxis');
title('Spectrogram using shorter window');

%% STFT
% DC removal
RawData_DC = kobe - mean(kobe);
% Vectoring
RawData_DC_vector = reshape(RawData_DC, numel(RawData_DC), 1);
% Parameter Load
N_FFT = 128;
Window = hamming(N_FFT);
SamplingFreq = 3e+3;
Overlap_Len = N_FFT / 2; % 50 % overlapping
% STFT
stft_data = stft(RawData_DC_vector, SamplingFreq, 'Window', Window, 'OverlapLength', Overlap_Len, 'FFTLength', N_FFT);
% Plot
figure(i);
imagesc(pow2db(abs(stft_data)));
colorbar;
title('STFT result');
i = i + 1;

%% cwt
% To perform the Continuous Wavelet Transform, you can use the fucntion cwt. We provide the
% signal and the sampling frequency as an input arguments.

%% cwt with morse wavelet
figure(i);
i = i + 1;
cwt(kobe, Fs); % default wavelet = morse wavelet
title('CWT with Morse wavelet');

figure(i);
i = i + 1;
cwt_data = cwt(kobe, Fs); % default wavelet = morse wavelet
imagesc(pow2db(abs(cwt_data)));
colorbar;
title('CWT with Morse wavelet, pow2db');

%% cwt with bump wavelet
figure(i);
i = i + 1;
cwt(kobe, 'bump', Fs); % bump wavelet
title('CWT with bump wavelet');

figure(i);
i = i + 1;
cwt_data = cwt(kobe, 'bump', Fs); % bump wavelet
imagesc(pow2db(abs(cwt_data)));
colorbar;
title('CWT with bump wavelet, pow2db');

%% cwt with morlet wavelet
figure(i);
i = i + 1;
% Set effective support and grid parameters.
lb =- 4;
ub = 4;
n = 1000;
% Compute and plot Morlet wavelet.
[psi, x] = morlet(lb, ub, n);
plot(x, psi), title('Morlet wavelet')

figure(i);
i = i + 1;
cwt(kobe, 'amor', Fs); % analytic Morlet wavelet
title('CWT with analytic Morlet wavelet');

figure(i);
i = i + 1;
cwt_data = cwt(kobe, 'amor', Fs); % analytic Morlet wavelet
imagesc(pow2db(abs(cwt_data)));
colorbar;
title('CWT with analytic Morlet wavelet, pow2db');

%% Fine Scale Analysis
% No = 8; % revise from 10 to 8 by kmkim due to error
% Nv = 32;
% figure(i);
% i = i + 1;
% cwt(kobe, Fs, 'NumOctaves', No, 'VoicesPerOctave', Nv);
% title('CWT with Number of Octaves: 8 and Voices per Octave: 32');

%% Reconstruct the seismic signal
% [WT, F] = cwt(kobe, Fs);
% xrec = icwt(WT, F, [0.03 0.06], 'SignalMean', mean(kobe));
% figure(i);
% i = i + 1;
% plot(t, xrec, 'b');
% title('Reconstructed Seismic Signal');
% axis tight;
% grid on;

% END
