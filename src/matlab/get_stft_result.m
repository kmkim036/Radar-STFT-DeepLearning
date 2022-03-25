%% Function
% to compare MATLAB stft raw data with python stft raw data
% check variables named 'stft_data' or 'stft_data_abs'

%% close all ex-figures
close all;

%% index just for figure numbering
i = 1;

%% Load a raw radar signal data
% revise file name to load
dataRE = load('220128_1_2_45_RE.txt');
dataIM = load('220128_1_2_45_IM.txt');

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
SamplingFreq = 650;
Overlap_Len = N_FFT / 2; % 50 % overlapping

% STFT
figure(i);
i = i + 1;
stft(RawData_DC_vector, SamplingFreq, 'Window', Window, 'OverlapLength', Overlap_Len, 'FFTLength', N_FFT);
title('STFT raw data');

figure(i);
i = i + 1;
stft_data = stft(RawData_DC_vector, SamplingFreq, 'Window', Window, 'OverlapLength', Overlap_Len, 'FFTLength', N_FFT);
imagesc(pow2db((abs(stft_data))));
colorbar;
title('STFT result with DB scale');
stft_data_abs = abs(stft_data);

%% EOF
