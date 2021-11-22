%% by kmkim
% need to install wavelet toolbox before

%% close all ex-figures
close all;

%% index just for figure numbering
i = 1;

%% Load a raw radar signal data
% revise file name to load
load 211122_kkm_1_2_RE.mat;
load 211122_kkm_1_2_IM.mat;

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
i = i + 1;
imagesc(pow2db(abs(stft_data)));
colorbar;
title('STFT result');

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

% variable 'mode' to select input data
mode = 2;
% 1: abs before transform / DC not removed
% 2: abs before transform after DC removed

clims = [0 700];

if mode == 1
    input = abs(RawData);
    input_raw = RawData;
elseif mode == 2
    input = abs(RawData_DC_vector);
    input_raw = RawData_DC_vector;
end

% % morse wavelet
% cwt_data = cwt(input, Fs);
% figure(i);
% i = i + 1;
% subplot(2, 1, 1);
% imagesc(abs(cwt_data), clims);
% colorbar;
% title('CWT with morse wavelet');
% subplot(2, 1, 2);
% imagesc(pow2db(abs(cwt_data)));
% colorbar;
% title('CWT with morse wavelet with log scale');
% 
% % bump wavelet
% cwt_data = cwt(input, 'bump', Fs);
% figure(i);
% i = i + 1;
% subplot(2, 1, 1);
% imagesc(abs(cwt_data), clims);
% colorbar;
% title('CWT with bump wavelet');
% subplot(2, 1, 2);
% imagesc(pow2db(abs(cwt_data)));
% colorbar;
% title('CWT with bump wavelet with log scale');

% morlet wavelet
cwt_data = cwt(input, 'amor', Fs);
figure(i);
i = i + 1;
subplot(2, 1, 1);
imagesc(abs(cwt_data), clims);
colorbar;
title('CWT with morlet wavelet');
subplot(2, 1, 2);
imagesc(pow2db(abs(cwt_data)));
colorbar;
title('CWT with morlet wavelet with log scale');

%% complex positive, negative
% cwt_data_0 = cwt(input_raw, 'amor', Fs);
% cwt_data_1 = cwt_data_0(:,:,1);
% cwt_data_2 = cwt_data_0(:,:,2);
% cwt_data_3 = cwt_data_1 + cwt_data_2;
% cwt_data_4 = abs(cwt_data_1) + abs(cwt_data_2);
% 
% figure(i);
% i = i + 1;
% subplot(2, 1, 1);
% imagesc(abs(cwt_data_1));
% colorbar;
% title('positive component with morlet wavelet');
% subplot(2, 1, 2);
% imagesc(pow2db(abs(cwt_data_1)));
% colorbar;
% title('positive component with morlet wavelet, log scale');
% 
% figure(i);
% i = i + 1;
% subplot(2, 1, 1);
% imagesc(abs(cwt_data_2));
% colorbar;
% title('negative component with morlet wavelet');
% subplot(2, 1, 2);
% imagesc(pow2db(abs(cwt_data_2)));
% colorbar;
% title('negative component with morlet wavelet, log scale');
%
% figure(i);
% i = i + 1;
% subplot(2, 1, 1);
% imagesc(abs(cwt_data_3));
% colorbar;
% title('abs(pos + neg) with morlet wavelet');
% subplot(2, 1, 2);
% imagesc(pow2db(abs(cwt_data_3)));
% colorbar;
% title('abs(pos + neg) with morlet wavelet, log scale');
%
% figure(i);
% i = i + 1;
% subplot(2, 1, 1);
% imagesc(cwt_data_4);
% colorbar;
% title('abs(pos) + abs(neg) with morlet wavelet');
% subplot(2, 1, 2);
% imagesc(pow2db(cwt_data_4));
% colorbar;
% title('abs(pos) + abs(neg) with morlet wavelet, log scale');

%% real, imaginary respectively
% % cwt with morse wavelet
% figure(i);
% i = i + 1;
% cwt_data = cwt(dataRE, Fs); % default wavelet = morse wavelet
% imagesc(pow2db(abs(cwt_data)));
% colorbar;
% title('CWT with Morse wavelet Real Part');
%
% figure(i);
% i = i + 1;
% cwt_data = cwt(dataIM, Fs); % default wavelet = morse wavelet
% imagesc(pow2db(abs(cwt_data)));
% colorbar;
% title('CWT with Morse wavelet Imaginary Part');
%
% % cwt with bump wavelet
% figure(i);
% i = i + 1;
% cwt_data = cwt(dataRE, 'bump', Fs); % bump wavelet
% imagesc(pow2db(abs(cwt_data)));
% colorbar;
% title('CWT with bump wavelet Real Part');
%
% figure(i);
% i = i + 1;
% cwt_data = cwt(dataIM, 'bump', Fs); % bump wavelet
% imagesc(pow2db(abs(cwt_data)));
% colorbar;
% title('CWT with bump wavelet Imaginary Part');
%
% % cwt with analytic morlet wavelet
% figure(i);
% i = i + 1;
% cwt_data = cwt(dataRE, 'amor', Fs); % analytic Morlet wavelet
% imagesc(pow2db(abs(cwt_data)));
% colorbar;
% title('CWT with analytic Morlet wavelet Real Part');
%
% figure(i);
% i = i + 1;
% cwt_data = cwt(dataIM, 'amor', Fs); % analytic Morlet wavelet
% imagesc(pow2db(abs(cwt_data)));
% colorbar;
% title('CWT with analytic Morlet wavelet Imaginary Part');

%% compare cwt data of real, imagenary with complex
% figure(i);
% i = i + 1;
% subplot(2, 1, 1);
% imagesc(abs(cwt(dataRE, 'amor', Fs)));
% colorbar();
% title('Real');
% subplot(2, 1, 2);
% imagesc(abs(cwt(dataIM, 'amor', Fs)));
% colorbar();
% title('Imaginary');
%
% figure(i);
% i = i + 1;
% cwt(RawData,'amor', Fs);

%% EOF
