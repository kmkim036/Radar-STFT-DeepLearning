import tensorflow as tf
import keras
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten
from keras.layers.convolutional import Conv2D, MaxPooling2D


def create_CNNmodel(img_row, img_col, classnum):
    model = Sequential()

    # model 1
    # model.add(Conv2D(32, (3, 3), activation='relu',
    #           input_shape=(img_row, img_col, 1)))
    # model.add(MaxPooling2D(2, 2))

    # model.add(Conv2D(64, (3, 3), activation='relu'))
    # model.add(MaxPooling2D(2, 2))
    # model.add(Conv2D(64, (3, 3), activation='relu'))

    # model.add(Flatten())
    # model.add(Dense(64, activation='relu'))
    # model.add(Dense(classnum, activation='softmax'))
    # model.compile(loss='categorical_crossentropy',
    #               optimizer='adam', metrics=['accuracy'])

    # model 2
    model = Sequential()
    model.add(Conv2D(16, kernel_size=(5, 5),strides=(1,1), activation='relu', input_shape=(img_row, img_col, 1)))
    model.add(MaxPooling2D(pool_size=(2, 2), strides =(1, 1)))

    model.add(Conv2D(16, kernel_size=(5, 5),strides=(1, 1), activation='relu'))
    model.add(MaxPooling2D(pool_size=(2, 2), strides =(1, 1)))

    model.add(Flatten())

    model.add(Dense(128, activation='relu'))
    model.add(Dense(classnum, activation='softmax'))
    model.compile(loss='categorical_crossentropy',
                  optimizer='adam', metrics=['accuracy'])

    # model 3
    # model = Sequential()
    # model.add(Conv2D(8, kernel_size=(3, 3), activation='relu', input_shape=(img_row, img_col, 1)))
    # model.add(MaxPooling2D(pool_size=(2, 2), strides =(1, 1)))

    # model.add(Conv2D(16, kernel_size=(3, 3), activation='relu'))
    # model.add(MaxPooling2D(pool_size=(2, 2), strides =(1, 1)))

    # model.add(Conv2D(32, kernel_size=(3, 3), activation='relu'))
    # model.add(MaxPooling2D(pool_size=(2, 2), strides =(1, 1)))

    # model.add(Conv2D(64, kernel_size=(3, 3), activation='relu'))
    # model.add(MaxPooling2D(pool_size=(2, 2), strides =(1, 1)))

    # model.add(Flatten())
    # model.add(Dense(128, activation='relu'))
    # model.add(Dense(classnum, activation='softmax'))
    # model.compile(loss='categorical_crossentropy',
    #               optimizer='adam', metrics=['accuracy'])


    return model
