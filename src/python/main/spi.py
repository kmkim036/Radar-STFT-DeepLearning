import spidev
import numpy as np


def send_spi(image):
    # send 36x28 image to FPGA using SPI communication
    spi = spidev.SpiDev()
    spi.open(0, 0)
    spi.mode = 1
    spi.max_speed_hz = 5000000

    # binarize input image
    image_std = (image - 25.56) / 92.51

    binary_image = [[0 for j in range(28)] for i in range(36)]
    for i in range(36):
        for j in range(28):
            if image_std[i][j] <= 0:
                binary_image[i][j] = 0
            else:
                binary_image[i][j] = 1

    spi_data = np.zeros(144)
    for i in range(0, 36):
        for j in range(0, 8):
            spi_data[4*i + 0] += binary_image[i][j] * (2**(7-j))
            spi_data[4*i + 1] += binary_image[i][8 + j] * (2**(7-j))
            spi_data[4*i + 2] += binary_image[i][16 + j] * (2**(7-j))
        for j in range(0, 4):
            spi_data[4*i + 3] += binary_image[i][24 + j] * (2**(7-j))

    spi.xfer2(
        [0x08,
         int(spi_data[0]),  int(spi_data[1]), int(
             spi_data[2]), int(spi_data[3]), int(spi_data[4]),
         int(spi_data[5]),  int(spi_data[6]), int(
             spi_data[7]), int(spi_data[8]), int(spi_data[9]),
         int(spi_data[10]),  int(spi_data[11]), int(
             spi_data[12]), int(spi_data[13]), int(spi_data[14]),
         int(spi_data[15]),  int(spi_data[16]), int(
             spi_data[17]), int(spi_data[18]), int(spi_data[19]),
         int(spi_data[20]),  int(spi_data[21]), int(
             spi_data[22]), int(spi_data[23]), int(spi_data[24]),
         int(spi_data[25]),  int(spi_data[26]), int(
             spi_data[27]), int(spi_data[28]), int(spi_data[29]),
         int(spi_data[30]),  int(spi_data[31]), int(
             spi_data[32]), int(spi_data[33]), int(spi_data[34]),
         int(spi_data[35]),  int(spi_data[36]), int(
             spi_data[37]), int(spi_data[38]), int(spi_data[39]),
         int(spi_data[40]),  int(spi_data[41]), int(
             spi_data[42]), int(spi_data[43]), int(spi_data[44]),
         int(spi_data[45]),  int(spi_data[46]), int(
             spi_data[47]), int(spi_data[48]), int(spi_data[49]),
         int(spi_data[50]),  int(spi_data[51]), int(
             spi_data[52]), int(spi_data[53]), int(spi_data[54]),
         int(spi_data[55]),  int(spi_data[56]), int(
             spi_data[57]), int(spi_data[58]), int(spi_data[59]),
         int(spi_data[60]),  int(spi_data[61]), int(
             spi_data[62]), int(spi_data[63]), int(spi_data[64]),
         int(spi_data[65]),  int(spi_data[66]), int(
             spi_data[67]), int(spi_data[68]), int(spi_data[69]),
         int(spi_data[70]),  int(spi_data[71]), int(
             spi_data[72]), int(spi_data[73]), int(spi_data[74]),
         int(spi_data[75]),  int(spi_data[76]), int(
             spi_data[77]), int(spi_data[78]), int(spi_data[79]),
         int(spi_data[80]),  int(spi_data[81]), int(
             spi_data[82]), int(spi_data[83]), int(spi_data[84]),
         int(spi_data[85]),  int(spi_data[86]), int(
             spi_data[87]), int(spi_data[88]), int(spi_data[89]),
         int(spi_data[90]),  int(spi_data[91]), int(
             spi_data[92]), int(spi_data[93]), int(spi_data[94]),
         int(spi_data[95]),  int(spi_data[96]), int(
             spi_data[97]), int(spi_data[98]), int(spi_data[99]),
         int(spi_data[100]),  int(spi_data[101]), int(
             spi_data[102]), int(spi_data[103]), int(spi_data[104]),
         int(spi_data[105]),  int(spi_data[106]), int(
             spi_data[107]), int(spi_data[108]), int(spi_data[109]),
         int(spi_data[110]),  int(spi_data[111]), int(
             spi_data[112]), int(spi_data[113]), int(spi_data[114]),
         int(spi_data[115]),  int(spi_data[116]), int(
             spi_data[117]), int(spi_data[118]), int(spi_data[119]),
         int(spi_data[120]),  int(spi_data[121]), int(
             spi_data[122]), int(spi_data[123]), int(spi_data[124]),
         int(spi_data[125]),  int(spi_data[126]), int(
             spi_data[127]), int(spi_data[128]), int(spi_data[129]),
         int(spi_data[130]),  int(spi_data[131]), int(
             spi_data[132]), int(spi_data[133]), int(spi_data[134]),
         int(spi_data[135]),  int(spi_data[136]), int(
             spi_data[137]), int(spi_data[138]), int(spi_data[139]),
         int(spi_data[140]), int(spi_data[141]), int(spi_data[142]), int(spi_data[143])]
    )
    '''
    for i in binary_image:
        for j in i:
            print(j, end=" ")
        print()

    print(spi_data)
    '''
    spi.close()


def receive_spi():
    # receive prediction from FPGA using SPI communication
    spi = spidev.SpiDev()
    spi.open(0, 0)
    spi.mode = 1
    spi.max_speed_hz = 5000000

    output = spi.xfer2([0x00, 0x00])

    # print(output)

    spi.close()

    '''
    0 1 2 
    3 4 5 
    6 7 8
    9 10 11
    '''
    ret = output[1]

    if ret < 3:
        human = 0
    elif ret < 6:
        human = 1
    elif ret < 9:
        human = 2
    else:
        human = 3

    motion = ret % 3

    return motion, human
