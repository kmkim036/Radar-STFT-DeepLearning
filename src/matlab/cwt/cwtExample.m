% by kmkim
% need to install wavelet toolbox before

% index just for figure numbering
i = 1;

%% Load a raw radar signal data
load 211029_1_1_RE.mat;
load 211029_1_1_IM.mat;

%data = complex(dataRE, dataIM);
%data = data - mean(data);
%data_vector = reshape(data, numel(data), 1);

figure(i);
i = i + 1;
plot(t, dataRE);

grid on;
xlabel('Time (secs)');
ylabel('Raw Data');
title('Radar Signal')
axis tight

figure(i);
i = i + 1;
plot(t, dataIM);

grid on;
xlabel('Time (secs)');
ylabel('Raw Data');
title('Radar Signal')
axis tight

%% Time Frequency using Spectrogram.
figure(i);
i = i + 1;
spectrogram(dataRE, [], [], [], Fs, 'yaxis');

%% Spectrogram using shorter window
figure(i);
i = i + 1;
spectrogram(dataRE, 128, [], [], Fs, 'yaxis');
title('Spectrogram using shorter window');

%% cwt
% To perform the Continuous Wavelet Transform, you can use the fucntion cwt. We provide the
% signal and the sampling frequency as an input arguments.
figure(i);
i = i + 1;
cwt(dataRE, Fs); % default wavelet = morse wavelet
title('CWT with Morse wavelet');

figure(i);
i = i + 1;
cwt(dataRE, 'bump', Fs); % bump wavelet
title('CWT with bump wavelet RE');

figure(i);
i = i + 1;
cwt(dataIM, 'bump', Fs); % bump wavelet
title('CWT with bump wavelet IM');

figure(i);
i = i + 1;
cwt(dataRE, 'amor', Fs) % analytic Morlet wavelet
title('CWT with analytic Morlet wavelet');

figure(i);
i = i + 1;
% Set effective support and grid parameters.
lb =- 4;
ub = 4;
n = 1000;
% Compute and plot Morlet wavelet.
[psi, x] = morlet(lb, ub, n);
plot(x, psi), title('Morlet wavelet')

% END
