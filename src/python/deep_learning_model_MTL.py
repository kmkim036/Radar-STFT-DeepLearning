import tensorflow as tf
import keras
from tensorflow.keras.optimizers import Adam
from keras.models import Sequential, Model
from keras.layers import Dense, Flatten
from keras.layers import Input, Add
from keras.layers.convolutional import Conv2D, MaxPooling2D

def create_CNNmodel(modeltype, lr, img_row, img_col):

    model_input = Input(shape=(img_row, img_col, 1), name='main_input')

    if modeltype == 1:
        # model 1
        # merge 2 branches
        left_branch = Conv2D(16, kernel_size=(3, 3), strides=(1, 1), padding = 'same', activation='relu')(model_input)
        left_branch = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(left_branch)

        right_branch = Conv2D(16, kernel_size=(5, 5), strides=(1, 1), padding = 'same', activation='relu')(model_input)
        right_branch = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(right_branch)

        main_branch = Add()([left_branch, right_branch])
        main_branch = MaxPooling2D(pool_size=(2, 2), strides=(1, 1))(main_branch)
    elif modeltype == 2:
        # model 2
        # one stream with multiple kernels
        main_branch = Conv2D(16, kernel_size=(3, 3), strides=(1,1), activation='relu')(model_input)
        main_branch = MaxPooling2D(pool_size=(2, 2), strides=(1,1))(main_branch)
        
        main_branch = Conv2D(16, kernel_size=(5, 5), strides=(1,1), activation='relu')(main_branch)
        main_branch = MaxPooling2D(pool_size=(2, 2), strides=(1,1))(main_branch)
        
        main_branch = Conv2D(16, kernel_size=(3, 3), strides=(1,1), activation='relu')(main_branch)
        main_branch = MaxPooling2D(pool_size=(2, 2), strides=(1,1))(main_branch)

    main_branch = Flatten()(main_branch)
    main_branch = Dense(128, activation='relu')(main_branch)

    human = Dense(4, activation='softmax', name = 'human_output')(main_branch)
    motion = Dense(2, activation='softmax', name = 'motion_output')(main_branch)

    model = Model(inputs = model_input, outputs = [human, motion])
    
    model.compile(optimizer=Adam(lr), 
                  loss=['categorical_crossentropy', 'categorical_crossentropy'],
                  metrics=['accuracy'])
    
    return model
