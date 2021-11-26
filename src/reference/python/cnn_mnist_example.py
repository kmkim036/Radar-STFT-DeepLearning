# Function: CNN example with MNIST dataset
# Link: https://keeper.tistory.com/6


# import packages
import sys
import tensorflow as tf
import keras
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten
from keras.layers.convolutional import Conv2D, MaxPooling2D
from keras.utils import np_utils
import numpy as np

# load MNIST dataset
(x_train, y_train), (x_test, y_test) = keras.datasets.mnist.load_data()
# x = raw data
# y = label of x

# variable for input data matirx size
img_rows = 28
img_cols = 28
input_shape = (img_rows, img_cols, 1)

# reshape input data into fixed matrix size
x_train = x_train.reshape(x_train.shape[0], img_rows, img_cols, 1)
x_test = x_test.reshape(x_test.shape[0], img_rows, img_cols, 1)

# normalize
x_train = x_train.astype('float32') / 255.
x_test = x_test.astype('float32') / 255.

# print the number of train sample and test sample
print('x_train shape:', x_train.shape)
print(x_train.shape[0], 'train samples')
print(x_test.shape[0], 'test samples')

# the number of final class (0, 1, 2, ... 8, 9)
num_classes = 10

# make y data into one hot vector
y_train = np_utils.to_categorical(y_train, num_classes)
y_test = np_utils.to_categorical(y_test, num_classes)

# design CNN model structure
model = Sequential()
model.add(Conv2D(32, kernel_size=(5, 5), strides=(1, 1),
          padding='same', activation='relu', input_shape=input_shape))
model.add(MaxPooling2D(pool_size=(2, 2), strides=(2, 2)))
model.add(Conv2D(64, (2, 2), activation='relu', padding='same'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))
model.add(Flatten())
model.add(Dense(1000, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(10, activation='softmax'))
model.compile(loss='categorical_crossentropy',
              optimizer='adam', metrics=['accuracy'])

# print the info of CNN model
model.summary()

# fit: learning
hist = model.fit(x_train, y_train, batch_size=128, epochs=1,
                 verbose=1, validation_data=(x_test, y_test))

# evaluate: evaluate
score = model.evaluate(x_test, y_test, verbose=0)
print('Test loss:', score[0])
print('Test accuracy:', score[1])

# predict: test
pred = model.predict(x_test)
print("data = ", np.argmax(y_test[:10], axis=1))
print("predicts = ", np.argmax(pred[:10], axis=1))
