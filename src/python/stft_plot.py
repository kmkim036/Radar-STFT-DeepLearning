import numpy as np
import pandas as pd
from scipy import signal
import matplotlib.pyplot as plt
from scipy.fft import fftshift
import math

def crop_image(image):
    # crop image into 36 x 28 size from 128 x 29
    crop_image = image[46:82, 1:29]
    return crop_image

# need to change directory or file name for image
date = 220221
human = 1
motion = 3
index = 3
# need to change directory path for own PC
DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-STFT-DeepLearning/data/' + str(date) + '/'

IM_raw_data = []
RE_raw_data = []


IM_file_name = str(date) + '_' + str(human) + '_' + str(motion) + '_' + str(index) + '_IM.txt'
RE_file_name = str(date) + '_' + str(human) + '_' + str(motion) + '_' + str(index) + '_RE.txt'

f = open(DirectoryPath + IM_file_name)
while True:
    line = f.readline()
    if not line:
        break
    line = line.replace('\n', '')
    IM_raw_data.append(int(line))
f.close()

f = open(DirectoryPath + RE_file_name)
while True:
    line = f.readline()
    if not line:
        break
    line = line.replace('\n', '')
    RE_raw_data.append(int(line))
f.close()

# make complex input
complex_raw_data = []
for i in range(0, 1920):
    complex_raw_data.append(
        complex(RE_raw_data[i], IM_raw_data[i]))
complex_raw_data_DC = complex_raw_data - np.mean(complex_raw_data)

# fft setting and executing
N_FFT_point = 128
SamplingFreq = 650
fft_window = signal.windows.hamming(128)
f, t, Zxx = signal.stft(x=complex_raw_data_DC, fs=SamplingFreq, window=fft_window,
                        nperseg=N_FFT_point, nfft=N_FFT_point, noverlap=N_FFT_point//2, boundary=None)

# fftshift
Zxx = fftshift(abs(Zxx), axes=0)

# make fft result into integer from float
for i in range(128):
    for j in range(29):
        Zxx[i][j] = math.ceil(abs(Zxx[i][j]))

# if want croped image(36x28), use below code / else, delete below code
Zxx = crop_image(Zxx)


# plot sample spectrogram for a stft
plt.imshow(Zxx, aspect='auto')
plt.colorbar()
plt.show()
