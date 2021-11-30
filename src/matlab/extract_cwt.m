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

            cwt_data = cwt(abs(RawData_DC_vector), 'amor', 650);

            % need to revise crop part
            cwt_data_crop = abs(cwt_data(30:49, 300:399)); % 자를 부분 설정
            reshape_crop = reshape(cwt_data_crop', 1, []); % 1행으로 쫙 펼침
            sum_cwt = [sum_cwt; reshape_crop]; % 다음 행에 추가

        end

        writematrix(round(sum_cwt, 0), csv_file_name, 'Delimiter', 'space', 'WriteMode', 'append') % sum_cwt를 csv에 추가

    end

end
