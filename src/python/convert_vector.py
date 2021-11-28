import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# 경로
path = "/content/drive/MyDrive/data/"

# 데이터 불러오기
cwt_data = pd.read_csv(path + "csv_data.csv")
cwt_data['pixels']  # 데이터 구조 확인


def preprocessing(data):                       # 함수 정의
    image = np.zeros(shape=(len(data), 21, 101))  # 빈 넘파이형태 (21*101 형태로 설정)
    for i, row in enumerate(data.index):
        df = np.fromstring(data['pixels'][row], dtype=int,
                           sep=' ')  # 공백으로 구분된 데이터를 넘파이로 변경
        df = np.reshape(df, (21, 101))
        image[i] = df
    return image


x_result = preprocessing(cwt_data)
x_result   # 전체 구조확인

x_result[0]        # 0번째 값 확인

plt.imshow(x_result[0])  # 0번째 값 출력
