import radar
import cirqueue
import stft
import spi
import display
import detect


import time

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


if __name__ == "__main__":
    # declare circular queue for I-data and Q-data
    I_raw_data_queue = cirqueue.CircularQueue()
    Q_raw_data_queue = cirqueue.CircularQueue()

    # declare list for I-data and Q-data
    I_raw_data = []
    Q_raw_data = []
    

    display.display_init()
    while True:
        radar.GetRadar(I_raw_data_queue, Q_raw_data_queue)
        if I_raw_data_queue.isFull() and Q_raw_data_queue.isFull():
            I_raw_data = I_raw_data_queue.returndata()
            Q_raw_data = Q_raw_data_queue.returndata()

            stft_result, power = stft.stft_crop(I_raw_data, Q_raw_data)

            ret = detect.detect_human(stft_result, power)

            if ret == True:
#                start = time.time() # time measure
                spi.send_spi(stft_result)
                motion, human = spi.receive_spi()
#                exc_time = time.time() - start # time measure
#                print("time: ") # time measure
#                print(exc_time) # time measure
                display.display_result(stft_result, motion, human)
                I_raw_data_queue.clear()
                Q_raw_data_queue.clear()
