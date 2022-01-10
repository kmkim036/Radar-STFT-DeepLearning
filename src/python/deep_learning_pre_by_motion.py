# classify person
# pre-processing by motion

import pandas as pd
import numpy as np

from keras.utils import np_utils
from tensorflow.keras.callbacks import EarlyStopping

import deep_learning_model

classnum = 3
date = '220110'

mode = 5

if mode == 0:
    img_row = 128
    img_col = 29
    file_name = '_stft.csv'
elif mode == 1:
    img_row = 81
    img_col = 120
    file_name = '_cwt_16.csv'
elif mode == 2:
    img_row = 81
    img_col = 96
    file_name = '_cwt_20.csv'
elif mode == 3:
    img_row = 26
    img_col = 384
    file_name = '_cwt.csv'
elif mode == 4:
    img_row = 40
    img_col = 41
    file_name = '_cwt_16_40.csv'
elif mode == 5:
    img_row = 40
    img_col = 60
    file_name = '_cwt_16_60.csv'

DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-CWT-DeepLearning/'


def preprocessing_by_motion(motion):
    whole_rounds = 50
    whole_counts1 = int(whole_rounds * 0.6 * 3)
    image1 = np.zeros(shape=(whole_counts1, img_row, img_col, 1))
    label1 = []
    whole_counts2 = int(whole_rounds * 0.2 * 3)
    image2 = np.zeros(shape=(whole_counts2, img_row, img_col, 1))
    label2 = []
    whole_counts3 = int(whole_rounds * 0.2 * 3)
    image3 = np.zeros(shape=(whole_counts3, img_row, img_col, 1))
    label3 = []
    i = 0
    for person in range(0, 3):
        cwt_data = pd.read_csv(
            DirectoryPath + date + "_" + str(person) + "_" + str(motion) + file_name)
        for rounds in range(0, int(whole_rounds * 0.6)):
            df = np.fromstring(cwt_data['pixels'][rounds], dtype=int, sep=' ')
            df = np.reshape(df, (img_row, img_col, 1))
            image1[i] = df
            label1.append(person)
            i = i + 1
    i = 0
    for person in range(0, 3):
        cwt_data = pd.read_csv(
            DirectoryPath + date + "_" + str(person) + "_" + str(motion) + file_name)
        for rounds in range(int(whole_rounds * 0.6), int(whole_rounds * 0.8)):
            df = np.fromstring(cwt_data['pixels'][rounds], dtype=int, sep=' ')
            df = np.reshape(df, (img_row, img_col, 1))
            image2[i] = df
            label2.append(person)
            i = i + 1
    i = 0
    for person in range(0, 3):
        cwt_data = pd.read_csv(
            DirectoryPath + date + "_" + str(person) + "_" + str(motion) + file_name)
        for rounds in range(int(whole_rounds * 0.8), whole_rounds):
            df = np.fromstring(cwt_data['pixels'][rounds], dtype=int, sep=' ')
            df = np.reshape(df, (img_row, img_col, 1))
            image3[i] = df
            label3.append(person)
            i = i + 1

    return image1, label1, image2, label2, image3, label3


if __name__ == "__main__":
    model = deep_learning_model.create_CNNmodel(img_row, img_col, classnum)
    early_stopping = EarlyStopping(monitor='val_accuracy', patience=10)
    for i in range(0, 4):
        train_set, train_label, val_set, val_label, test_set, test_label = preprocessing_by_motion(
            i)
        print("motion index: " + str(i))
        print("train set")
        print("counts: " + str(train_set.shape[0]))
        print("labels: " + str(train_label))
        print("val set")
        print("counts: " + str(val_set.shape[0]))
        print("labels: " + str(val_label))
        print("test set")
        print("counts: " + str(test_set.shape[0]))
        print("labels: " + str(test_label))

        train_set = np.array(train_set)
        val_set = np.array(val_set)
        test_set = np.array(test_set)

        maxval = train_set.max()
        if maxval < val_set.max():
            maxval = val_set.max()
        if maxval < test_set.max():
            maxval = test_set.max()

        train_set = train_set.astype('float32')/maxval
        val_set = val_set.astype('float32')/maxval
        test_set = test_set.astype('float32')/maxval

        train_label = np_utils.to_categorical(train_label, classnum)
        val_label = np_utils.to_categorical(val_label, classnum)
        test_label = np_utils.to_categorical(test_label, classnum)

        # gen = ImageDataGenerator(
        #     width_shift_range=0.2
        # )
        # augment_ratio = 1.5   # 전체 데이터의 150%
        # augment_size = int(augment_ratio * train_set.shape[0])

        # randidx = np.random.randint(train_set.shape[0], size=augment_size)

        # x_augmented = train_set[randidx].copy()
        # y_augmented = train_label[randidx].copy()

        # x_augmented, y_augmented = gen.flow(
        #     x_augmented, y_augmented,  batch_size=augment_size, shuffle=False).next()

        # train_set = np.concatenate((train_set, x_augmented))
        # train_label = np.concatenate((train_label, y_augmented))
        # s = np.arange(train_set.shape[0])
        # np.random.shuffle(s)
        # train_set = train_set[s]
        # train_label = train_label[s]

        hist = model.fit(train_set, train_label, validation_data=(
            val_set, val_label), epochs=50, verbose=0, callbacks=[early_stopping])
        # hist = model.fit(train_set, train_label, validation_data=(val_set, val_label), epochs=50, verbose=1)

        # evaluate: evaluate
        print('Evaluate')
        score = model.evaluate(test_set, test_label)
        print('Test loss:', score[0])
        print('Test accuracy:', score[1])

        # predict: test
        # pred = model.predict(test_set)
        # if i < 2:
        #     cnts = 18
        # else:
        #     cnts = 6
        # corrects = 0
        # notcorrects = 0
        # for j in range(0, cnts):
        #     if np.argmax(test_label[j]) == np.argmax(pred[j]):
        #         corrects = corrects + 1
        #     else:
        #         notcorrects = notcorrects + 1
        #     print("No." + str(j + 1) + " data: " +
        #           str(np.argmax(test_label[j])), ", predict: " + str(np.argmax(pred[j])))
        # print("predict accuracy: " + str(corrects / cnts))
