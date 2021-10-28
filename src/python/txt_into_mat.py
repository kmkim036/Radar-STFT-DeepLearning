# by kmkim
# switch raw data file(.txt) into data file(.mat) for CWT

import scipy.io  # library to save to .mat file

# Directory Path
DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-CWT-DeepLearning/data/'

# File Name and File Path
FileName = 'TEST0_IM'
FilePathToLoad = DirectoryPath + FileName + '.txt'
FilePathToSave = DirectoryPath + FileName + '.mat'

# Sampling Rate of Radar
SampleRate = 3000

# variable for mat file
dt = float(1)
Fs = float(1)
data = []
t = []

# varialbe just for indexing
i = 0
j = 0

# load txt file
fr = open(FilePathToLoad, 'r')

# save raw radar data into array variable
while True:
    line = fr.readline()
    if not line:
        data = list(zip([*data]))  # transpose list data
        break
    line = line.replace('\n', '')
    data.append(float(line))
    i = i + 1

# close txt file
fr.close()

# save time data into array variable
SampleRate = 1 / SampleRate
while j != i:
    t.append(SampleRate * j)
    j = j + 1

# save into mat file
mdix = {"Fs": Fs, "data": data, "dt": dt, "t": t}
scipy.io.savemat(FilePathToSave, mdix)
