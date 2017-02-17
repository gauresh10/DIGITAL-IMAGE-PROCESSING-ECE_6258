
% Acquiring the video from the webcam

% Setting up the connection
% cam = webcam;

vid = videoinput('macvideo',1, 'YCbCr422_1280x720');

% Close connection
% clear('cam');
%%
v = VideoWriter('myIndexed.avi');
open(v)
for i = 1:100
    
    img = snapshot(cam);
    frame = im2frame(img);
    writeVideo(v,frame);
    
end
