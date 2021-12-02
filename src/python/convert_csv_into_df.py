# Function
# convert csv data to data frame

# Variable to check
# date: set date when measure data
# DirectoryPath: set by PC
# whole_counts: the number of whole sample in csv files
# img_row: the number of rows for cwt image
# img_col: the number of columns for cwt image
# classnum: number of class (by person, or by motion, or by both)


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

date = '211130'
classnum = 12


# Directory Path
# kkm
# Ubuntu
# DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-CWT-DeepLearning/data/' + date + '/'
DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-CWT-DeepLearning/'
# Window
#DirectoryPath = 'C:/Users/김경민/Desktop/Studies/Projects/Radar-CWT-DeepLearning/data/' + date + '/'

# nkhj
# DirectoryPath = "/content/drive/MyDrive/data/"

# ksj
# DirectoryPath = ""


def preprocessing():
    whole_counts = 240
    img_row = 45
    img_col = 222
    # make blank numpy with (img_row X img_col)
    image = np.zeros(shape=(whole_counts, img_row, img_col))
    label = []
    i = 0
    for person in range(0, 3):
        for motion in range(0, 4):
            cwt_data = pd.read_csv(DirectoryPath + date + "_" +
                                   str(person) + "_" + str(motion) + "_cwt.csv")
            for rounds in range(0, len(cwt_data)):
                df = np.fromstring(
                    cwt_data['pixels'][rounds], dtype=int, sep=' ')
                df = np.reshape(df, (img_row, img_col))
                image[i] = df
                if classnum == 12:
                    # classify by (person + motion)
                    label.append(person * 4 + motion)
                elif classnum == 3:
                    label.append(person)  # classify by person
                else:
                    label.append(motion)  # classify by motion
                i = i + 1
    return image, label


if __name__ == "__main__":
    # preprocessing
    x_result, x_label = preprocessing()

    # check the preprocessed data
    # print(x_result)   # 전체 구조확인
    print(x_label)
    print(x_result[0])        # 0번째 값 확인
    plt.imshow(x_result[0])  # 0번째 값 출력
    plt.show()
