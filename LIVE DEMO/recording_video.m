clear all; 
clc;


%%

vid = videoinput('macvideo',1, 'YCbCr422_1280x720');
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb');
% vid.FrameRate =30;
vid.FrameGrabInterval = 1;  % distance between captured frames 
start(vid)

v = VideoWriter('myVideo_demo22.avi');   % Create a new AVI file
open(v);
%%
for iFrame = 1:100                   % Capture 100 frames
 
  I=getsnapshot(vid);
 imshow(I);
%   F = im2frame(I);                    % Convert I to a movie frame
%   aviObject = addframe(aviObject,F);  % Add the frame to the AVI file
  
  writeVideo(v,I);
end
%%
close(v);         % Close the AVI file
stop(vid);
