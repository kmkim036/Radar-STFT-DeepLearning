import time
import tensorflow
import numpy as np
import pandas as pd
from tensorflow import keras
from tensorflow.keras.utils import to_categorical
from tensorflow.keras.models import load_model

file_name = '_stft.txt'
date = '220133'

repeat_num = 11
total_time = 0

saved_model = '6_all_in_one.h5'
# DirectoryPath = '/home/pi/Projects/git/Radar-STFT-DeepLearning/h5/'
DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-STFT-DeepLearning/h5/'
saved_model = DirectoryPath + saved_model

# DirectoryPath = '/home/pi/Projects/git/Radar-STFT-DeepLearning/txt/'
DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-STFT-DeepLearning/txt/'

start_row = 46
end_row = 82
scale_row = 1
rows = 128

start_col = 1
end_col = 29
scale_col = 1
cols = 29

count = 100

classnum = 12

def preprocessing(person, motion):  # person, motion에 해당하는 image 불러옴
    image = np.zeros(shape=(count, rows, cols, 1))
    label = []

    cwt_data = pd.read_csv(
        DirectoryPath + date + "_" + str(person) + "_" + str(motion) + file_name)
    for i in range(0, 100):
        df = np.fromstring(cwt_data['pixels'][i], dtype=float, sep=' ')
        df = np.reshape(df, (rows, cols, 1))
        image[i] = df
        if motion == 0:
            label.append(3 * (person - 1) + motion)
        else:
            label.append(3 * (person - 1) + motion - 1)

    return image, label


def preprocessing_resize_crop(image, start_row, end_row, start_col, end_col, row_scale, col_scale):
    crop_image = image[:, 0:image.shape[1]                       :row_scale, 0:image.shape[2]:col_scale]
    crop_image = crop_image[:, start_row:end_row, start_col:end_col]
    return crop_image


def concatenate_n_div(image0, label0, image1, label1, image2, label2, image3, label3, image4, label4, image5, label5, image6, label6, image7, label7, image8, label8, image9, label9, image10, label10, image11, label11):
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
         image7[0:int(count*train_ratio)],
         image8[0:int(count*train_ratio)],
         image9[0:int(count*train_ratio)],
         image10[0:int(count*train_ratio)],
         image11[0:int(count*train_ratio)]))
    y_train = np.concatenate(
        (label0[0:int(count*train_ratio)],
         label1[0:int(count*train_ratio)],
         label2[0:int(count*train_ratio)],
         label3[0:int(count*train_ratio)],
         label4[0:int(count*train_ratio)],
         label5[0:int(count*train_ratio)],
         label6[0:int(count*train_ratio)],
         label7[0:int(count*train_ratio)],
         label8[0:int(count*train_ratio)],
         label9[0:int(count*train_ratio)],
         label10[0:int(count*train_ratio)],
         label11[0:int(count*train_ratio)]))
    x_val = np.concatenate((image0[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
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
                            image7[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            image8[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            image9[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            image10[int(count*train_ratio):int(count *
                                                               train_ratio + count*val_ratio)],
                            image11[int(count*train_ratio):int(count *
                                                               train_ratio + count*val_ratio)]))
    y_val = np.concatenate((label0[int(count*train_ratio):int(count*train_ratio + count*val_ratio)],
                            label1[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            label2[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            label3[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            label4[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            label5[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            label6[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            label7[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            label8[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            label9[int(count*train_ratio):int(count *
                                                              train_ratio + count*val_ratio)],
                            label10[int(count*train_ratio):int(count *
                                                               train_ratio + count*val_ratio)],
                            label11[int(count*train_ratio):int(count *
                                                               train_ratio + count*val_ratio)]))
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
                             image7[int(count*train_ratio +
                                        count*val_ratio): count],
                             image8[int(count*train_ratio +
                                        count*val_ratio): count],
                             image9[int(count*train_ratio +
                                        count*val_ratio): count],
                             image10[int(count*train_ratio +
                                         count*val_ratio): count],
                             image11[int(count*train_ratio +
                                         count*val_ratio): count]))
    y_test = np.concatenate((label0[int(count*train_ratio + count*val_ratio): count],
                             label1[int(count*train_ratio +
                                        count*val_ratio): count],
                             label2[int(count*train_ratio +
                                        count*val_ratio): count],
                             label3[int(count*train_ratio +
                                        count*val_ratio): count],
                             label4[int(count*train_ratio +
                                        count*val_ratio): count],
                             label5[int(count*train_ratio +
                                        count*val_ratio): count],
                             label6[int(count*train_ratio +
                                        count*val_ratio): count],
                             label7[int(count*train_ratio +
                                        count*val_ratio): count],
                             label8[int(count*train_ratio +
                                        count*val_ratio): count],
                             label9[int(count*train_ratio +
                                        count*val_ratio): count],
                             label10[int(count*train_ratio +
                                         count*val_ratio): count],
                             label11[int(count*train_ratio +
                                         count*val_ratio): count]))

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


row_len = 36
col_len = 28

image1, label1 = preprocessing(1, 0)
image2, label2 = preprocessing(1, 2)
image3, label3 = preprocessing(1, 3)
image4, label4 = preprocessing(2, 0)
image5, label5 = preprocessing(2, 2)
image6, label6 = preprocessing(2, 3)
image7, label7 = preprocessing(3, 0)
image8, label8 = preprocessing(3, 2)
image9, label9 = preprocessing(3, 3)
image10, label10 = preprocessing(4, 0)
image11, label11 = preprocessing(4, 2)
image12, label12 = preprocessing(4, 3) 

for i in range(repeat_num):
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

    s = np.arange(image9.shape[0])
    np.random.shuffle(s)
    image9_shuff = image9[s]

    s = np.arange(image10.shape[0])
    np.random.shuffle(s)
    image10_shuff = image10[s]

    s = np.arange(image11.shape[0])
    np.random.shuffle(s)
    image11_shuff = image11[s]

    s = np.arange(image12.shape[0])
    np.random.shuffle(s)
    image12_shuff = image12[s]

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
    image9_crop = preprocessing_resize_crop(
        image9_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)
    image10_crop = preprocessing_resize_crop(
        image10_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)
    image11_crop = preprocessing_resize_crop(
        image11_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)
    image12_crop = preprocessing_resize_crop(
        image12_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)

    x_train, y_train, x_val, y_val, x_test, y_test = concatenate_n_div(
        image1_crop, label1, image2_crop, label2, image3_crop, label3, image4_crop, label4, image5_crop, label5, image6_crop, label6, image7_crop, label7, image8_crop, label8, image9_crop, label9, image10_crop, label10, image11_crop, label11, image12_crop, label12)

    maxval = x_train.max()
    if maxval < x_val.max():
        maxval = x_val.max()
    if maxval < x_test.max():
        maxval = x_test.max()

    x_test = x_test.astype('float32')/maxval

    model = load_model(saved_model)
    y_test = to_categorical(y_test, classnum)

    print(str(i+1) + ': Test Start')
    start = time.time()
    # model.evaluate(x_test, y_test)
    predict_level = model.predict(x_test)
    exc_time = time.time() - start
    print(exc_time)
    if i > 0:
        total_time = total_time + exc_time

    # predict_level = np.argmax(predict_level, axis=1)

    if i == repeat_num - 1:
        print(x_train.shape[0])
        print(x_val.shape[0])
        print(x_test.shape[0])

print("--- %s seconds ---" % (total_time))
