Unzip Finals.zip
Setup in windows:

1.  Install python v2.7.9 or higher
2.  Place the cv2.pyd (opencv) file in 'PYTHON_FOLDER\Lib\site-packages\' directory. Ex- 'C:\Python27\Lib\site-packages\'
3.  pip installer comes by default in python v2.7.9 or higher. If not installed, go to this link- http://stackoverflow.com/questions/4750806/how-do-i-install-pip-on-windows
4.  Open the command prompt and execute the following command:
    > pip install numpy
5.  Open command prompt and navigate to 'Finals' folder and execute the following command:
    > python main.py


Usage:

In 'main.py'
1.  There are two methods to implement the system.
    Method 1 : Using webcam of the laptop as an image capturing device. Images will be saved in the 'Images' folder. *Please provide path in path_img_dir_m1
    Method 2 : Using test images saved in the folder testImages. *Please provide path in main.py
2.  Set the 'no_frames' variable to configure the number of frames to be captured. Default value is 5.
3.  Setup two email addresses, one your personal GMail account for sending the images and second is the account for Police (use another email account for testing purpose).
    login into gmail with following email addresses and passwords
    Set the 'from_name' and 'from_passwd' variables for sending Email account
    Set the 'addrto_name' variable for receiving Email account


In Algorithm.py
1.  Set the 'Thres_pixel' variable to count the number of dark pixels below this value.
5.  Set the 'Beta_max' and 'Beta_min' variables for calculating the 'img_logcurve' value

More reading on the algorithm in LightCompensation.pdf in the section 3.1
