%%
clear all;
clc;
close all;


%% video source
 videofile='hello';
%Get a live video (works on mac only)
%live_video=1;
%Get first source video
%live_video=2;
%Get a second source video
live_video=3;


if live_video == 1
   % enable below function on mac os only 
   % acquire
    videofile='myVideo_demo22.avi';
    
else if live_video == 2
    videofile='myVideo_demo.avi';

    else 
    videofile='myVideo_logo.avi';
        
    end
end
    
%% first pass starts here
first_pass_both;

%% second pass 
second_pass_both;


