import tensorflow as tf
import keras

from keras.models import Sequential, Model
from keras.layers import Flatten, Activation, MaxPooling2D
from keras.layers import Input, Add
from tensorflow.keras.optimizers import Adam

from binary_layers import BinaryDense, BinaryConv2D
from activations import binary_tanh 

H = 1.
kernel_lr_multiplier = 'Glorot'
use_bias = False


def create_CNNmodel(lr, img_row, img_col, classnum):
    model = Sequential()
    model.add(BinaryConv2D(16, kernel_size=(3, 3), input_shape=(img_row, img_col, 1),
                        data_format=None,
                        H=H, kernel_lr_multiplier=kernel_lr_multiplier, 
                        padding='valid', use_bias=use_bias, name='conv1'))
    model.add(MaxPooling2D(pool_size=(2, 2), name='pool1', data_format=None))
    model.add(Activation(binary_tanh, name='act1'))

    model.add(BinaryConv2D(16, kernel_size=(3, 3), input_shape=(1, img_row, img_col),
                        data_format=None,
                        H=H, kernel_lr_multiplier=kernel_lr_multiplier, 
                        padding='valid', use_bias=use_bias, name='conv2'))
    model.add(MaxPooling2D(pool_size=(2, 2), name='pool2', data_format=None))
    model.add(Activation(binary_tanh, name='act2'))

    model.add(BinaryConv2D(16, kernel_size=(3, 3), input_shape=(1, img_row, img_col),
                        data_format=None,
                        H=H, kernel_lr_multiplier=kernel_lr_multiplier, 
                        padding='valid', use_bias=use_bias, name='conv3'))
    model.add(MaxPooling2D(pool_size=(2, 2), name='pool3', data_format=None))
    model.add(Activation(binary_tanh, name='act3'))

    model.add(Flatten())
    model.add(BinaryDense(128, H=H, kernel_lr_multiplier=kernel_lr_multiplier, use_bias=use_bias, name='dense4'))
    model.add(Activation(binary_tanh, name='act4'))

    model.add(BinaryDense(classnum, H=H, kernel_lr_multiplier=kernel_lr_multiplier, use_bias=use_bias, name='dense5'))
    
    model.compile(loss='categorical_crossentropy',
                  optimizer=Adam(lr), metrics=['accuracy'])

    return model

def create_CNNmodel_MTL(classnum_human, classnum_motion, lr, img_row, img_col):

    model_input = Input(shape=(img_row, img_col, 1), name='main_input')

    # merge 2 branches
    left_branch = BinaryConv2D(16, kernel_size=(3, 3), input_shape=model_input,
                    data_format=None,
                    H=H, kernel_lr_multiplier=kernel_lr_multiplier, 
                    padding='same', use_bias=use_bias, name='conv1')
    left_branch = MaxPooling2D(pool_size=(2, 2), name='pool1', data_format=None)(left_branch)
    left_branch = Activation(binary_tanh, name='act1')(left_branch)

    right_branch = BinaryConv2D(16, kernel_size=(5, 5), input_shape=model_input,
                    data_format=None,
                    H=H, kernel_lr_multiplier=kernel_lr_multiplier, 
                    padding='same', use_bias=use_bias, name='conv2')
    right_branch = MaxPooling2D(pool_size=(2, 2), name='pool2', data_format=None)(right_branch)
    right_branch = Activation(binary_tanh, name='act2')(right_branch)

    main_branch = Add()([left_branch, right_branch])
    main_branch = MaxPooling2D(pool_size=(2, 2), name='pool3', data_format=None)(main_branch)
    main_branch = Activation(binary_tanh, name='act3')(main_branch)

    main_branch = Flatten()(main_branch)
    main_branch = BinaryDense(128, H=H, kernel_lr_multiplier=kernel_lr_multiplier, use_bias=use_bias, name='dense4')(main_branch)
    main_branch = Activation(binary_tanh, name='act4')


    human = BinaryDense(classnum_human, H=H, kernel_lr_multiplier=kernel_lr_multiplier, use_bias=use_bias, name='dense5')(main_branch)
    motion = BinaryDense(classnum_motion, H=H, kernel_lr_multiplier=kernel_lr_multiplier, use_bias=use_bias, name='dense6')(main_branch)

    model = Model(inputs = model_input, outputs = [human, motion])
    
    model.compile(optimizer=Adam(lr), 
                  loss=['categorical_crossentropy', 'categorical_crossentropy'],
                  metrics=['accuracy'])
    
    return model
