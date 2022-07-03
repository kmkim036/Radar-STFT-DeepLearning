import serial


# UART setting and init
portname = "/dev/ttyACM0"
baudrate = 128000
radar = serial.Serial(portname, baudrate, timeout=0.3)


def GetRadar(I_raw_data_queue, Q_raw_data_queue):
    # Get radar raw data and save into circular queue
    while True:
        if str(radar.readline()).find('I') > 0:
            break

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
            if raw_data.find('-') > 0:
                # clear queue if async data come in the beginning
                I_raw_data_queue.clear()
                Q_raw_data_queue.clear()
                break
            raw_data = raw_data.split()
            list_of_integers = list(map(int, raw_data))
            for j in list_of_integers:
                if Q_raw_data_queue.isFull():
                    Q_raw_data_queue.dequeue()
                Q_raw_data_queue.enqueue(j)
