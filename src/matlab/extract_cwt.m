clear all;
clc;
close all;
SamplingFreq = 800;
writematrix(['pixels'], "cwt_crop.csv");
sum_cwt = [];

for i = 1:3 % 파일 개수 만큼 설정하면 됨, %d에 i가 입력됨
    a = load(sprintf('211118_kkm_1_%d_IM.txt', i));
    b = load(sprintf('211118_kkm_1_%d_RE.txt', i));
    RawData = complex(a, b);
    RawData_DC = RawData - mean(RawData);
    RawData_DC_vector = reshape(RawData_DC, numel(RawData_DC), 1);
    cwt_data = cwt(abs(RawData_DC_vector), 'amor', SamplingFreq);
    cwt_data_crop = abs(cwt_data(30:49, 300:399)); % 자를 부분 설정
    reshape_crop = reshape(cwt_data_crop', 1, []); % 1행으로 쫙 펼침
    sum_cwt = [sum_cwt; reshape_crop]; % 다음 행에 추가
end

writematrix(round(sum_cwt, 0), "cwt_crop.csv", 'Delimiter', 'space', 'WriteMode', 'append') % sum_cwt를 csv에 추가
