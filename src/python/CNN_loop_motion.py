#!/usr/bin/env python
# coding: utf-8

# 4가지 모든 동작에 대해 추출위치 움직이며 동작

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
#=========================================================================
#==========================파일 경로 설정 및 원본 이미지 사이즈 설정====================
#=========================================================================
def preprocessing(person,motion): # person, motion에 해당하는 image 불러옴
    date = '220110'
    file_name = '_cwt_1.csv'
#    file_name = '_stft.csv'
    DirectoryPath = 'C:/Users/hojung/Documents/Anaconda_python/data/220110/'
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
#각 파일의 시행 횟수와 데이터셋 나누는 비율 설정
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

#========================================================
#================파라미터 설정================================
#========================================================
# STFT = (128, 29) //  CWT = (81,1920)
start_row = 0   # row 전체 범위 설정
end_row = 40    
interval_row = 5  # row 간격, 몇 칸씩 이동할건지
scale_row = 1  # 몇칸마다 추출하는지
# 1칸씩 추출, 0~40 사이에서 5칸씩 이동 
# => img_row=30이므로 (0~30),(5~35),(10~40) 이런식으로 추출

start_col = 60    # col 전체 범위 설정
end_col = 160
interval_col = 10  # col 간격, 몇 칸씩 이동할건지
scale_col = 8  # 몇칸마다 추출하는지
# 8칸씩 추출, 0~160 사이에서 10칸씩 이동 
# => img_col=80이므로 (60~140),(70~150),(80~160) 이런식으로 추출

classnum = 3     # class 개수
motion_num = 4   # 모션 개수

# 이미지 크기 설정
img_row = 30   # 추출 img row 크기
img_col = 80   # 추출 img col 크기

rows = math.ceil((end_row - start_row - img_row + 1) / interval_row) # row에서 가능한 이동 개수
cols = math.ceil((end_col - start_col - img_col + 1) / interval_col) # col에서 가능한 이동 개수

arry_result_acc = np.zeros(rows*cols*motion_num).reshape(motion_num,rows,cols)  # 결과 저장 arry
arry_result_val = np.zeros(rows*cols*motion_num).reshape(motion_num,rows,cols)  # 결과 배열 검증용 arry
array_start_col = np.zeros(rows*cols).reshape(rows,cols)  # col 시작위치 저장 arry
array_start_row = np.zeros(rows)   # row 시작위치 저장 arry
 
for motion in range(4):   # motion 마다 실행
    print('rows =',rows,'cols =',cols)
    image0,label0 = preprocessing(0,motion) # 경민_motion 불러옴
    image1,label1 = preprocessing(1,motion) # 성진_motion 불러옴
    image2,label2 = preprocessing(2,motion) # 호정_motion 불러옴
    for row_num in range(rows):
        array_start_row[row_num] = start_row + row_num * interval_row  # row 시작위치 저장
        for col_num in range(cols):
            result_acc = 0   # 5회치 결과 저장을 위한 Temp
            array_start_col[row_num][col_num] = start_col + col_num * interval_col  # col 시작위치 저장
            for i in range(5):    # 5회 실행 -> 평균 계산위해
                s = np.arange(image0.shape[0])
                np.random.shuffle(s)
                image0_shuff = image0[s]       # 불러온 경민_motion data의 순서를 섞음

                s = np.arange(image1.shape[0])
                np.random.shuffle(s)
                image1_shuff = image1[s]       # 불러온 성진_motion data의 순서를 섞음

                s = np.arange(image2.shape[0])
                np.random.shuffle(s)
                image2_shuff = image2[s]       # 불러온 호정_motion data의 순서를 섞음

                image0_crop = preprocessing_resize_crop(image0_shuff, start_row + row_num * interval_row,
                                                        row_num * interval_row + start_row + img_row, start_col + col_num * interval_col,
                                                        col_num * interval_col + start_col + img_col ,scale_row,scale_col)
                image1_crop = preprocessing_resize_crop(image1_shuff, start_row + row_num * interval_row,
                                                        row_num * interval_row + start_row + img_row, start_col + col_num * interval_col,
                                                        col_num * interval_col + start_col + img_col ,scale_row,scale_col)
                image2_crop = preprocessing_resize_crop(image2_shuff, start_row + row_num * interval_row,
                                                        row_num * interval_row + start_row + img_row, start_col + col_num * interval_col,
                                                        col_num * interval_col + start_col + img_col ,scale_row,scale_col)
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
                model = deep_learning_model.create_CNNmodel(img_row, img_col, classnum)
                early_stopping = EarlyStopping(monitor='val_accuracy', patience=7)
                y_train = np_utils.to_categorical(y_train, classnum)
                y_val = np_utils.to_categorical(y_val, classnum)
                y_test = np_utils.to_categorical(y_test, classnum)
                # CNN 훈련
                hist = model.fit(x_train, y_train, validation_data=(
                    x_val, y_val), epochs=50, callbacks=[early_stopping],verbose = 2,batch_size = 20)

                # 평가
                print('Evaluate')
                score = model.evaluate(x_test, y_test)
                print('row =', start_row + row_num * interval_row,':' , row_num * interval_row + start_row + img_row,
                      ', col =',start_col + col_num * interval_col ,':', col_num * interval_col + start_col + img_col,
                      ' round =',i, ' motion =',motion)
                print('Test loss:', score[0])
                print('Test accuracy:', score[1])
                result_acc = result_acc + score[1]    # 5회치 결과 저장
            arry_result_acc[motion][row_num][col_num] = result_acc / 5   # 정확도 평균값 저장
            arry_result_val[motion][row_num][col_num] = motion*10000 + row_num*100 + col_num   # LOOP 적용 검증용
    print('average_acc : ',arry_result_acc)



# 전체 수행 결과 출력
for motion in range(4):
    for row in range(rows):
        for col in range(cols):
            print('row =', int(array_start_row[row]),':' ,int(array_start_row[row]+img_row)  ,'// col =',int(array_start_col[row][col]) ,':',
                  int(array_start_col[row][col]+img_col),'// motion =',int(motion) ,'// acc =',round(arry_result_acc[motion][row][col],3)
                 , '// val_check =',arry_result_val[motion][row][col])
            # row = 0 : 30 // col = 30 : 110 // motion = 0 // acc = 0.713 // val_check = 3.0 
            # 위와 같은 방식으로 출력됨

