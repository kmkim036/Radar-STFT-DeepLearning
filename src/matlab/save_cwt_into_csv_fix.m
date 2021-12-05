%% Function
% save the part of cwt data figure of selected data into csv file

clear all;
clc;
close all;

% data measure date
date = 211130;
index = 16;

for person = 0:2

    for motion = 0:3
        dpm = sprintf('%d_%d_%d', date, person, motion);
        csv_file_name = sprintf('%s_cwt_%d_40.csv', dpm, index);
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
        
            cwt_data = abs(cwt(abs(RawData_DC_vector), 'amor', 650));
            
            ext_data = zeros(81, 1920 / index);
            for ii=1:81
                for jj = 1:(1920/index)
                    ext_data(ii,jj)=cwt_data(ii,index*jj);
                end
            end    
            
            % need to fix crop part
            % "fix row_start and column_start value by motion"
            % extract time: 0.6s => 1920 * (0.6 / 3) = 384
            % extract frequency: 10000 / 384 = 26.04
            % => image size: 26 x 384

            % column_start = (start second / 3) * 1920
            % example: start second = 1.5 => column_start = (1.5 / 3) * 1920 = 960
            
            % cwt_data_crop = abs(cwt_data(1:39,40:80));
            %  cwt_data_crop = abs(red_data(1:40,80:159));
            % reshape_crop = reshape(cwt_data_crop', 1, []); % 1행으로 쫙 펼침
            
            % reshape_crop = reshape(ext_data', 1, []);

            red_data = ext_data(1:40,40:80);
            reshape_crop = reshape(red_data', 1, []); % 1행으로 쫙 펼침  
            sum_cwt = [sum_cwt; reshape_crop]; % 다음 행에 추가

        end

        writematrix(ceil(sum_cwt), csv_file_name, 'Delimiter', 'space', 'WriteMode', 'append') % sum_cwt를 csv에 추가

    end

end
