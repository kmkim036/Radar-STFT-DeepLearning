#!/usr/bin/env python
# coding: utf-8

# In[1]:


# 한 개의 모션에 대해서만 동작
# 추출좌표를 이동하며 여러 조건을 테스트하는 것이 아닌 한 곳에서만 추출하여 결과를 계산
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
import deep_learning_model

def preprocessing(person,motion): # person, motion에 해당하는 image 불러옴
    date = '220110'
    file_name = '_cwt.txt'
#    file_name = '_cwt_1.csv'
#    file_name = '_stft.csv'
#    파일명에서 모션번호 뒤에 오는 값을 고려하여 파일명 설정
    #DirectoryPath = 'C:/Users/hojung/Documents/Anaconda_python/data/220110/'
    DirectoryPath = 'C:/Users/hojung/Documents/Anaconda_python/data/txt/'
    # 경로 설정
    whole_count = 50
    image = np.zeros(shape=(whole_count, 81, 1920, 1))
#    image = np.zeros(shape=(whole_count, 128, 29, 1))
    label = []
    cwt_data = pd.read_csv(
                DirectoryPath + date + "_" + str(person) + "_" + str(motion) + file_name)
    for i in range(0, whole_count):
        df = np.fromstring(cwt_data['pixels'][i], dtype=int, sep=' ')
        df = np.reshape(df, (81, 1920, 1))
#        df = np.reshape(df, (128, 29, 1))
        image[i] = df
        label.append(person)    # 사람으로 구분
    return image, label



# 시작과 끝 좌표는 scale한 후의 좌표를 기준으로 함
def preprocessing_resize_crop(image,start_row,end_row,start_col,end_col,row_scale,col_scale): 
    crop_image = image[:,0:image.shape[1]:row_scale,0:image.shape[2]:col_scale]
    crop_image = crop_image[:,start_row:end_row,start_col:end_col]
    return crop_image

def concatenate_n_div(image0, label0, image1, label1, image2, label2): # ratio비율로 각 data set을 합치고 순서도 섞음
    count = 50
    train_ratio = 0.6
    val_ratio = 0.2
    test_ratio = 0.2 # 적용안됨
    
    x_train = np.concatenate((image0[0:int(count*train_ratio)], image1[0:int(count*train_ratio)], image2[0:int(count*train_ratio)]))
    y_train = np.concatenate((label0[0:int(count*train_ratio)], label1[0:int(count*train_ratio)], label2[0:int(count*train_ratio)]))
    x_val = np.concatenate((image0[int(count*train_ratio) : int(count*train_ratio + count*val_ratio)],
                            image1[int(count*train_ratio) : int(count*train_ratio + count*val_ratio)],
                            image2[int(count*train_ratio) : int(count*train_ratio + count*val_ratio)]))
    y_val = np.concatenate((label0[int(count*train_ratio) : int(count*train_ratio + count*val_ratio)],
                            label1[int(count*train_ratio) : int(count*train_ratio + count*val_ratio)],
                            label2[int(count*train_ratio) : int(count*train_ratio + count*val_ratio)]))
    x_test = np.concatenate((image0[int(count*train_ratio + count*val_ratio) : count],
                             image1[int(count*train_ratio + count*val_ratio) : count],
                             image2[int(count*train_ratio + count*val_ratio) : count]))
    y_test = np.concatenate((label0[int(count*train_ratio + count*val_ratio) : count],
                             label1[int(count*train_ratio + count*val_ratio) : count],
                             label2[int(count*train_ratio + count*val_ratio) : count]))
    
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


# In[2]:


# STFT = (128, 29) //  CWT = (81,1920)
# 이미지 크기를 시작좌표와 끝좌표로 설정, 고정된 위치에서 추출한 이미지를 사용한 결과를 확인
# 추출하는 좌표가 변하지않으므로 동작시간이 비교적 매우 짧다.

start_row = 0   # row 전체 범위 설정
end_row = 40   
scale_row = 1  # 몇칸마다 추출하는지
# 위 조건은 row : 0~40좌표에 해당하는 이미지를 사용

start_col = 70    # col 전체 범위 설정
end_col = 150
scale_col = 8  # 몇칸마다 추출하는지
# 위 조건은 col : 70~150 좌표에 해당하는 이미지를 사용

classnum = 3     # class 개수

motion = 0      # 모션 번호
try_num = 10   # 같은 조건에서 몇번 반복할지

row_len = math.ceil((end_row - start_row))
col_len = math.ceil((end_col - start_col))


image0,label0 = preprocessing(0,motion) # 경민_motion 불러옴
image1,label1 = preprocessing(1,motion) # 성진_motion 불러옴
image2,label2 = preprocessing(2,motion) # 호정_motion 불러옴

# 정규화 테스트중
#maxval = image0.max()
#image0 = image0.astype('float32')/maxval
#maxval = image1.max()
#image1 = image1.astype('float32')/maxval
#maxval = image2.max()
#image2 = image2.astype('float32')/maxval


result_acc = 0
for i in range(try_num):    # 5회 실행 -> 평균 계산위해
    s = np.arange(image0.shape[0])
    np.random.shuffle(s)
    image0_shuff = image0[s]       # 불러온 경민_motion data의 순서를 섞음

    s = np.arange(image1.shape[0])
    np.random.shuffle(s)
    image1_shuff = image1[s]       # 불러온 성진_motion data의 순서를 섞음

    s = np.arange(image2.shape[0])
    np.random.shuffle(s)
    image2_shuff = image2[s]       # 불러온 호정_motion data의 순서를 섞음

    image0_crop = preprocessing_resize_crop(image0_shuff, start_row , end_row, start_col, end_col, scale_row, scale_col)
    image1_crop = preprocessing_resize_crop(image1_shuff, start_row , end_row, start_col, end_col, scale_row, scale_col)
    image2_crop = preprocessing_resize_crop(image2_shuff, start_row , end_row, start_col, end_col, scale_row, scale_col)
    # 크기에 맞게 자름

    x_train, y_train, x_val, y_val, x_test, y_test = concatenate_n_div(image0_crop,label0,image1_crop,label1,image2_crop,label2)
    # 자른 image를 각 data set으로 나눠서 합침

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
    model = deep_learning_model.create_CNNmodel(row_len, col_len, classnum)
    early_stopping = EarlyStopping(monitor='val_accuracy', patience=10)
    y_train = np_utils.to_categorical(y_train, classnum)
    y_val = np_utils.to_categorical(y_val, classnum)
    y_test = np_utils.to_categorical(y_test, classnum)
    # CNN 훈련
    hist = model.fit(x_train, y_train, validation_data=(
        x_val, y_val), epochs=50, callbacks=[early_stopping],verbose = 2,batch_size = 20)

    # 평가
    print('Evaluate')
    score = model.evaluate(x_test, y_test)
    print('Test loss:', score[0])
    print('Test accuracy:', score[1])
    result_acc = result_acc + score[1]    # 정확도 결과 저장하여 평균값 내는데 사용
print('image size :',str(row_len)+'X'+str(col_len),'   row =',str(start_row)+' : '+str(end_row),'   col =',str(start_col)+' : '+str(end_col),
      '   round :',try_num,'//  average_acc :', result_acc / try_num)

