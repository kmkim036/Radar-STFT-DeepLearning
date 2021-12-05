%% Function
% save the part of cwt data figure of selected data into csv file

clear all;
clc;
close all;

% data measure date
date = 211130;

for person = 0:2

    for motion = 0:3
        dpm = sprintf('%d_%d_%d', date, person, motion);
        csv_file_name = sprintf('%s_cwt.csv', dpm);
        writematrix(['pixels'], csv_file_name);
        sum_cwt = [];
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
            
            % stft
            % N_FFT = 128;
            % Window = hamming(N_FFT);
            % SamplingFreq = 3e+3;
            % Overlap_Len = N_FFT / 2; % 50 % overlapping
            % stft_data = stft(RawData_DC_vector, SamplingFreq, 'Window', Window, 'OverlapLength', Overlap_Len, 'FFTLength', N_FFT);

            % cwt
            cwt_data = abs(cwt(abs(RawData_DC_vector), 'amor', 650));

            % need to fix crop part
            % "fix row_start and column_start value by motion"
            % extract time: 0.6s => 1920 * (0.6 / 3) = 384
            % extract frequency: 10000 / 384 = 26.04
            % => image size: 26 x 384

            % column_start = (start second / 3) * 1920
            % example: start second = 1.5 => column_start = (1.5 / 3) * 1920 = 960
            if motion == 0
                row_start = 1;
                column_start = 1280;
            elseif motion == 1
                row_start = 1;
                column_start = 1280;
            elseif motion == 2
                row_start = 1;
                column_start = 1280;
            elseif motion == 3
                row_start = 1;
                column_start = 1280;
            end

            cwt_data_crop = (cwt_data(row_start:row_start + 25, column_start:column_start + 383));
            reshape_crop = reshape(cwt_data_crop', 1, []); % 1행으로 쫙 펼침
            sum_cwt = [sum_cwt; reshape_crop]; % 다음 행에 추가

        end

        writematrix(ceil(sum_cwt), csv_file_name, 'Delimiter', 'space', 'WriteMode', 'append') % sum_cwt를 csv에 추가

    end

end
