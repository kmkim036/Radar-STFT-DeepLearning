import serial

portname = "/dev/ttyACM0"
baudrate = 128000

radar = serial.Serial(portname, baudrate, timeout = 1)

while True:
    print(radar.readline())

