#!/usr/bin/env python
# coding: utf-8

# In[1]:


import tensorflow as tf
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from tensorflow.keras.layers import Dense, Flatten, BatchNormalization
from tensorflow.keras.models import Sequential
from tensorflow.keras.optimizers import Adam
from tensorflow import keras
from tensorflow.keras.callbacks import EarlyStopping
from tensorflow.keras.preprocessing.image import ImageDataGenerator


# In[2]:


#경로
path = 'C:/Users/hojung/Documents/GitHub/Radar-CWT-DeepLearning/data/211130/file_cwt4_reduce/'

# 데이터 불러오기
data = pd.read_csv(path+'cwt_reduce.csv')
# icml_face_data 파일에 훈련용, 검증용, 테스트용 데이터가 포함됨


# In[3]:


data.shape


# In[4]:


data.head()


# In[5]:


data['person'].value_counts()


# In[6]:


len(data['pixels'][0])


# In[7]:


temp = np.fromstring(data['pixels'][0], dtype=int, sep=' ')

print(len(temp))


# In[8]:


# 데이터 전처리 함수
def preprocessing(data):
    image = np.zeros(shape=(len(data), 40, 40)) # 빈 넘파이형태 (20*400)
    label = np.array(list(map(int, data['person']))) 
    for i, row in enumerate(data.index):
        df = np.fromstring(data['pixels'][row], dtype=int, sep=' ') # 공백으로 구분된 데이터를 넘파이로 변경
        df = np.reshape(df, (40, 40)) 
        image[i] = df
    return image, label


# In[9]:


x_train, y_train = preprocessing(data[data['usage']=='train'])
x_val, y_val = preprocessing(data[data['usage']=='valid'])
x_test, y_test = preprocessing(data[data['usage']=='test'])


# In[10]:


x_train.shape, x_val.shape, x_test.shape, y_train.shape, y_val.shape, y_test.shape


# In[11]:


plt.imshow(x_train[0], cmap='gray')
print("lable:",y_train[0])


# In[12]:


print(x_train.shape, x_val.shape, x_test.shape)
x_train = x_train.reshape((x_train.shape[0], 40, 40, 1))
x_val = x_val.reshape((x_val.shape[0], 40, 40, 1))
x_test = x_test.reshape((x_test.shape[0], 40, 40, 1))
print(x_train.shape, x_val.shape, x_test.shape)


# In[13]:


x_data,y_data = preprocessing(data)


# In[14]:


x_data.max()


# In[15]:


x_train = x_train.astype('float32')/x_data.max()
x_val = x_val.astype('float32')/x_data.max()
x_test = x_test.astype('float32')/x_data.max()


# In[16]:


gen = ImageDataGenerator(
                         width_shift_range=0.2
                            )


# In[17]:


# 보강할 학습데이터 이미지 생성

augment_ratio = 1.5   # 전체 데이터의 150%
augment_size = int(augment_ratio * x_train.shape[0])

print(augment_size)

# 전체 x_train 개수의 150% 비율만큼
randidx = np.random.randint(x_train.shape[0], size=augment_size)

# 임의로 선택된 데이터는 원본데이터를 참조하기 때문에
# 원본데이터에 영향을 줄수 있음. 그래서 copy() 함수를 통해 안전하게 복사본 만듬
x_augmented = x_train[randidx].copy()  
y_augmented = y_train[randidx].copy()


print(x_augmented.shape, y_augmented.shape)

#  이미지 보강 실행
x_augmented, y_augmented = gen.flow(x_augmented, y_augmented, 
                                    batch_size=augment_size,
                                    shuffle=False).next()

print(x_augmented.shape, y_augmented.shape)
plt.imshow(x_augmented[2], cmap='gray')


# In[18]:


x_train = np.concatenate((x_train,x_augmented))
y_train = np.concatenate((y_train,y_augmented))
s = np.arange(x_train.shape[0])
np.random.shuffle(s)
x_train = x_train[s]
y_train = y_train[s]
x_train.shape, y_train.shape


# In[19]:


# 모델 생성
model = keras.Sequential()
model.add(keras.layers.Conv2D(32, kernel_size=(3, 3), activation='relu', input_shape=(40, 40, 1)))
model.add(keras.layers.MaxPooling2D(2, 2))

model.add(keras.layers.Conv2D(64, kernel_size=(3, 3), activation='relu'))
model.add(keras.layers.MaxPooling2D(2, 2))
model.add(keras.layers.Conv2D(64, kernel_size=(3, 3), activation='relu'))



model.add(keras.layers.Flatten())
model.add(keras.layers.Dense(64, activation='relu'))
model.add(keras.layers.Dense(3, activation='softmax'))


# 모델 요약
model.summary()


# 모델 컴파일
model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy', metrics='accuracy')
early_stopping = EarlyStopping(monitor='val_accuracy', patience=5)


# In[24]:


history = model.fit(x_train, y_train,  validation_data=(x_val, y_val), epochs=100,callbacks=[early_stopping])


# In[25]:


loss, acc = model.evaluate(x_test, y_test)
print('test정확도:', acc)


# In[ ]:




