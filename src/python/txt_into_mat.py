# Function
# switch raw data file(.txt) into data file(.mat) for CWT

# Variable to check
# date: set date when measure data
# DirectoryPath: set by PC
# round: set by motion


import scipy.io  # library to save to .mat file

date = '211130'

# Directory Path
# kkm
# Ubuntu
DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-CWT-DeepLearning/data/' + date + '/'
# DirectoryPath = '/home/kmkim/Projects/git/kmkim036/Radar-CWT-DeepLearning/'
# Window
#DirectoryPath = 'C:/Users/김경민/Desktop/Studies/Projects/Radar-CWT-DeepLearning/data/' + date + '/'

# nkhj
# DirectoryPath = "/content/drive/MyDrive/data/"

for person in range(0, 3):
    for motion in range(0, 4):
        # need to revise round counts by motion
        if motion < 2:
            round = 30
        else:
            round = 10
            # File Name and File Path
        for i in range(1, round + 1):
            FileName = date + '_' + str(person) + \
                '_' + str(motion) + '_' + str(i)
            FileREPathToLoad = DirectoryPath + FileName + '_RE.txt'
            FileIMPathToLoad = DirectoryPath + FileName + '_IM.txt'
            FileREPathToSave = DirectoryPath + FileName + '_RE.mat'
            FileIMPathToSave = DirectoryPath + FileName + '_IM.mat'

            # Sampling Rate of Radar
            SampleRate = 3000

            # variable for mat file
            dt = float(1)
            Fs = float(650)
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
