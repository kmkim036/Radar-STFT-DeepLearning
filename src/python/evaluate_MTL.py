import time
import tensorflow
import numpy as np
import pandas as pd
from tensorflow import keras
from tensorflow.keras.utils import to_categorical
from tensorflow.keras.models import load_model

file_name = '_stft.txt'
date = '220132'

repeat_num = 10
total_time = 0

saved_model = 'MTL.h5'
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

classnum_human = 4
classnum_motion = 3

def preprocessing(person, motion):  # person, motion에 해당하는 image 불러옴
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

def preprocessing_resize_crop(image, start_row, end_row, start_col, end_col, row_scale, col_scale):
    crop_image = image[:, 0:image.shape[1]                       :row_scale, 0:image.shape[2]:col_scale]
    crop_image = crop_image[:, start_row:end_row, start_col:end_col]
    return crop_image


def concatenate_n_div(image0, label0_1, label0_2, image1, label1_1, label1_2, image2, label2_1, label2_2, image3, label3_1, label3_2, image4, label4_1, label4_2, image5, label5_1, label5_2, image6, label6_1, label6_2, image7, label7_1, label7_2, image8, label8_1, label8_2, image9, label9_1, label9_2, image10, label10_1, label10_2, image11, label11_1, label11_2):
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
    y_train_human = np.concatenate(
        (label0_1[0:int(count*train_ratio)],
         label1_1[0:int(count*train_ratio)],
         label2_1[0:int(count*train_ratio)],
         label3_1[0:int(count*train_ratio)],
         label4_1[0:int(count*train_ratio)],
         label5_1[0:int(count*train_ratio)],
         label6_1[0:int(count*train_ratio)],
         label7_1[0:int(count*train_ratio)],
         label8_1[0:int(count*train_ratio)],
         label9_1[0:int(count*train_ratio)],
         label10_1[0:int(count*train_ratio)],
         label11_1[0:int(count*train_ratio)]))
    y_train_motion = np.concatenate(
        (label0_2[0:int(count*train_ratio)],
         label1_2[0:int(count*train_ratio)],
         label2_2[0:int(count*train_ratio)],
         label3_2[0:int(count*train_ratio)],
         label4_2[0:int(count*train_ratio)],
         label5_2[0:int(count*train_ratio)],
         label6_2[0:int(count*train_ratio)],
         label7_2[0:int(count*train_ratio)],
         label8_2[0:int(count*train_ratio)],
         label9_2[0:int(count*train_ratio)],
         label10_2[0:int(count*train_ratio)],
         label11_2[0:int(count*train_ratio)]))
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
                                  label7_1[int(
                                      count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                  label8_1[int(
                                      count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                  label9_1[int(
                                      count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                  label10_1[int(
                                      count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                  label11_1[int(count*train_ratio):int(count*train_ratio + count*val_ratio)]))
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
                                   label7_2[int(
                                       count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                   label8_2[int(
                                       count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                   label9_2[int(
                                       count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                   label10_2[int(
                                       count*train_ratio):int(count*train_ratio + count*val_ratio)],
                                   label11_2[int(count*train_ratio):int(count*train_ratio + count*val_ratio)]))
    x_test = np.concatenate((image0[int(count*train_ratio +
                                        count*val_ratio): count],
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
                                   label7_1[int(
                                       count*train_ratio + count*val_ratio): count],
                                   label8_1[int(
                                       count*train_ratio + count*val_ratio): count],
                                   label9_1[int(
                                       count*train_ratio + count*val_ratio): count],
                                   label10_1[int(
                                       count*train_ratio + count*val_ratio): count],
                                   label11_1[int(count*train_ratio + count*val_ratio): count]))
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
                                    label7_2[int(
                                        count*train_ratio + count*val_ratio): count],
                                    label8_2[int(
                                        count*train_ratio + count*val_ratio): count],
                                    label9_2[int(
                                        count*train_ratio + count*val_ratio): count],
                                    label10_2[int(
                                        count*train_ratio + count*val_ratio): count],
                                    label11_2[int(count*train_ratio + count*val_ratio): count]))

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


row_len = 36
col_len = 28

image1, label1_1, label1_2 = preprocessing(1, 0)
image2, label2_1, label2_2 = preprocessing(1, 2)
image3, label3_1, label3_2 = preprocessing(1, 3)
image4, label4_1, label4_2 = preprocessing(2, 0)
image5, label5_1, label5_2 = preprocessing(2, 2)
image6, label6_1, label6_2 = preprocessing(2, 3)
image7, label7_1, label7_2 = preprocessing(3, 0)
image8, label8_1, label8_2 = preprocessing(3, 2)
image9, label9_1, label9_2 = preprocessing(3, 3)
image10, label10_1, label10_2 = preprocessing(4, 0)
image11, label11_1, label11_2 = preprocessing(4, 2)
image12, label12_1, label12_2 = preprocessing(4, 3)

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

    x_train, y_train_human, y_train_motion, x_val, y_val_human, y_val_motion, x_test, y_test_human, y_test_motion = concatenate_n_div(
        image1_crop, label1_1, label1_2, image2_crop, label2_1, label2_2, image3_crop, label3_1, label3_2, image4_crop, label4_1, label4_2, image5_crop, label5_1, label5_2, image6_crop, label6_1, label6_2, image7_crop, label7_1, label7_2, image8_crop, label8_1, label8_2, image9_crop, label9_1, label9_2, image10_crop, label10_1, label10_2, image11_crop, label11_1, label11_2, image12_crop, label12_1, label12_2)

    maxval = x_train.max()
    if maxval < x_val.max():
        maxval = x_val.max()
    if maxval < x_test.max():
        maxval = x_test.max()

    x_test = x_test.astype('float32')/maxval

    model = load_model(saved_model)
    y_test_human = to_categorical(y_test_human, classnum_human)
    y_test_motion = to_categorical(y_test_motion, classnum_motion)

    print(str(i+1) + ': Test Start')
    start = time.time()
    model.predict(x_test)
    # model.evaluate(x_test, [y_test_human, y_test_motion])
    total_time = total_time + time.time() - start

    if i == repeat_num - 1:
        print(x_train.shape[0])
        print(x_val.shape[0])
        print(x_test.shape[0])

print("--- %s seconds ---" % (total_time))
