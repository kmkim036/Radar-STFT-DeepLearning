%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function out = extract_raw_data (in)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright (c) 2014-2019, Infineon Technologies AG
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification,are permitted provided that the
% following conditions are met:
%
% Redistributions of source code must retain the above copyright notice, this list of conditions and the following
% disclaimer.
%
% Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
% disclaimer in the documentation and/or other materials provided with the distribution.
%
% Neither the name of the copyright holders nor the names of its contributors may be used to endorse or promote
% products derived from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE  FOR ANY DIRECT, INDIRECT, INCIDENTAL,
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
% WHETHER IN CONTRACT, STRICT LIABILITY,OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION:
% This simple example demos the acquisition of data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% cleanup and init
% Before starting any kind of device the workspace must be cleared and the
% Matlab Interface must be included into the code. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
disp('******************************************************************');
addpath('..\..\RadarSystemImplementation'); % add Matlab API
clear all %#ok<CLSCR>
close all
resetRS; % close and delete ports

% Configuration: Change to you needs
serialPortName = 'COM20';   % Input the serial port name which is shown in device manager

% Constants: Do not change unless this value is also changed in FW
sampling_freq_hz = 3000;

% Open connection to the device
serialPortHandle = radar_open_device(serialPortName);
disp('Connected RadarSystem:');

time_cnt = 1;
TIME = 150; % 총 추출 횟수
% tic
% Getting raw data
while true
    % Trigger radar chirp and get the raw data of single chirp
    
    [I, Q] = radar_get_frame(serialPortHandle);   
    
    % Raw Data 추출 과정
    if(time_cnt <= TIME)
        if time_cnt == 1
            dump_I = I;
            dump_Q = Q;
        else
            dump_I = [dump_I, I];
            dump_Q = [dump_Q, Q];
        end        
    else
        break; % 총 누적 횟수를 채우면 while문을 빠져나옴
    end        
    time_cnt = time_cnt + 1;
    
%     ydata = complex(I,Q);
%     disp(ydata);
end;
% toc
% Close connection to the device
radar_close_device(serialPortHandle);

%% File Out
filename = 'TEST3'; % 파일명 변경!

dump_I_vector = reshape(dump_I, numel(dump_I), 1);
dump_Q_vector = reshape(dump_Q, numel(dump_Q), 1);

dlmwrite(['DATA\',filename,'_RE.txt'], dump_I_vector(:), 'delimiter', '', 'newline', 'pc');
dlmwrite(['DATA\',filename,'_IM.txt'], dump_Q_vector(:), 'delimiter', '', 'newline', 'pc');

% 
% RawData = complex(dump_I, dump_Q);
% % DC removal
% RawData_DC = RawData - mean(RawData);
% % Vectoring
% RawData_DC_vector = reshape(RawData_DC, numel(RawData_DC), 1);
% % Parameter Load
% N_FFT = 128;
% Window = hamming(N_FFT);
% SamplingFreq = 3e+3;
% Overlap_Len = N_FFT/2; % 50% overlapping
% % STFT
% stft_data = stft(RawData_DC_vector, SamplingFreq, 'Window', Window, 'OverlapLength', Overlap_Len, 'FFTLength', N_FFT);
% % Plot
% figure; imagesc(pow2db(abs(stft_data))); colorbar;























