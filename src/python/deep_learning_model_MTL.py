from calendar import c
import tensorflow as tf
import keras
from tensorflow.keras.optimizers import Adam
from keras.models import Sequential, Model
from keras.layers import Dense, Flatten
from keras.layers import Input, Add
from keras.layers.convolutional import Conv2D, MaxPooling2D

def create_CNNmodel(classnum_human, classnum_motion, lr, img_row, img_col):

    model_input = Input(shape=(img_row, img_col, 1), name='main_input')

    left_branch1 = Conv2D(16, kernel_size=(3, 3), strides=(1, 1), padding = 'same', activation='relu')(model_input)
    left_branch1 = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(left_branch1)

    right_branch1 = Conv2D(16, kernel_size=(5, 5), strides=(1, 1), padding = 'same', activation='relu')(model_input)
    right_branch1 = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(right_branch1)

    main_branch1 = Add()([left_branch1, right_branch1])
    main_branch1 = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(main_branch1)

    left_branch2 = Conv2D(16, kernel_size=(3, 3), strides=(1, 1), padding = 'same', activation='relu')(main_branch1)
    left_branch2 = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(left_branch2)

    right_branch2 = Conv2D(16, kernel_size=(5, 5), strides=(1, 1), padding = 'same', activation='relu')(main_branch1)
    right_branch2 = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(right_branch2)

    main_branch2 = Add()([left_branch2, right_branch2])
    main_branch2 = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(main_branch2)

    left_branch3 = Conv2D(16, kernel_size=(3, 3), strides=(1, 1), padding = 'same', activation='relu')(main_branch2)
    left_branch3 = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(left_branch3)

    right_branch3 = Conv2D(16, kernel_size=(5, 5), strides=(1, 1), padding = 'same', activation='relu')(main_branch2)
    right_branch3 = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(right_branch3)

    main_branch3 = Add()([left_branch3, right_branch3])
    main_branch3 = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(main_branch3)

    main_branch = Flatten()(main_branch3)
    main_branch = Dense(128, activation='relu')(main_branch)

    human = Dense(classnum_human, activation='softmax', name = 'human_output')(main_branch)
    motion = Dense(classnum_motion, activation='softmax', name = 'motion_output')(main_branch)

    model = Model(inputs = model_input, outputs = [human, motion])
    
    model.compile(optimizer=Adam(lr), 
                  loss=['categorical_crossentropy', 'categorical_crossentropy'],
                  metrics=['accuracy'])
    
    return model
