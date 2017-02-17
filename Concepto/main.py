import numpy as np
#import matplotlib.pyplot as plt
import cv2
from MSE import *
from click_save_img import *
from read_image import *
from Algorithm import *
from get_location import *
from Send_email import *
import io
import re
import os


cwd = os.getcwd()
re.escape(cwd)
path_dir = cwd.replace('\\', '/')

#method 1 path
path_img_dir_m1 = path_dir + "/Images/"
#method 2 path
path_img_dir_m2 = path_dir + "/testImages/"
#processed image path
path_img_dir_save = path_dir + "/Processed/"

##############################change parameters here#######################################3
Debug=True
'''
Method = 1 for getting images stored in a given directory
Method = 2 for getting real time images using webcam
'''
#method 2 as default
Method = 1
no_frames = 6

#Email parameters
from_name = "gaureshece6258@gmail.com"
from_passwd = "GATECHECE6258"
subject = "Concepto Test"
body = "My location: "
addrto_name = "gtece6258@gmail.com"
#addrto_pass= "GATECHECE6258"

#######################################do not change anything beyond this point##########################################


Method = int(input("Please input the method: 1 or 2:  "))

if (Method) == 1 or (Method) == 2:
    #list of all images
    #images=[]
    images = numpy.empty((no_frames), dtype=object)
    images_cnt = 0

    if Method == 1:
        click_save_img(no_frames,path_img_dir_m1)
        images,images_cnt = read_Images(path_img_dir_m1)
    else:
        images,images_cnt = read_Images(path_img_dir_m2)



    for i in range(0,images_cnt):
        Algorithm(images[i],i,path_img_dir_save)


    lat,longi = getlocation()
    latstr = " Latitude : "+str(lat)
    longistr = "  Longitude : "+str(longi)
    body = body + latstr + longistr

    send(from_name, from_passwd, subject, body, addrto_name, path_img_dir_save)
else:
    print "Please input valid method"
    exit(1)
