# Function: CNN example with CIFAR-10 dataset
# Link: https://blog.naver.com/agapeuni/222541216722


# import packagesimport sys
import tensorflow as tf
import keras
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten
from keras.layers.convolutional import Conv2D, MaxPooling2D
from keras.utils import np_utils
import numpy as np

# load CIFAR-10 dataset
(x_train, y_train), (x_test, y_test) = keras.datasets.cifar10.load_data()
# x = raw data
# y = label of x

# normalize
x_train = x_train / 255.0
x_test = x_test / 255.0

# design CNN model structure
model = Sequential()
model.add(Conv2D(32, kernel_size=(3, 3),
          activation='relu', input_shape=(32, 32, 3)))
model.add(MaxPooling2D(2, 2))
model.add(Dropout(0.2))
model.add(Conv2D(64, kernel_size=(3, 3), activation='relu'))
model.add(MaxPooling2D(2, 2))
model.add(Conv2D(64, kernel_size=(3, 3), activation='relu'))
model.add(Dropout(0.2))
model.add(Flatten())
model.add(Dense(64, activation='relu'))
model.add(Dense(10, activation='softmax'))
model.compile(loss='sparse_categorical_crossentropy',
              optimizer='adam', metrics='accuracy')

# print the info of CNN model
model.summary()

# fit: learning
hist = model.fit(x_train, y_train, epochs=3)

# evaluate: evaluate
score = model.evaluate(x_test, y_test)
print('Test loss:', score[0])
print('Test accuracy:', score[1])

# set test data
test_batch = x_test[:2]

# predict: test
pred = model.predict(test_batch)
print("1st data:", y_test[0])
print("1st predict: ", np.argmax(pred[0]))
print("2nd data:", y_test[1])
print("2nd predict: ", np.argmax(pred[1]))
