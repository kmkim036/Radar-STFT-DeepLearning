import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import signal
from scipy.fft import fft, fftshift
import matplotlib.pyplot as plt
import math

date = 220110

# need to change directory name for own PC
DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-STFT-DeepLearning/'
DataDirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-STFT-DeepLearning/data/' + str(date) + '/'

repeat = 50  # (repeat)
for human in range(1, 3):
    for motion in range(0, 3):
        if motion == 1:
            continue
        txt_file_name = str(date)+'_'+str(human)+'_'+str(motion)+'_stft.txt'
        f = open(DirectoryPath + txt_file_name, 'w')
        f.close()

        for repeat in range(1, repeat + 1):
            IM_raw_data = []
            RE_raw_data = []
            RE_file_name = str(date)+'_'+str(human)+'_' + \
                str(motion)+'_'+str(repeat)+'_RE.txt'
            IM_file_name = str(date)+'_'+str(human)+'_' + \
                str(motion)+'_'+str(repeat)+'_IM.txt'
            f = open(DataDirectoryPath + RE_file_name)
            while True:
                line = f.readline()
                if not line:
                    break
                line = line.replace('\n', '')
                RE_raw_data.append(int(line))
            f.close()

            f = open(DataDirectoryPath + IM_file_name)
            while True:
                line = f.readline()
                if not line:
                    break
                line = line.replace('\n', '')
                IM_raw_data.append(int(line))
            f.close()

            complex_raw_data = []
            for i in range(0, 1920):
                complex_raw_data.append(
                    complex(RE_raw_data[i], IM_raw_data[i]))
            complex_raw_data_DC = complex_raw_data - np.mean(complex_raw_data)

            N_FFT_point = 128
            SamplingFreq = 650
            fft_window = signal.windows.hamming(128)

            f, t, Zxx = signal.stft(x=complex_raw_data_DC, fs=SamplingFreq, window=fft_window, 
                                    nperseg=N_FFT_point, nfft=N_FFT_point, noverlap=N_FFT_point//2, boundary=None)
            for i in range(128):
                for j in range(29):
                    Zxx[i][j] = math.ceil(abs(Zxx[i][j]))
            Zxx = fftshift(abs(Zxx), axes=0)

            f = open(DirectoryPath + txt_file_name, 'a')
            for j in range(0, 128):
                for k in range(0, 29):
                    f.write(str(Zxx[j][k])+' ')
            f.write('\n')
            f.close()


print(Zxx.shape[0])
print(len(Zxx[0]))

# plot sample spectrogram for a stft
plt.imshow(Zxx, vmin=0, aspect='auto')
plt.show()
