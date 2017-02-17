import cv2.cv as cv
import time

delay=0.1
#cv.NamedWindow("camera", 1)
def click_save_img(frames,path):
    capture = cv.CaptureFromCAM(0)

    i = 0
    while i<frames:
        img = cv.QueryFrame(capture)
        #cv.ShowImage("camera", img)
        cv.SaveImage(path+'pic{:>05}.jpg'.format(i), img)
        time.sleep(delay)
        #if cv.WaitKey(10) == 27:
            #break
        i += 1
