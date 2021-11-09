%% by kmkim
% need to install wavelet toolbox before

%% index just for figure numbering
i = 1;

%% Load a raw radar signal data
% revise file name to load
load 211029_3_2_RE.mat;
load 211029_3_2_IM.mat;

%% signal processing and plot stft (by SoC Lab code)
% make into complex raw data
RawData = complex(dataRE, dataIM);
% DC removal
RawData_DC = RawData - mean(RawData);
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

%% plot raw signal data by real and imagenary
% figure(i);
% i = i + 1;
% plot(t, dataRE);
% grid on;
% xlabel('Time (secs)');
% ylabel('Raw Data');
% title('Radar Signal RE')
% axis tight
%
% figure(i);
% i = i + 1;
% plot(t, dataIM);
% grid on;
% xlabel('Time (secs)');
% ylabel('Raw Data');
% title('Radar Signal IM')
% axis tight

%% cwt
% To perform the Continuous Wavelet Transform, you can use the fucntion cwt. We provide the
% signal and the sampling frequency as an input arguments.

%% cwt with morse wavelet
figure(i);
i = i + 1;
cwt_data = cwt(dataRE, Fs); % default wavelet = morse wavelet
imagesc(pow2db(abs(cwt_data)));
colorbar;
title('CWT with Morse wavelet Real Part');

figure(i);
i = i + 1;
cwt_data = cwt(dataIM, Fs); % default wavelet = morse wavelet
imagesc(pow2db(abs(cwt_data)));
colorbar;
title('CWT with Morse wavelet Imaginary Part');

%% cwt with bump wavelet
figure(i);
i = i + 1;
cwt_data = cwt(dataRE, 'bump', Fs); % bump wavelet
imagesc(pow2db(abs(cwt_data)));
colorbar;
title('CWT with bump wavelet Real Part');

figure(i);
i = i + 1;
cwt_data = cwt(dataIM, 'bump', Fs); % bump wavelet
imagesc(pow2db(abs(cwt_data)));
colorbar;
title('CWT with bump wavelet Imaginary Part');

%% cwt with analytic morlet wavelet
figure(i);
i = i + 1;
cwt_data = cwt(dataRE, 'amor', Fs); % analytic Morlet wavelet
imagesc(pow2db(abs(cwt_data)));
colorbar;
title('CWT with analytic Morlet wavelet Real Part');

figure(i);
i = i + 1;
cwt_data = cwt(dataIM, 'amor', Fs); % analytic Morlet wavelet
imagesc(pow2db(abs(cwt_data)));
colorbar;
title('CWT with analytic Morlet wavelet Imaginary Part');

%% compare cwt data of real, imagenary with complex
% Rawdata = complex(dataRE, dataIM);
% figure(i);
% cwt(dataRE, Fs);
% title('real');
% i = i + 1;
% figure(i);
% cwt(dataIM, Fs);
% title('im');
% i=i+1;
% figure(i);
% cwt(Rawdata,Fs);
% i = i+1;

% Result
% positive component = left half side of real part
% negative component = right half side of imagenary part

%% compare cwt data of DC removal and vectoring with normal one
% figure(i);
% i = i + 1;
% cwt_data = cwt(dataRE, 'amor', Fs); % analytic Morlet wavelet
% imagesc(pow2db(abs(cwt_data)));
% colorbar;
% title('CWT with analytic Morlet wavelet RE');
%
% dataRE = dataRE - mean(dataRE); % DC removal
% dataRE_DC_vector = reshape(dataRE, numel(dataRE), 1); % Vectoring
%
% figure(i);
% i = i + 1;
% cwt_data = cwt(dataRE_DC_vector, 'amor', Fs); % analytic Morlet wavelet
% imagesc(pow2db(abs(cwt_data)));
% colorbar;
% title('CWT with analytic Morlet wavelet RE DC vector');

% Result
% no difference

%% EOF
