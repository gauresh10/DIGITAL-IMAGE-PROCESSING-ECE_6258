import numpy as np
#import matplotlib.pyplot as plt
import cv2
import cv2.cv as cv
Debug=False

def mapping(OldValue,OldMin,OldMax,NewMin,NewMax):
    NewValue = (float(((OldValue - OldMin) * (NewMax - NewMin))) / float((OldMax - OldMin))) + NewMin
    return NewValue

def Algorithm(imga,iter,path):
    #Give a threshold value to find the number of pixels below this range
    Thres_pixel = 60
    #select  Beta_min and Beta_max
    Beta_min = 22
    Beta_max = 53
    #select theta value
    theta = 0.0
    img = np.empty((iter), dtype=object)
    #Load Image
    img = cv2.cvtColor(imga, cv2.COLOR_BGR2GRAY)
    #cv2.imwrite(path+'processedtest.jpg', img)
    #cv2.imshow('original image',img)
    rows,cols = img.shape

    #max value calculation
    max_val = np.nanmax(img)

    #max value calculation
    min_val = np.nanmin(img)

    #pixel operation to find pixel val lower than a threshold(Darker pixel)
    condition = (img ) < Thres_pixel
    new_array = np.where(condition)
    Ndark = np.size(new_array)
    #print Ndark
    Ntotal = rows * cols
    #print Ntotal
    ratio = float(Ndark) / float(Ntotal)
    #print "Ratio is "+str(ratio)
    theta = mapping(ratio,0.0,1.0,0.0,3.0)

    #step 1
    #Log curve
    #Ntotal=rows*cols
    Beta_val = (Beta_max - Beta_min) * (Ndark / Ntotal) + Beta_min
    img_logcurve = np.log((img) * (Beta_val - 1) + 1) / np.log(Beta_val)
    #step 2
    #Enhanced Image
    Theta_arr = np.full((rows, cols), theta)
    one_arr = np.ones((rows, cols))
    img_enh = np.zeros((rows, cols),  dtype = np.uint8)
    img_enh = img_logcurve * (one_arr - Theta_arr) + img*Theta_arr
    img_enh = img_enh.astype(int)

    #print img_enh
    cv2.imwrite(path + 'pro_pic{:>05}.jpg'.format(iter), img_enh)
    #cv2.imwrite('enhancedimage.jpg', img_enh)

    #print "Written the new image"
    #enhanced_img=cv2.imread('enhancedimage.jpg',0)
    #cv2.imshow('enhanced image',enhanced_img)


    #mse_error=mse(img,enhanced_img)





    if Debug:
        print "Max Value in the image is "+str(max_val)
        print "Min Value in the image is "+str(min_val)
        print "Number of elements above threshold "+str(Ndark)
        print "Beta value is "+str(Beta_val)
        #print "MSE Error is "+str(mse_error)
        print "Theta value is"+str(theta)

    #cv2.waitKey(0)
    #cv2.destroyAllWindows()
