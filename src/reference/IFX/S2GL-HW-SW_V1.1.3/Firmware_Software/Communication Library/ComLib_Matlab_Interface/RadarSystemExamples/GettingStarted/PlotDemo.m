%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function out = PlotDemo (in)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright (c) 2014-2017, Infineon Technologies AG
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
% This simple example demos the usage of the Matlab Sensing Interface by 
% configuring the chip and acquiring raw then executing CW Doppler Radar 
% algorithm to get velocity and direction of motion (DoM) of a single target.
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
serialPortName = 'COM6';   % Input the serial port name which is shown in device manager

% Constants: Do not change unless this value is also changed in FW
sampling_freq_hz = 3000;

% Open connection to the device
serialPortHandle = radar_open_device(serialPortName);

% Algorithm processing
% Execute CW Doppler Radar algorithm and plot time and frequency domain plot,
% then demonstrate velocity and direction of motion (DoM) of a single 
%(strongest) target using complex (I & Q).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hTime = figure;
while ishandle(hTime)
    % get raw data of single chirp
    [I, Q] = radar_get_frame(serialPortHandle);
   
    % calculate Doppler speed and DoM for strongest target
    [velocity, DoM, fft_spectrum] = algo_cw_doppler_velocity_DoM ...
        (I, Q, sampling_freq_hz);
    
    clf % Clears the current figure handle
    
    % time domain plot
    subplot(2,1,1)
    plot(1:length(I),I.','r',1:length(Q),Q.','b')
%     axis tight
    ylim([0,4095])
    grid on
    legend('I data','Q data')
    title('Reflected Time domain data')
    
    % frequency domain plot
    subplot(2,1,2)
    f = sampling_freq_hz/2*linspace(-1,1,size(fft_spectrum,1));
    plot(f,fft_spectrum)
    if velocity == 0
        xlabel('Target stationary', 'fontweight','bold','fontsize',20);
    else
        xlabel(['Target ', DoM, '. Velocity = ', num2str(abs(velocity)), ...
            ' m/s.'], 'fontweight','bold','fontsize', 20);
    end
    title('Reflected Frequency domain data')
    grid on
    drawnow
end

% Close connection to the device
radar_close_device(serialPortHandle);
