# Function
# convert csv data to data frame
# execute deep learning model

# Variable to check
# date: set date when measure data
# DirectoryPath: set by PC
# whole_counts: the number of whole sample in csv files
# img_row: the number of rows for cwt image
# img_col: the number of columns for cwt image
# classnum: number of class (by person, or by motion, or by both)


import sys

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

import tensorflow as tf
import keras
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten
from keras.layers.convolutional import Conv2D, MaxPooling2D
from keras.utils import np_utils


date = '211130'
whole_counts = 240
img_row = 45
img_col = 222

# Directory Path Setting
# kkm
# Ubuntu
# DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-CWT-DeepLearning/data/' + date + '/'
DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-CWT-DeepLearning/'
# Window
# DirectoryPath = 'C:/Users/김경민/Desktop/Studies/Projects/Radar-CWT-DeepLearning/data/' + date + '/'

# nkhj
# DirectoryPath = "/content/drive/MyDrive/data/"

# ksj
# DirectoryPath = ""


def preprocessing(classnum):
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
                if classnum == 12:  # classify by both person and motion
                    label.append(person * 4 + motion)
                elif classnum == 3:  # classify by person
                    label.append(person)
                elif classnum == 4:  # classify by motion
                    label.append(motion)
                i = i + 1
    return image, label


def create_CNNmodel(classnum):
    model = Sequential()
    model.add(Conv2D(64, kernel_size=(5, 5), strides=(1, 1),
                     padding='same', activation='relu', input_shape=(img_row, img_col, 1)))
    model.add(MaxPooling2D(pool_size=(2, 2), strides=(2, 2)))
    model.add(Conv2D(32, kernel_size=(2, 2), activation='relu', padding='same'))
    model.add(MaxPooling2D(pool_size=(2, 2)))
    model.add(Dropout(0.25))
    model.add(Flatten())
    model.add(Dense(250, activation='relu'))
    model.add(Dropout(0.5))
    model.add(Dense(classnum, activation='softmax'))
    model.compile(loss='categorical_crossentropy',
                  optimizer='adam', metrics=['accuracy'])

    return model


if __name__ == "__main__":

    classnum = 12

    # preprocessing
    x_result, x_label = preprocessing(classnum)

    x_result = np.array(x_result)
    x_label = np_utils.to_categorical(x_label, classnum)

    model = create_CNNmodel(classnum)

    hist = model.fit(x_result, x_label, epochs=10)

    # evaluate: evaluate
    print('Evaluate')
    score = model.evaluate(x_result, x_label)
    print('Test loss:', score[0])
    print('Test accuracy:', score[1])

    # predict: test
    pred = model.predict(x_result)
    print("1st data:", np.argmax(x_label[0]))
    print("1st predict: ", np.argmax(pred[0]))
    print("2nd data:", np.argmax(x_label[78]))
    print("2nd predict: ", np.argmax(pred[78]))
    print("3rd data:", np.argmax(x_label[149]))
    print("3rd predict: ", np.argmax(pred[149]))
    print("4th data:", np.argmax(x_label[238]))
    print("4th predict: ", np.argmax(pred[238]))
