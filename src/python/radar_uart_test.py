import serial
import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
from scipy.fft import fftshift
import matplotlib.pyplot as plt
import math


class CircularQueue:
    # circular queue to save radar raw data
    def __init__(self):
        self.front = 0
        self.rear = 0
        self.max_qsize = 1921   # 16 * 8 * 15 + 1
        self.items = [None] * self.max_qsize

    def isEmpty(self):
        return self.front == self.rear

    def isFull(self):
        return self.front == (self.rear+1) % self.max_qsize

    def clear(self):
        self.front = self.rear

    def __len__(self):
        return (self.rear - self.front + self.max_qsize) % self.max_qsize

    def enqueue(self, item):
        if not self.isFull():
            self.rear = (self.rear + 1) % self.max_qsize
            self.items[self.rear] = item

    def dequeue(self):
        if not self.isEmpty():
            self.front = (self.front+1) % self.max_qsize
            return self.items[self.front]

    def peek(self):
        if not self.isEmpty():
            return self.items[(self.front+1) % self.max_qsize]

    def print(self):
        out = []
        if self.front < self.rear:
            out = self.items[self.front+1:self.rear+1]
        else:
            out = self.items[self.front+1:self.max_qsize] + \
                self.items[0:self.rear+1]

        print("[f=%s, r=%d] ==> " % (self.front, self.rear), out)

    def returndata(self):
        result = []
        if self.front < self.rear:
            result = self.items[self.front+1:self.rear+1]
        else:
            result = self.items[self.front+1:self.max_qsize] + \
                self.items[0:self.rear+1]
        return result


# declare circular queue for I-data and Q-data
I_rawdata_queue = CircularQueue()
Q_rawdata_queue = CircularQueue()

# declare list fot I-data and Q-data
I_rawdata = []
Q_rawdata = []

# UART setting and init
portname = "/dev/ttyACM0"
baudrate = 128000
radar = serial.Serial(portname, baudrate, timeout=0.3)


def GetRadar():
    # Get radar raw data and save into circular queue
    rawdata = str(radar.readline(), 'utf-8')
    if rawdata.find('I') > 0:
        for i in range(0, 18):
            rawdata = str(radar.readline(), 'utf-8')
            if i < 8:
                rawdata = rawdata.split()
                list_of_integers = list(map(int, rawdata))
                for j in list_of_integers:
                    if I_rawdata_queue.isFull():
                        I_rawdata_queue.dequeue()
                    I_rawdata_queue.enqueue(j)
            elif i < 10:
                continue
            else:
                rawdata = rawdata.split()
                list_of_integers = list(map(int, rawdata))
                for j in list_of_integers:
                    if Q_rawdata_queue.isFull():
                        Q_rawdata_queue.dequeue()
                    Q_rawdata_queue.enqueue(j)
    '''
    *** need to fix bug under message *** 
    Traceback (most recent call last):
        File "src/python/radar_uart_test.py", line 113, in <module>
            GetRadar()
        File "src/python/radar_uart_test.py", line 86, in GetRadar
            list_of_integers = list(map(int, rawdata))
    ValueError: invalid literal for int() with base 10: '-------------'
    '''


# get radar raw data until 1920 samples
while I_rawdata_queue.isFull() != 1 and Q_rawdata_queue.isFull() != 1:
    GetRadar()

# load raw data from circular queue into list
I_rawdata = I_rawdata_queue.returndata()
Q_rawdata = Q_rawdata_queue.returndata()

# make complex input using I-data and Q-data
complex_raw_data = []
for i in range(0, 1920):
    complex_raw_data.append(
        complex(I_rawdata[i], Q_rawdata[i]))
complex_raw_data_DC = complex_raw_data - np.mean(complex_raw_data)

# fft setting and executing
N_FFT_point = 128
SamplingFreq = 650
fft_window = signal.windows.hamming(128)
f, t, Zxx = signal.stft(x=complex_raw_data_DC, fs=SamplingFreq, window=fft_window,
                        nperseg=N_FFT_point, nfft=N_FFT_point, noverlap=N_FFT_point//2, boundary=None)

# make fft result into integer from float
for i in range(128):
    for j in range(29):
        Zxx[i][j] = math.ceil(abs(Zxx[i][j]))

# fftshift
Zxx = fftshift(abs(Zxx), axes=0)

# plot sample spectrogram for a stft
plt.imshow(Zxx, vmin=0, aspect='auto')
plt.show()
