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

saved_model = '3_motion_model.h5'
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

count = 400

classnum = 3

def preprocessing(motion):
    image = np.zeros(shape=(count, rows, cols, 1))
    label = []

    for person in range(1, 5):
        cwt_data = pd.read_csv(
            DirectoryPath + date + "_" + str(person) + "_" + str(motion) + file_name)
        for i in range(0, 100):
            df = np.fromstring(cwt_data['pixels'][i], dtype=float, sep=' ')
            df = np.reshape(df, (rows, cols, 1))
            image[i + 100*(person-1)] = df
            if motion == 0:
                label.append(motion)
            else:
                label.append(motion-1)

    return image, label


def preprocessing_resize_crop(image, start_row, end_row, start_col, end_col, row_scale, col_scale):
    crop_image = image[:, 0:image.shape[1]                       :row_scale, 0:image.shape[2]:col_scale]
    crop_image = crop_image[:, start_row:end_row, start_col:end_col]
    return crop_image


def concatenate_n_div(image0, label0, image1, label1, image2, label2):
    train_ratio = 0.7
    val_ratio = 0.15
    test_ratio = 0.15 

    x_train = np.concatenate(
        (image0[0:int(count*train_ratio)], image1[0:int(count*train_ratio)], image2[0:int(count*train_ratio)]))
    y_train = np.concatenate(
        (label0[0:int(count*train_ratio)], label1[0:int(count*train_ratio)], label2[0:int(count*train_ratio)]))
    x_test = np.concatenate((image0[int(count*train_ratio):int(count*train_ratio + count*val_ratio)],
                            image1[int(count*train_ratio):int(count*train_ratio + count*val_ratio)],
                            image2[int(count*train_ratio):int(count*train_ratio + count*val_ratio)]))
    y_test = np.concatenate((label0[int(count*train_ratio):int(count*train_ratio + count*val_ratio)],
                            label1[int(count*train_ratio):int(count*train_ratio + count*val_ratio)],
                            label2[int(count*train_ratio):int(count*train_ratio + count*val_ratio)]))
    x_val = np.concatenate((image0[int(count*train_ratio + count*val_ratio): count],
                             image1[int(count*train_ratio + count*val_ratio): count],
                             image2[int(count*train_ratio + count*val_ratio): count]))
    y_val = np.concatenate((label0[int(count*train_ratio + count*val_ratio): count],
                             label1[int(count*train_ratio + count*val_ratio): count],
                             label2[int(count*train_ratio + count*val_ratio): count]))

    # train_gen = ImageDataGenerator(
    #     width_shift_range=wsr
    # )

    # augment_size = int(augment_ratio * x_train.shape[0])
    # randidx = np.random.randint(x_train.shape[0], size=augment_size)
    # x_augmented = x_train[randidx].copy()
    # y_augmented = y_train[randidx].copy()
    # x_augmented, y_augmented = train_gen.flow(
    #     x_augmented, y_augmented,  batch_size=augment_size, shuffle=False).next()
    # x_train = np.concatenate((x_train, x_augmented))
    # y_train = np.concatenate((y_train, y_augmented))

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

image1, label1 = preprocessing(0)  # motion 0 
image2, label2 = preprocessing(2)  # motion 2 
image3, label3 = preprocessing(3)  # motion 3 

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


    image1_crop = preprocessing_resize_crop(
        image1_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)
    image2_crop = preprocessing_resize_crop(
        image2_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)
    image3_crop = preprocessing_resize_crop(
        image3_shuff, start_row, end_row, start_col, end_col, scale_row, scale_col)

    x_train, y_train, x_val, y_val, x_test, y_test = concatenate_n_div(
        image1_crop, label1, image2_crop, label2, image3_crop, label3)

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
    model.predict(x_test)
    # model.evaluate(x_test, y_test)
    exc_time = time.time() - start
    print(exc_time)
    if i > 0:
        total_time = total_time + exc_time

    if i == repeat_num - 1:
        print(x_train.shape[0])
        print(x_val.shape[0])
        print(x_test.shape[0])

print("--- %s seconds ---" % (total_time))
