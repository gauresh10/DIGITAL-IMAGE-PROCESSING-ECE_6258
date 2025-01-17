%% MASTER FILE%% NEEDS TO BE RUN SECTION WISE%%

%% Cleanup
clear all;
close all;
clc

%% OBTAINING RESULTS FOR DETECTING BOTH LOGOS WITHOUT USING INTERPOLATION

% If we need to display the cropped logos then 
% put debug flag as 1

debug = 0;

% If the bounding box needs to be displayed then put bounding box flag as 1
% First pass all frames will be displayed with bounding box around those
% frames where there is a match and logo detected
% For second pass only those frames will be displayed where logos are detected
% newly in second pass
b_box = 0;

% To increase the size of the bounding box

tol_first_pass_simple = 10;

% Results are obtained for DISCOVER LOGO
% For GEICO logo the bounding box is incorrect hence results for second pass 
% are not the desired ones
first_pass_simple;
second_pass_simple;


%% Cleanup
clear all;
close all;
clc

%% OBTAINING RESULTS FOR DETECTING BOTH LOGOS USING INTERPOLATION

% If we need to display the cropped logos then 
% put debug flag as 1

debug = 0;

% Results are obtained for DISCOVER LOGO and GEICO logo
first_pass_interpolation;
second_pass_interpolation;