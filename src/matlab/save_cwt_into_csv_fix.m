%% Function
% save the part of cwt data figure of selected data into csv file

clear all;
clc;
close all;

% data measure date
date = 220110;
index = 20;

for person = 0:2

    for motion = 0:3
        dpm = sprintf('%d_%d_%d', date, person, motion);

        % cwt
        csv_file_name = sprintf('%s_cwt_%d.csv', dpm, index);
        % csv_file_name = sprintf('%s_cwt_%d_40.csv', dpm, index);

        % stft
        % csv_file_name = sprintf('%s_stft.csv', dpm);

        writematrix(['pixels'], csv_file_name);
        sum_cwt = [];
        round = 50;

        for i = 1:round
            file_name = sprintf('%s_%d', dpm, i);
            dataRE = load(sprintf('%s_RE.txt', file_name));
            dataIM = load(sprintf('%s_IM.txt', file_name));

            RawData = complex(dataRE, dataIM);
            RawData_DC = RawData - mean(RawData);
            RawData_DC_vector = reshape(RawData_DC, numel(RawData_DC), 1);

            % cwt
            cwt_data = abs(cwt(abs(RawData_DC_vector), 'amor', 650));
            ext_data = zeros(81, 1920 / index);

            for ii = 1:81

                for jj = 1:(1920 / index)
                    ext_data(ii, jj) = cwt_data(ii, index * jj);
                end

            end

            reshape_crop = reshape(ext_data', 1, []);

            % crop from ext
            % cwt_data_crop = abs(ext_data(1:40, 40:99));
            % reshape_crop = reshape(cwt_data_crop', 1, []); % 1행으로 쫙 펼침

            % stft
            % N_FFT = 128;
            % Window = hamming(N_FFT);
            % SamplingFreq = 3e+3;
            % Overlap_Len = N_FFT / 2; % 50 % overlapping
            % stft_data = stft(RawData_DC_vector, SamplingFreq, 'Window', Window, 'OverlapLength', Overlap_Len, 'FFTLength', N_FFT);
            % reshape_crop = reshape(abs(stft_data)', 1, []); % 1행으로 쫙 펼침

            sum_cwt = [sum_cwt; reshape_crop]; % 다음 행에 추가

        end

        writematrix(ceil(sum_cwt), csv_file_name, 'Delimiter', 'space', 'WriteMode', 'append') % sum_cwt를 csv에 추가

    end

end
