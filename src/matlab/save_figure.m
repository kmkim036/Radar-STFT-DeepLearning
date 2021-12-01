%% Function
% save stft figure and cwt figure of selected data

clear all;
clc;
close all;

% data measure date
date = 211130;

for person = 0:2

    for motion = 0:3
        dpm = sprintf('%d_%d_%d', date, person, motion);
        % need to revise round counts for motion
        if motion < 2
            round = 30;
        else
            round = 10;
        end

        for i = 1:round
            file_name = sprintf('%s_%d', dpm, i);
            dataRE = load(sprintf('%s_RE.txt', file_name));
            dataIM = load(sprintf('%s_IM.txt', file_name));

            RawData = complex(dataRE, dataIM);
            RawData_DC = RawData - mean(RawData);
            RawData_DC_vector = reshape(RawData_DC, numel(RawData_DC), 1);

            N_FFT = 128;
            Window = hamming(N_FFT);
            SamplingFreq = 3e+3;
            Overlap_Len = N_FFT / 2; % 50 % overlapping
            stft_data = stft(RawData_DC_vector, SamplingFreq, 'Window', Window, 'OverlapLength', Overlap_Len, 'FFTLength', N_FFT);

            figure;
            imagesc(pow2db(abs(stft_data)));
            colorbar;
            title('STFT result');
            saveas(gcf, sprintf('%s_stft.png', file_name));
            close;

            figure;
            cwt(abs(RawData_DC_vector), 'amor', 650);
            title('CWT with morlet wavelet');
            saveas(gcf, sprintf('%s_cwt.png', file_name));
            close;

        end

    end

end
