# classify motion

import tensorflow as tf
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import math
from tensorflow.keras.layers import Dense, Flatten, BatchNormalization
from tensorflow.keras.models import Sequential
from tensorflow.keras.optimizers import Adam
from tensorflow import keras
from tensorflow.keras.callbacks import EarlyStopping
from keras.utils import np_utils
from tensorflow.keras.preprocessing.image import ImageDataGenerator

from sklearn.metrics import classification_report, confusion_matrix
import seaborn as sns

import deep_learning_model

menu = 1

augment_ratio = 9

classnum = 3     # class 개수

try_num = 10   # 같은 조건에서 몇번 반복할지

date = '220132'

count = 400

lr = 0.001
bs = 64
wsr = 0.15

test_label = np.zeros(classnum).reshape(1, classnum)
predict_label = np.zeros(classnum).reshape(1, classnum)

if menu == 1:
    file_name = '_stft.txt'

    start_row = 0
    end_row = 128
    scale_row = 1
    rows = 128

    start_col = 0
    end_col = 29
    scale_col = 1
    cols = 29
elif menu == 2:
    file_name = '_cwt.txt'

    start_row = 0
    end_row = 40
    scale_row = 1
    rows = 81

    start_col = 0
    end_col = 96
    scale_col = 20
    cols = 1920


def preprocessing(motion):
    DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-CWT-DeepLearning/txt/'
    image = np.zeros(shape=(count, rows, cols, 1))
    label = []

    for person in range(1, 5):
        cwt_data = pd.read_csv(
            DirectoryPath + date + "_" + str(person) + "_" + str(motion) + file_name)
        for i in range(0, 100):
            df = np.fromstring(cwt_data['pixels'][i], dtype=int, sep=' ')
            df = np.reshape(df, (rows, cols, 1))
            image[i + 100*(person-1)] = df
            if motion == 0:
                label.append(motion)
            else:
                label.append(motion-1)

    return image, label

# 시작과 끝 좌표는 scale한 후의 좌표를 기준으로 함


def preprocessing_resize_crop(image, start_row, end_row, start_col, end_col, row_scale, col_scale):
    crop_image = image[:, 0:image.shape[1]                       :row_scale, 0:image.shape[2]:col_scale]
    crop_image = crop_image[:, start_row:end_row, start_col:end_col]
    return crop_image


# ratio비율로 각 data set을 합치고 순서도 섞음
def concatenate_n_div(image0, label0, image1, label1, image2, label2):
    train_ratio = 0.7
    val_ratio = 0.15
    test_ratio = 0.15  # 적용안됨

    x_train = np.concatenate(
        (image0[0:int(count*train_ratio)], image1[0:int(count*train_ratio)], image2[0:int(count*train_ratio)]))
    y_train = np.concatenate(
        (label0[0:int(count*train_ratio)], label1[0:int(count*train_ratio)], label2[0:int(count*train_ratio)]))
    x_val = np.concatenate((image0[int(count*train_ratio):int(count*train_ratio + count*val_ratio)],
                            image1[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            image2[int(count*train_ratio):int(count*train_ratio + count*val_ratio)]))
    y_val = np.concatenate((label0[int(count*train_ratio):int(count*train_ratio + count*val_ratio)],
                            label1[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            label2[int(count*train_ratio):int(count*train_ratio + count*val_ratio)]))
    x_test = np.concatenate((image0[int(count*train_ratio + count*val_ratio): count],
                             image1[int(count*train_ratio +
                                        count*val_ratio): count],
                             image2[int(count*train_ratio + count*val_ratio): count]))
    y_test = np.concatenate((label0[int(count*train_ratio + count*val_ratio): count],
                             label1[int(count*train_ratio +
                                        count*val_ratio): count],
                             label2[int(count*train_ratio + count*val_ratio): count]))

    train_gen = ImageDataGenerator(
        width_shift_range=wsr
    )

    augment_size = int(augment_ratio * x_train.shape[0])
    randidx = np.random.randint(x_train.shape[0], size=augment_size)
    x_augmented = x_train[randidx].copy()
    y_augmented = y_train[randidx].copy()
    x_augmented, y_augmented = train_gen.flow(
        x_augmented, y_augmented,  batch_size=augment_size, shuffle=False).next()
    x_train = np.concatenate((x_train, x_augmented))
    y_train = np.concatenate((y_train, y_augmented))

    s = np.arange(x_train.shape[0])
    np.random.shuffle(s)
    x_train = x_train[s]
    y_train = y_train[s]

    s = np.arange(x_val.shape[0])
    np.random.shuffle(s)
    x_val = x_val[s]
    y_val = y_val[s]

    s = np.arange(x_test.shape[0])
    np.random.shuffle(s)
    x_test = x_test[s]
    y_test = y_test[s]

    return x_train, y_train, x_val, y_val, x_test, y_test


row_len = math.ceil((end_row - start_row))
col_len = math.ceil((end_col - start_col))

image1, label1 = preprocessing(0)  # motion 0 불러옴
image2, label2 = preprocessing(2)  # motion 2 불러옴
image3, label3 = preprocessing(3)  # motion 3 불러옴

result_acc = 0
for i in range(try_num):
    print(str(i + 1) + ' repeat')

    # 순서를 섞음
    s = np.arange(image1.shape[0])
    np.random.shuffle(s)
    image1_shuff = image1[s]

    s = np.arange(image2.shape[0])
    np.random.shuffle(s)
    image2_shuff = image2[s]

    s = np.arange(image3.shape[0])
    np.random.shuffle(s)
    image3_shuff = image3[s]

    # 크기에 맞게 자름
    image1_crop = preprocessing_resize_crop(
        image1_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)
    image2_crop = preprocessing_resize_crop(
        image2_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)
    image3_crop = preprocessing_resize_crop(
        image3_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)

    # 자른 image를 각 data set으로 나눠서 합침
    x_train, y_train, x_val, y_val, x_test, y_test = concatenate_n_div(
        image1_crop, label1, image2_crop, label2, image3_crop, label3)

    maxval = x_train.max()
    if maxval < x_val.max():
        maxval = x_val.max()
    if maxval < x_test.max():
        maxval = x_test.max()

    # 정규화
    x_train = x_train.astype('float32')/maxval
    x_val = x_val.astype('float32')/maxval
    x_test = x_test.astype('float32')/maxval

    # CNN model
    model = deep_learning_model.create_CNNmodel(lr, row_len, col_len, classnum)
    early_stopping = EarlyStopping(monitor='val_accuracy', patience=10)
    y_train = np_utils.to_categorical(y_train, classnum)
    y_val = np_utils.to_categorical(y_val, classnum)
    y_test = np_utils.to_categorical(y_test, classnum)

    # CNN 훈련
    hist = model.fit(x_train, y_train, validation_data=(
        x_val, y_val), epochs=50, callbacks=[early_stopping], verbose=2, batch_size=bs)

    # 평가
    # print('Evaluate')
    score = model.evaluate(x_test, y_test)
    # print('Test loss:', score[0])
    # print('Test accuracy:', score[1])
    result_acc = result_acc + score[1]    # 정확도 결과 저장하여 평균값 내는데 사용

    test_label = np.concatenate((test_label, y_test))
    pred = model.predict(x_test)
    predict_label = np.concatenate((predict_label, pred))

print('image size :', str(row_len)+'X'+str(col_len), '   row =', str(start_row)+' : '+str(end_row), '   col =', str(start_col)+' : '+str(end_col),
      '   round :', try_num, '//  average_acc :', result_acc / try_num)

test_label = np.delete(test_label, 0, axis=0)
predict_label = np.delete(predict_label, 0, axis=0)
sns.set(style='white')
plt.figure(figsize=(classnum, classnum))
cm = confusion_matrix(np.argmax(test_label[:int(test_label.shape[0])], axis=1),
                      np.argmax(predict_label[:int(predict_label.shape[0])], axis=-1))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues')
plt.title('Classify Motion')
plt.xlabel('Predicted Label')
plt.ylabel('True Label')
plt.show()
