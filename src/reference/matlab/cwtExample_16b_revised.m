% code which is revised by kmkim from cwtExample_16b.m

% need to install wavelet toolbox before
% youtube link: https://www.youtube.com/watch?v=GV34hKXDw_c

i = 1;

%Copyright 2016 The MathWorks, Inc.
%% Load a signal
load eqData;
figure(i);
i = i + 1;
plot(t, kobe);
grid on;
xlabel('Time (mins)');
ylabel('Vertical Acceleration nm/sq.sec');
title('Earthquake Signal');
axis tight

%% Time Frequency using Spectrogram.
%close all;
figure(i);
i = i + 1;
spectrogram(kobe, [], [], [], Fs, 'yaxis');

%% Spectrogram using shorter window
figure(i);
i = i + 1;
spectrogram(kobe, 128, [], [], Fs, 'yaxis');
title('Spectrogram using shorter window');

%% cwt
% To perform the Continuous Wavelet Transform, you can use the fucntion cwt. We provide the
% signal and the sampling frequency as an input arguments.
figure(i);
i = i + 1;
cwt(kobe, Fs); % default wavelet = morse wavelet
title('CWT with Morse wavelet');

% added by kmkim
figure(i);
i = i + 1;
cwt(kobe, 'bump', Fs); % bump wavelet
title('CWT with bump wavelet');

% added by kmkim
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
cwt(kobe, 'amor', Fs) % analytic Morlet wavelet
title('CWT with analytic Morlet wavelet');

%% Fine Scale Analysis
No = 8; % revise from 10 to 8 by kmkim due to error
Nv = 32;
figure(i);
i = i + 1;
cwt(kobe, Fs, 'NumOctaves', No, 'VoicesPerOctave', Nv);
title('CWT with Number of Octaves: 8 and Voices per Octave: 32');

%% Reconstruct the seismic signal
[WT, F] = cwt(kobe, Fs);
xrec = icwt(WT, F, [0.03 0.06], 'SignalMean', mean(kobe));
figure(i);
i = i + 1;
plot(t, xrec, 'b');
title('Reconstructed Seismic Signal');
axis tight;
grid on;

% END
