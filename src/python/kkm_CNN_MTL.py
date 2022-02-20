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
from keras.utils.vis_utils import plot_model

from sklearn.metrics import classification_report, confusion_matrix
import seaborn as sns

import deep_learning_model_MTL

menu = 1

modeltype =1 

augment_ratio = 9

try_num = 10   # 같은 조건에서 몇번 반복할지

date = '220132'

count = 100

lr = 0.001
bs = 64
wsr = 0.15

test_label_human = np.zeros(4).reshape(1, 4)
predict_label_human = np.zeros(4).reshape(1, 4)

test_label_motion = np.zeros(2).reshape(1, 2)
predict_label_motion = np.zeros(2).reshape(1, 2)

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


def preprocessing(person, motion):  # person, motion에 해당하는 image 불러옴
    DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-CWT-DeepLearning/txt/'
    image = np.zeros(shape=(count, rows, cols, 1))
    label1 = []
    label2 = []

    cwt_data = pd.read_csv(
        DirectoryPath + date + "_" + str(person) + "_" + str(motion) + file_name)
    for i in range(0, 100):
        df = np.fromstring(cwt_data['pixels'][i], dtype=int, sep=' ')
        df = np.reshape(df, (rows, cols, 1))
        image[i] = df
        label1.append(person - 1)
        if motion == 0:
            label2.append(motion)
        else:
            label2.append(motion - 1)

    return image, label1, label2


# 시작과 끝 좌표는 scale한 후의 좌표를 기준으로 함
def preprocessing_resize_crop(image, start_row, end_row, start_col, end_col, row_scale, col_scale):
    crop_image = image[:, 0:image.shape[1]:row_scale, 0:image.shape[2]:col_scale]
    crop_image = crop_image[:, start_row:end_row, start_col:end_col]
    return crop_image


# ratio비율로 각 data set을 합치고 순서도 섞음
def concatenate_n_div(image0, label0_1, label0_2, image1, label1_1, label1_2, image2, label2_1, label2_2, image3, label3_1, label3_2, image4, label4_1, label4_2, image5, label5_1, label5_2, image6, label6_1, label6_2, image7, label7_1, label7_2):
    train_ratio = 0.7
    val_ratio = 0.15
    test_ratio = 0.15  # 적용안됨

    x_train = np.concatenate(
        (image0[0:int(count*train_ratio)],
         image1[0:int(count*train_ratio)],
         image2[0:int(count*train_ratio)],
         image3[0:int(count*train_ratio)],
         image4[0:int(count*train_ratio)],
         image5[0:int(count*train_ratio)],
         image6[0:int(count*train_ratio)],
         image7[0:int(count*train_ratio)]))
    y_train_human = np.concatenate(
        (label0_1[0:int(count*train_ratio)],
         label1_1[0:int(count*train_ratio)],
         label2_1[0:int(count*train_ratio)],
         label3_1[0:int(count*train_ratio)],
         label4_1[0:int(count*train_ratio)],
         label5_1[0:int(count*train_ratio)],
         label6_1[0:int(count*train_ratio)],
         label7_1[0:int(count*train_ratio)]))
    y_train_motion = np.concatenate(
        (label0_2[0:int(count*train_ratio)],
         label1_2[0:int(count*train_ratio)],
         label2_2[0:int(count*train_ratio)],
         label3_2[0:int(count*train_ratio)],
         label4_2[0:int(count*train_ratio)],
         label5_2[0:int(count*train_ratio)],
         label6_2[0:int(count*train_ratio)],
         label7_2[0:int(count*train_ratio)]))
    x_val = np.concatenate((image0[int(count*train_ratio):int(count*train_ratio + count*val_ratio)],
                            image1[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            image2[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            image3[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            image4[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            image5[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            image6[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            image7[int(count*train_ratio):int(count*train_ratio + count*val_ratio)]))
    y_val_human = np.concatenate((label0_1[int(count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                  label1_1[int(
                                      count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                  label2_1[int(
                                      count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                  label3_1[int(
                                      count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                  label4_1[int(
                                      count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                  label5_1[int(
                                      count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                  label6_1[int(
                                      count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                  label7_1[int(count*train_ratio):int(count*train_ratio + count*val_ratio)]))
    y_val_motion = np.concatenate((label0_2[int(count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                   label1_2[int(
                                       count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                   label2_2[int(
                                       count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                   label3_2[int(
                                       count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                   label4_2[int(
                                       count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                   label5_2[int(
                                       count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                   label6_2[int(
                                       count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                   label7_2[int(count*train_ratio):int(count*train_ratio + count*val_ratio)]))
    x_test = np.concatenate((image0[int(count*train_ratio + count*val_ratio): count],
                             image1[int(count*train_ratio +
                                        count*val_ratio): count],
                             image2[int(count*train_ratio +
                                        count*val_ratio): count],
                             image3[int(count*train_ratio +
                                        count*val_ratio): count],
                             image4[int(count*train_ratio +
                                        count*val_ratio): count],
                             image5[int(count*train_ratio +
                                        count*val_ratio): count],
                             image6[int(count*train_ratio +
                                        count*val_ratio): count],
                             image7[int(count*train_ratio + count*val_ratio): count]))
    y_test_human = np.concatenate((label0_1[int(count*train_ratio + count*val_ratio): count],
                                   label1_1[int(
                                       count*train_ratio + count*val_ratio): count],
                                   label2_1[int(
                                       count*train_ratio + count*val_ratio): count],
                                   label3_1[int(
                                       count*train_ratio + count*val_ratio): count],
                                   label4_1[int(
                                       count*train_ratio + count*val_ratio): count],
                                   label5_1[int(
                                       count*train_ratio + count*val_ratio): count],
                                   label6_1[int(
                                       count*train_ratio + count*val_ratio): count],
                                   label7_1[int(count*train_ratio + count*val_ratio): count]))
    y_test_motion = np.concatenate((label0_2[int(count*train_ratio + count*val_ratio): count],
                                    label1_2[int(
                                        count*train_ratio + count*val_ratio): count],
                                    label2_2[int(
                                        count*train_ratio + count*val_ratio): count],
                                    label3_2[int(
                                        count*train_ratio + count*val_ratio): count],
                                    label4_2[int(
                                        count*train_ratio + count*val_ratio): count],
                                    label5_2[int(
                                        count*train_ratio + count*val_ratio): count],
                                    label6_2[int(
                                        count*train_ratio + count*val_ratio): count],
                                    label7_2[int(count*train_ratio + count*val_ratio): count]))

    train_gen = ImageDataGenerator(
        width_shift_range=wsr
    )
    augment_size = int(augment_ratio * x_train.shape[0])
    randidx = np.random.randint(x_train.shape[0], size=augment_size)
    x_augmented = x_train[randidx].copy()
    y_augmented_human = y_train_human[randidx].copy()
    y_augmented_motion = y_train_motion[randidx].copy()
    x_augmented, y_augmented_human = train_gen.flow(
        x_augmented, y_augmented_human, batch_size=augment_size, shuffle=False).next()
    x_augmented, y_augmented_motion = train_gen.flow(
        x_augmented, y_augmented_motion, batch_size=augment_size, shuffle=False).next()
    x_train = np.concatenate((x_train, x_augmented))
    y_train_human = np.concatenate((y_train_human, y_augmented_human))
    y_train_motion = np.concatenate((y_train_motion, y_augmented_motion))

    s = np.arange(x_train.shape[0])
    np.random.shuffle(s)
    x_train = x_train[s]
    y_train_human = y_train_human[s]
    y_train_motion = y_train_motion[s]

    s = np.arange(x_val.shape[0])
    np.random.shuffle(s)
    x_val = x_val[s]
    y_val_human = y_val_human[s]
    y_val_motion = y_val_motion[s]

    s = np.arange(x_test.shape[0])
    np.random.shuffle(s)
    x_test = x_test[s]
    y_test_human = y_test_human[s]
    y_test_motion = y_test_motion[s]

    return x_train, y_train_human, y_train_motion, x_val, y_val_human, y_val_motion, x_test, y_test_human, y_test_motion


row_len = math.ceil((end_row - start_row))
col_len = math.ceil((end_col - start_col))

image1, label1_1, label1_2 = preprocessing(1, 0)
image2, label2_1, label2_2 = preprocessing(1, 2)
image3, label3_1, label3_2 = preprocessing(2, 0)
image4, label4_1, label4_2 = preprocessing(2, 2)
image5, label5_1, label5_2 = preprocessing(3, 0)
image6, label6_1, label6_2 = preprocessing(3, 2)
image7, label7_1, label7_2 = preprocessing(4, 0)
image8, label8_1, label8_2 = preprocessing(4, 2)

result_acc_1 = 0
result_acc_2 = 0
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

    s = np.arange(image4.shape[0])
    np.random.shuffle(s)
    image4_shuff = image4[s]

    s = np.arange(image5.shape[0])
    np.random.shuffle(s)
    image5_shuff = image5[s]

    s = np.arange(image6.shape[0])
    np.random.shuffle(s)
    image6_shuff = image6[s]

    s = np.arange(image7.shape[0])
    np.random.shuffle(s)
    image7_shuff = image7[s]

    s = np.arange(image8.shape[0])
    np.random.shuffle(s)
    image8_shuff = image8[s]

    # 크기에 맞게 자름
    image1_crop = preprocessing_resize_crop(
        image1_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)
    image2_crop = preprocessing_resize_crop(
        image2_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)
    image3_crop = preprocessing_resize_crop(
        image3_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)
    image4_crop = preprocessing_resize_crop(
        image4_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)
    image5_crop = preprocessing_resize_crop(
        image5_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)
    image6_crop = preprocessing_resize_crop(
        image6_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)
    image7_crop = preprocessing_resize_crop(
        image7_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)
    image8_crop = preprocessing_resize_crop(
        image8_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)

    # 자른 image를 각 data set으로 나눠서 합침
    x_train, y_train_human, y_train_motion, x_val, y_val_human, y_val_motion, x_test, y_test_human, y_test_motion = concatenate_n_div(
        image1_crop, label1_1, label1_2, image2_crop, label2_1, label2_2, image3_crop, label3_1, label3_2, image4_crop, label4_1, label4_2, image5_crop, label5_1, label5_2, image6_crop, label6_1, label6_2, image7_crop, label7_1, label7_2, image8_crop, label8_1, label8_2)

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
    model = deep_learning_model_MTL.create_CNNmodel(modeltype, lr, row_len, col_len)

    if i == 0:
        print(x_train.shape[0])
        print(x_val.shape[0])
        print(x_test.shape[0])
        print(model.summary())
        plot_model(model, to_file='MTL_model_' + str(modeltype) + '.png', show_shapes=True)

    early_stopping = EarlyStopping(
        monitor='val_human_output_accuracy', patience=10)
    y_train_human = np_utils.to_categorical(y_train_human, 4)
    y_train_motion = np_utils.to_categorical(y_train_motion, 2)
    y_val_human = np_utils.to_categorical(y_val_human, 4)
    y_val_motion = np_utils.to_categorical(y_val_motion, 2)
    y_test_human = np_utils.to_categorical(y_test_human, 4)
    y_test_motion = np_utils.to_categorical(y_test_motion, 2)
    hist = model.fit({'main_input': x_train}, {'human_output': y_train_human, 'motion_output': y_train_motion},
                     validation_data=(x_val, [y_val_human, y_val_motion]), epochs=50, verbose=0, callbacks=[early_stopping], batch_size=bs)

    # 평가
    # print('Evaluate')
    score = model.evaluate(x_test, [y_test_human, y_test_motion])
    result_acc_1 = result_acc_1 + score[3]    # 정확도 결과 저장하여 평균값 내는데 사용
    result_acc_2 = result_acc_2 + score[4]    # 정확도 결과 저장하여 평균값 내는데 사용

    test_label_human = np.concatenate((test_label_human, y_test_human))
    test_label_motion = np.concatenate((test_label_motion, y_test_motion))
    pred = model.predict(x_test)
    predict_label_human = np.concatenate((predict_label_human, pred[0]))
    predict_label_motion = np.concatenate((predict_label_motion, pred[1]))

print('image size :', str(row_len)+'X'+str(col_len), '   row =', str(start_row)+' : '+str(end_row), '   col =', str(start_col)+' : '+str(end_col),
      '   round :', try_num, '//  average_acc_human :', result_acc_1 / try_num, 'average_acc_motion :', result_acc_2 / try_num)

test_label_human = np.delete(test_label_human, 0, axis=0)
test_label_motion = np.delete(test_label_motion, 0, axis=0)
predict_label_human = np.delete(predict_label_human, 0, axis=0)
predict_label_motion = np.delete(predict_label_motion, 0, axis=0)

sns.set(style='white')
plt.figure(figsize=(4, 4))
cm = confusion_matrix(np.argmax(test_label_human[:int(test_label_human.shape[0])], axis=1),
                      np.argmax(predict_label_human[:int(predict_label_human.shape[0])], axis=-1))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues')
plt.xlabel('Predicted Label')
plt.ylabel('True Label')
plt.show()

sns.set(style='white')
plt.figure(figsize=(2, 2))
cm = confusion_matrix(np.argmax(test_label_motion[:int(test_label_motion.shape[0])], axis=1),
                      np.argmax(predict_label_motion[:int(predict_label_motion.shape[0])], axis=-1))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues')
plt.xlabel('Predicted Label')
plt.ylabel('True Label')
plt.show()
