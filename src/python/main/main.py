import numpy as np
import matplotlib.pyplot as plt

import radar
import cirqueue
import stft


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


if __name__ == "__main__":
    # declare circular queue for I-data and Q-data
    I_raw_data_queue = cirqueue.CircularQueue()
    Q_raw_data_queue = cirqueue.CircularQueue()

    # declare list for I-data and Q-data
    I_raw_data = []
    Q_raw_data = []

    while True:
        radar.GetRadar(I_raw_data_queue, Q_raw_data_queue)
        # if queue is full, it means that there are enough data for 3 seconds
        if I_raw_data_queue.isFull() and Q_raw_data_queue.isFull():
            # load raw data from circular queue into list
            I_raw_data = I_raw_data_queue.returndata()
            Q_raw_data = Q_raw_data_queue.returndata()

            stft_result = stft.stft_crop(I_raw_data, Q_raw_data)

            ret = detect_human(stft_result)
            if ret == True:
                break

plt.imshow(stft_result, vmin=0, aspect='auto')
plt.colorbar()
plt.show()


'''
# pseudo code
while True:
    get radar data 
    stft
    if human detected:
        send it to FPGA by SPI
        (wait for BNN inference in FPGA)
        receive prediction from FPGA by SPI 
        display result
        clear
'''
