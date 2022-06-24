import numpy as np

time_reference = 20

def detect_human(image, power):
    '''
    need to fix human detect algorithm
    '''
    a = np.argmax(image, axis=0)
    b = np.argmax(image, axis=1)
    b = b[6:30]
    
    if power > 5000000:
        if a[time_reference] >= 12 and a[time_reference] <= 18 and a[time_reference + 1] >= 12 and a[time_reference + 1] <= 18 and a[time_reference + 2] >= 12 and a[time_reference + 2] <= 18 and a[time_reference + 3] >= 12 and a[time_reference + 3] <= 18 and a[time_reference + 4] >= 12 and a[time_reference + 4] <= 18 and b.min() >= 15:
           return True
        else:
            return False
    '''
    if power > 5000000:
        return True
    else: 
        return False
    '''
