from os import listdir
from os.path import isfile, join
# Import smtplib for the actual sending function
import smtplib
# Here are the email package modules we'll need
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

def send(name, passwd, subject, body, addrto, path):

    mypath=path
    onlyfiles = [ f for f in listdir(mypath) if isfile(join(mypath,f)) ]
    #print onlyfiles
    msg = MIMEMultipart()
    msg['Subject'] = subject
    msg['From'] = name
    msg['To'] = addrto

    text = MIMEText(body)
    msg.attach(text)


    for filea in onlyfiles:
        print filea
            # Open the files in binary mode.  Let the MIMEImage class automatically
            # guess the specific image type.
        f = file(join(mypath,filea),'rb')
        img = MIMEImage(f.read())
        msg.attach(img)

    print("connecting")
    s = smtplib.SMTP('smtp.gmail.com', '587')
    s.ehlo()
    s.starttls()
    s.ehlo()
    s.login(name, passwd)
    print("connected")
    s.sendmail(name + '@gmail.com', addrto, msg.as_string())
    print("sent")
    s.quit()
