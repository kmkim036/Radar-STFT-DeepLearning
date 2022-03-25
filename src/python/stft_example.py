import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import signal
import matplotlib.pyplot as plt

IM_file_name = '220128_1_2_45_IM.txt'
RE_file_name = '220128_1_2_45_RE.txt'

# need to change directory name for own PC
DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-STFT-DeepLearning/data/220128/'

IM_raw_data = []
RE_raw_data = []

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

complex_raw_data = []
for i in range(0, 1920):
    complex_raw_data.append(complex(RE_raw_data[i], IM_raw_data[i]))
complex_raw_data_DC = complex_raw_data - np.mean(complex_raw_data)

N_FFT_point = 128
SamplingFreq = 650
fft_window = np.hamming(N_FFT_point)

f, t, Zxx = signal.stft(x=complex_raw_data_DC, fs=SamplingFreq, window=fft_window,
                        nperseg=N_FFT_point, nfft=N_FFT_point, noverlap=N_FFT_point/2.2)

# print frequency domain length
print(Zxx.shape[0])

# print time domain length
print(len(Zxx[0]))

# print abs(stft result) for one frequency range
print(abs(Zxx[0]))

# plot stft image
plt.pcolormesh(t, f, abs(Zxx), vmin=0)
plt.title('STFT Magnitude')
plt.ylabel('Frequency [Hz]')
plt.xlabel('Time [sec]')
plt.show()


# another library for stft 1
# import tensorflow as tf
# results = tf.signal.stft(complex_raw_data_DC, frame_length=N_FFT_point, frame_step=N_FFT_point/2, window_fn=fft_window)

# another library for stft 2
# import librosa
# stftdata = librosa.stft(complex_raw_data_DC, n_fft = N_FFT_point, hop_length=N_FFT_point / 2)
# print(stftdata)
