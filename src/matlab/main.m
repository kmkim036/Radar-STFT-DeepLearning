%% Function
% save stft figure and cwt figure of selected data
% extract cwt data and save into csv file

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

        for i = 1:round % 파일 개수 만큼 설정하면 됨, %d에 i가 입력됨
            file_name = sprintf("%s_%d", dpm, i);
            a = load(sprintf('%s_RE.txt', file_name));
            b = load(sprintf('%s_IM.txt', file_name));

            RawData = complex(a, b);
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

            figure;
            cwt(abs(RawData_DC_vector), 'amor', 650);
            title('CWT with morlet wavelet');
            saveas(gcf, sprintf('%s_cwt.png', file_name));

            % need to revise crop part
            cwt_data = abs(cwt(abs(RawData_DC_vector), 'amor', 650));
            max_value = max(cwt_data, [], 'all');
            [k, j] = find(cwt_data == max_value);

            if j > (1920 - 110)
                cwt_data_crop = (cwt_data(1:45, j - 221:j));
            else
                cwt_data_crop = (cwt_data(1:45, j - 111:j + 110));
            end

            reshape_crop = reshape(cwt_data_crop', 1, []); % 1행으로 쫙 펼침
            sum_cwt = [sum_cwt; reshape_crop]; % 다음 행에 추가
        end

        writematrix(round(sum_cwt, 0), csv_file_name, 'Delimiter', 'space', 'WriteMode', 'append') % sum_cwt를 csv에 추가
    end

end
