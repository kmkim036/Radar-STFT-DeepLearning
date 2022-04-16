import numpy as np
import pandas as pd
from scipy import signal
import matplotlib.pyplot as plt
from scipy.fft import fftshift
import math

# IM_file_name = '220305_3_3_78_IM.txt'
# RE_file_name = '220305_3_3_78_RE.txt'

# need to change directory name for own PC
DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-STFT-DeepLearning/data/220221/'

IM_raw_data = []
RE_raw_data = []

true_count = 0

for i in range(1, 101):
    IM_file_name = '220221_1_3_' + str(i) + '_IM.txt'
    RE_file_name = '220221_1_3_' + str(i) + '_RE.txt'

    # print(IM_file_name)

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


    def crop_image(image):
        # crop image into 36 x 28 size from 128 x 29
        crop_image = image[46:82, 1:29]
        return crop_image


    # fftshift
    Zxx = fftshift(abs(Zxx), axes=0)
    Zxx = crop_image(Zxx)

    power_sum = 0

    # make fft result into integer from float
    for i in range(36):
        for j in range(28):
            Zxx[i][j] = math.ceil(abs(Zxx[i][j]))
            power_sum += Zxx[i][j] * Zxx[i][j]

    a = np.argmax(Zxx, axis=0)
    b = np.argmax(Zxx, axis=1)
    b = b[6:30]
    print(b)

    if power_sum > 5000000:
        if a[23] >= 12 and a[23] <= 18 and a[24] >= 12 and a[24] <= 18 and a[25] >= 12 and a[25] <= 18 and a[26] >= 12 and a[26] <= 18 and a[27] >= 12 and a[27] <= 18 and b.min() >= 15:
            true_count += 1
        else:
            print('check1')
    else:
        print('check2')

    # if a[23] >= 12 and a[23] <= 18 and a[24] >= 12 and a[24] <= 18 and a[25] >= 12 and a[25] <= 18 and a[26] >= 12 and a[26] <= 18 and a[27] >= 12 and a[27] <= 18:
    #     print('check1')
    # if b.min() >= 15:
    #     print('check2')


    # # plot sample spectrogram for a stft
    # plt.imshow(Zxx, aspect='auto')
    # plt.colorbar()
    # plt.show()

print(true_count)