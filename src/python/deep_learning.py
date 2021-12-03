# Function
# convert csv data to data frame
# execute deep learning model by motion to predict who

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
img_row = 26
img_col = 384
classnum = 3

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

# 80% => train
# 20% => test


def preprocessing_by_motion(motion):
    if motion < 2:
        whole_rounds = 30
    else:
        whole_rounds = 10
    whole_counts1 = int(whole_rounds * 0.8 * 3)
    image1 = np.zeros(shape=(whole_counts1, img_row, img_col))
    label1 = []
    whole_counts2 = int(whole_rounds * 0.2 * 3)
    image2 = np.zeros(shape=(whole_counts2, img_row, img_col))
    label2 = []
    i = 0
    for person in range(0, 3):
        cwt_data = pd.read_csv(
            DirectoryPath + date + "_" + str(person) + "_" + str(motion) + "_cwt.csv")
        for rounds in range(0, int(whole_rounds * 0.8)):
            df = np.fromstring(cwt_data['pixels'][rounds], dtype=int, sep=' ')
            df = np.reshape(df, (img_row, img_col))
            image1[i] = df
            label1.append(person)
            i = i + 1
    i = 0
    for person in range(0, 3):
        cwt_data = pd.read_csv(
            DirectoryPath + date + "_" + str(person) + "_" + str(motion) + "_cwt.csv")
        for rounds in range(int(whole_rounds * 0.8), whole_rounds):
            df = np.fromstring(cwt_data['pixels'][rounds], dtype=int, sep=' ')
            df = np.reshape(df, (img_row, img_col))
            image2[i] = df
            label2.append(person)
            i = i + 1

    return image1, label1, image2, label2


def create_CNNmodel():
    model = Sequential()
    model.add(Conv2D(64, kernel_size=(5, 5), strides=(1, 1),
                     padding='same', activation='relu', input_shape=(img_row, img_col, 1)))
    model.add(MaxPooling2D(pool_size=(2, 2), strides=(2, 2)))
    model.add(Conv2D(32, kernel_size=(2, 2), activation='relu', padding='same'))
    model.add(MaxPooling2D(pool_size=(2, 2)))
    model.add(Dropout(0.25))
    model.add(Flatten())
    model.add(Dense(500, activation='relu'))
    model.add(Dropout(0.5))
    model.add(Dense(classnum, activation='softmax'))
    model.compile(loss='categorical_crossentropy',
                  optimizer='adam', metrics=['accuracy'])

    return model


if __name__ == "__main__":
    model = create_CNNmodel()

    # preprocessing
    # w = walk(0), r = run(1), s = stride(2), c = creep(3)
    for i in range(0, 4):
        train_set, train_label, test_set, test_label = preprocessing_by_motion(
            i)
        print("motion index: " + str(i))
        print("train set")
        print("counts: " + str(train_set.shape[0]))
        print("labels: " + str(train_label))
        print("test set")
        print("counts: " + str(test_set.shape[0]))
        print("labels: " + str(test_label))
        train_set = np.array(train_set)
        test_set = np.array(test_set)
        train_label = np_utils.to_categorical(train_label, classnum)
        test_label = np_utils.to_categorical(test_label, classnum)

        hist = model.fit(train_set, train_label, epochs=10)

        # evaluate: evaluate
        print('Evaluate')
        score = model.evaluate(test_set, test_label)
        print('Test loss:', score[0])
        print('Test accuracy:', score[1])

        # predict: test
        pred = model.predict(test_set)
        if i < 2:
            cnts = 18
        else:
            cnts = 6
        corrects = 0
        notcorrects = 0
        for j in range(0, cnts):
            if np.argmax(test_label[j]) == np.argmax(pred[j]):
                corrects = corrects + 1
            else:
                notcorrects = notcorrects + 1
            print("No." + str(j + 1) + " data: " +
                  str(np.argmax(test_label[j])), ", predict: " + str(np.argmax(pred[j])))
        print("predict accuracy: " + str(corrects / cnts))
