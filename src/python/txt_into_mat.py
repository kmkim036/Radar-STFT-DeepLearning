# by kmkim
# switch raw data file(.txt) into data file(.mat) for CWT

import scipy.io  # library to save to .mat file

# Directory Path
# Ubuntu
#DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-CWT-DeepLearning/data/211029/'
# Window
DirectoryPath = 'C:/Users/김경민/Desktop/Studies/Projects/Radar-CWT-DeepLearning/data/211109/'

# File Name and File Path
FileName = '211109_4_4'
FileREPathToLoad = DirectoryPath + FileName + '_RE.txt'
FileIMPathToLoad = DirectoryPath + FileName + '_IM.txt'
FileREPathToSave = DirectoryPath + FileName + '_RE.mat'
FileIMPathToSave = DirectoryPath + FileName + '_IM.mat'

# Sampling Rate of Radar
SampleRate = 3000

# variable for mat file
dt = float(1)
Fs = float(850)
dataRE = []
dataIM = []
t = []

# varialbe just for indexing
i = 0
j = 0

# load txt file
fr = open(FileREPathToLoad, 'r')
while True:
    line = fr.readline()
    if not line:
        dataRE = list(zip([*dataRE]))  # transpose list data
        break
    line = line.replace('\n', '')
    dataRE.append(float(line))
    i = i + 1

# close txt file
fr.close()

# load txt file
fr = open(FileIMPathToLoad, 'r')

# save raw radar data into array variable
while True:
    line = fr.readline()
    if not line:
        dataIM = list(zip([*dataIM]))  # transpose list data
        break
    line = line.replace('\n', '')
    dataIM.append(float(line))


# close txt file
fr.close()

# save time data into array variable
SampleRate = 1 / SampleRate
while j != i:
    t.append(SampleRate * j)
    j = j + 1

# save into mat file
mdix = {"Fs": Fs, "dataRE": dataRE, "dt": dt, "t": t}
scipy.io.savemat(FileREPathToSave, mdix)

# save into mat file
mdix = {"Fs": Fs, "dataIM": dataIM, "dt": dt, "t": t}
scipy.io.savemat(FileIMPathToSave, mdix)
