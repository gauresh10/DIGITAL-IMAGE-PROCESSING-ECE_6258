from os import listdir
from os.path import isfile, join
import numpy
import cv2

def read_Images(path):
    mypath=path
    onlyfiles = [ f for f in listdir(mypath) if isfile(join(mypath,f)) ]
    images = numpy.empty(len(onlyfiles), dtype=object)
    for n in range(0, len(onlyfiles)):
      images[n] = cv2.imread( join(mypath,onlyfiles[n]) )      
    return images,len(onlyfiles)

'''
    #cv2.imwrite('test111.jpg',images[0])

    print len(images)
    for i in range(0,len(images)):
        cv2.imshow('image',images[i])
        cv2.waitKey(1000)
        cv2.destroyAllWindows()
'''
