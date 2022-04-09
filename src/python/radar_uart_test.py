import serial
import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
from scipy.fft import fftshift
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
I_raw_data_queue = CircularQueue()
Q_raw_data_queue = CircularQueue()

# declare list for I-data and Q-data
I_raw_data = []
Q_raw_data = []

# fft parameter
N_FFT_point = 128
SamplingFreq = 650
fft_window = signal.windows.hamming(128)

# UART setting and init
portname = "/dev/ttyACM0"
baudrate = 128000
radar = serial.Serial(portname, baudrate, timeout=0.3)


def GetRadar():
    # Get radar raw data and save into circular queue
    raw_data = str(radar.readline(), 'utf-8')
    if raw_data.find('I') > 0:
        for i in range(0, 18):
            raw_data = str(radar.readline(), 'utf-8')
            if i < 8:
                if raw_data.find('-') > 0:
                    # clear queue if async data come in the beginning
                    I_raw_data_queue.clear()
                    Q_raw_data_queue.clear()
                    break
                raw_data = raw_data.split()
                list_of_integers = list(map(int, raw_data))
                for j in list_of_integers:
                    if I_raw_data_queue.isFull():
                        I_raw_data_queue.dequeue()
                    I_raw_data_queue.enqueue(j)
            elif i < 10:
                continue
            else:
                raw_data = raw_data.split()
                list_of_integers = list(map(int, raw_data))
                for j in list_of_integers:
                    if Q_raw_data_queue.isFull():
                        Q_raw_data_queue.dequeue()
                    Q_raw_data_queue.enqueue(j)


def detect_human(image):
    '''
    need to fix human detect algorithm
    '''
    a = np.argmax(image, axis=0)
    b = np.argmax(image, axis=1)
    b = b[6:30]
    if a[23] >= 12 and a[23] <= 18 and a[24] >= 12 and a[24] <= 18 and a[25] >= 12 and a[25] <= 18 and a[26] >= 12 and a[26] <= 18 and a[27] >= 12 and a[27] <= 18 and b.min() >= 15:
        return True
    else:
        return False


while True:
    GetRadar()
    # if queue is full, it means that there are enough data for 3 seconds
    if I_raw_data_queue.isFull() and Q_raw_data_queue.isFull():
        # load raw data from circular queue into list
        I_raw_data = I_raw_data_queue.returndata()
        Q_raw_data = Q_raw_data_queue.returndata()

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

        ret = detect_human(Zxx)
        if ret == True:
            break

plt.imshow(Zxx, vmin=0, aspect='auto')
plt.colorbar()
plt.show()
