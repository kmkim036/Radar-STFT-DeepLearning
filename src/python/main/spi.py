def send_spi(image):
    # send 36x28 image to FPGA using SPI communication
    print('send success')


def receive_spi():
    # receive prediction from FPGA using SPI communication
    motion = 0
    # 0: walk
    # 1: stride
    # 2: creep
    human = 0
    # 0: man 1
    # 1: man 2
    # 2: woman 1
    # 3: woman 2
    return motion, human
