import numpy as np


def detect_human(image, power):
    '''
    need to fix human detect algorithm
    '''
    a = np.argmax(image, axis=0)
    b = np.argmax(image, axis=1)
    b = b[6:30]
    if power > 5000000:
        if a[23] >= 12 and a[23] <= 18 and a[24] >= 12 and a[24] <= 18 and a[25] >= 12 and a[25] <= 18 and a[26] >= 12 and a[26] <= 18 and a[27] >= 12 and a[27] <= 18 and b.min() >= 15:
           return True
        else:
            return False
