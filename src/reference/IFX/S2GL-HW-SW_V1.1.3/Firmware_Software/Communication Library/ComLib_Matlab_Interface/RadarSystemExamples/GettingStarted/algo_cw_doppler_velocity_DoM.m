function [velocity, DoM, fft_spectrum_dBm] = algo_cw_doppler_velocity_DoM(I, Q, sampling_freq_hz)
% CW Doppler Radar algorithm returning velocity, direction of movement
% (DoA) and calculated FFT spectrum for single target (strongest one)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2014-2018, Infineon Technologies AG
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Date: 29.12.2017
%%% Author: Raghavendran, Santra, Finke
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Constants
c = 300000000; % speed of light in m/s
nr_samples = size(I, 1); % nr of samples per chirp

% DC Removal
I = I - mean(I);
Q = Q - mean(Q);

% Construct the complex data
data_complex = complex(I,Q);

% apply hanning window
w = hann(length(I));
dataWindowed = data_complex .*w;

% Complex Fourier Spectrum from -fs/2 to fs/2 with zero padding
% of factor 4 (fs = sampling frequency)
NFFT = nr_samples*2*4;
Y = fftshift(fft(dataWindowed,NFFT));

% calculate amplitude of FFT and convert spectrum to dBm
amp = abs(Y);
fft_spectrum_dBm = 20*log10(amp);

% Calculate target peak frequency
[peak,I] = max(amp);
f = sampling_freq_hz/2*linspace(-1,1,NFFT);
freq = f(I);

% calculate peak to average power ratio (PAPR) and use it as threshold for
% target detection
PAPR = max(fft_spectrum_dBm).^2/mean(fft_spectrum_dBm).^2;

% Doppler speed and direction o motion calculation
if PAPR < 3.5
    velocity = 0;
    DoM = 'Stationary';
else
    velocity = round((freq/2) * (c / 24e9), 2);
    if freq < 0
        DoM = 'Departing';
    else
        DoM = 'Approaching';
    end
end

end