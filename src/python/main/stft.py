import math
import numpy as np
from scipy import signal

# RPI4
# from scipy.fftpack import fftshift
# PC
from scipy.fft import fftshift

# fft parameter
N_FFT_point = 128
SamplingFreq = 650
fft_window = signal.windows.hamming(128)


def stft_crop(I_raw_data, Q_raw_data):
    # make complex input with I-data, Q-data and remove DC component
    complex_raw_data = []
    for i in range(0, 1920):
        complex_raw_data.append(
            complex(I_raw_data[i], Q_raw_data[i]))
    complex_raw_data_DC = complex_raw_data - np.mean(complex_raw_data)

    # stft
    f, t, Zxx = signal.stft(x=complex_raw_data_DC, fs=SamplingFreq, window=fft_window,
                            nperseg=N_FFT_point, nfft=N_FFT_point, noverlap=N_FFT_point//2, boundary=None)

    # fftshift
    Zxx = fftshift(abs(Zxx), axes=0)

    # crop image into 36x28 from 128x29
    Zxx = Zxx[46:82, 1:29]

    # make fft result into integer from float
    for i in range(36):
        for j in range(28):
            Zxx[i][j] = math.ceil(abs(Zxx[i][j]))

    return Zxx
