% orignal code from MATLAB

%Copyright 2016 The MathWorks, Inc.
%% Load a signal 
load eqData; figure;
plot(t,kobe);grid on; 
xlabel('Time (mins)');ylabel('Vertical Acceleration nm/sq.sec');
title('Earthquake Signal');axis tight

%% Time Frequency using Spectrogram. 
close all;
figure;
spectrogram(kobe,[],[],[],Fs,'yaxis');

%% Spectrogram using shorter window
figure; 
spectrogram(kobe,128,[],[],Fs,'yaxis'); title('Spectrogram using shorter window');

%% cwt
% To perform the Continuous Wavelet Transform, you can use the fucntion cwt. We provide the 
% signal and the sampling frequency as an input arguments. 
figure;
cwt(kobe,Fs);

%% Fine Scale Analysis
No = 10;
Nv = 32;
figure;
cwt(kobe,Fs, 'NumOctaves' ,No,'VoicesPerOctave',Nv); 
title('CWT with Number of Octaves: 10 and Voices per Octave: 32');
%% Reconstruct the seismic signal 
[WT, F] = cwt(kobe,Fs);
xrec = icwt(WT, F, [0.03 0.06],'SignalMean',mean(kobe));
figure;
plot(t,xrec,'b');title('Reconstructed Seismic Signal'); axis tight;grid on;

% END 
