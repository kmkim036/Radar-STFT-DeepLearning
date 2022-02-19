from heapq import merge
import tensorflow as tf
import keras
from tensorflow.keras.optimizers import Adam
from keras.models import Sequential, Model
from keras.layers import Dense, Dropout, Flatten
from keras.layers import Input, Concatenate
from keras.layers.convolutional import Conv2D, MaxPooling2D


def create_CNNmodel_1(lr, img_row, img_col, classnum):
    input_img = Input(shape=(img_row, img_col, 1))
    # tower1(Conv2D(16, kernel_size=(3,3), strides=(1,1), padding='same', activation='relu')(input_img))
    # tower1 = MaxPooling2D((2,2), strides=(1,1), padding='same')(tower1)
    # tower1 = Dense
    # tower2 = (Conv2D(16, kernel_size=(5,5), strides=(1,1), padding='same', activation='relu')(input_img))
    # tower2 = MaxPooling2D((2,2), strides=(1,1), padding='same')(tower2)
    # tower1 = Conv2D(16, kernel_size=(3,3), strides=(1,1), activation='relu')(input_img)
    # tower2 = Conv2D(16, kernel_size=(5,5), strides=(1,1), activation='relu')(input_img)
    model = Sequential()

    left_branch = Sequential()
    left_branch.add(Conv2D(16, kernel_size=(3, 3), strides=(
        1, 1), padding='same', activation='relu', input_shape=(img_row, img_col, 1)))

    right_branch = Sequential()
    right_branch.add(Conv2D(16, kernel_size=(5, 5), strides=(
        1, 1), padding='same', activation='relu', input_shape=(img_row, img_col, 1)))

    # merged = Average([left_branch, right_branch])
    # merged = Sequential()
    # merged = Concatenate(axis=-1)([tower1, tower2])
    # model.add(Concatenate(axis=-1)([left_branch, right_branch]))
    print(left_branch.summary())
    print(right_branch.summary())
    concatted = Concatenate()([left_branch, right_branch])
    model.add(concatted)
    model.add(MaxPooling2D(2, 2))
    model.add(Flatten())
    model.add(Dense(64, activation='relu'))
    model.add(Dense(classnum, activation='softmax'))
    model.compile(loss='categorical_crossentropy',
                  optimizer=Adam(lr), metrics=['accuracy'])

    # def create_CNNmodel_1(lr, img_row, img_col, classnum):
    # model1 = Sequential()
    # model1.add(Conv2D(32, (3, 3), activation='relu',
    #           input_shape=(img_row, img_col, 1)))
    # model1.add(MaxPooling2D(2, 2))

    # model1.add(Flatten())
    # model1.add(Dense(64, activation='relu'))

    # model2 = Sequential()
    # model2.add(Conv2D(32, (5, 5), activation='relu',
    #           input_shape=(img_row, img_col, 1)))
    # model2.add(MaxPooling2D(2, 2))

    # model2.add(Flatten())
    # model2.add(Dense(64, activation='relu'))

    # model = Sequential()
    # model.add(Concatenate([model1, model2]))
    # model.add(Dense(classnum, activation='softmax'))
    # model.compile(loss='categorical_crossentropy',
    #               optimizer=Adam(lr), metrics=['accuracy'])
    # return model

    return model

# branch 없이 MTL
def create_CNNmodel_2(lr, img_row, img_col):
    model_input = Input(shape=(img_row, img_col, 1), name='main_input')

    main_branch = Conv2D(16, kernel_size=(3, 3), strides=(1, 1), activation='relu')(model_input)
    main_branch = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(main_branch)
    main_branch = Conv2D(16, kernel_size=(5, 5), strides=(1, 1), activation='relu')(main_branch)
    main_branch = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(main_branch)
    main_branch = Conv2D(16, kernel_size=(3, 3), strides=(1, 1), activation='relu')(main_branch)
    main_branch = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(main_branch)

    main_branch = Flatten()(main_branch)
    main_branch = Dense(128, activation='relu')(main_branch)

    human = Dense(4, activation='softmax', name='human_output')(main_branch)
    motion = Dense(2, activation='softmax', name='motion_output')(main_branch)

    model = Model(inputs=model_input, outputs=[human, motion])

    model.compile(optimizer=Adam(lr),
                  loss=['categorical_crossentropy',
                        'categorical_crossentropy'],
                  metrics=['accuracy'])

    return model
