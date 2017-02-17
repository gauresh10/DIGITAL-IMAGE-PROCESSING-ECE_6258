

load points.mat

%% Get the number of logos
% [images,nfiles]=get_logos(1);
Feature_Thres = 3;
nfiles = 2;
% Count for second pass
count_matches_second = zeros(1,nfiles);
%% Load video
obj = VideoReader(videofile);

nFrames = obj.NumberOfFrames;
endFrame=nFrames;
vidHeight = obj.Height;
vidWidth = obj.Width;

totalframes = 100;
%% Second pass for both logos:


    
    for i = 1: totalframes
        
           % Current frame
            currFrame = read(obj,i); 
            sceneImage=rgb2gray(currFrame);
            sceneImage = imsharpen(sceneImage);
            % SURF for current frame
            [sceneFeatures, scenePoints]  = Compute_SURF_DES_KP(sceneImage);
            
        if (i~=1) % excluding first frame
            
            for ii=1:nfiles
            
            if(ii ==1)
            % Logo 1
            % checking for 1/0, found in previous not found in current
            if(First_pass_res(i,1+5*(ii-1)) ==0 && First_pass_res(i-1,1+5*(ii-1)) ==1)
            
            % Previous frame
             
            lastFrame=read(obj,i-1);
            lastsceneImage=rgb2gray(lastFrame);
            lastsceneImage = imsharpen(lastsceneImage);
            % Crop logo out of previous frame where it was detected
            croppedone = imcrop(lastsceneImage,First_pass_res(i-1,2+5*(ii-1):5+5*(ii-1)));
        
            % SURF for previous frame's cropped logo
            [newlogoFeatures, newlogoPoints] = Compute_SURF_DES_KP(croppedone);

            logoPolygon = [1, 1;...                           % top-left
            size(croppedone, 2), 1;...                 % top-right
            size(croppedone, 2), size(croppedone, 1);... % bottom-right
            1, size(croppedone, 1);...                 % bottom-left
            1, 1];


            [matchedlogoPoints, matchedScenePoints,logoct,scenect]=find_matchpts(newlogoPoints,scenePoints,newlogoFeatures,sceneFeatures);
 imshow(sceneImage);
 str = sprintf('Frame%d',i);
        title(str);
                if logoct<Feature_Thres &&  scenect <Feature_Thres

                       % do nothing

                else
                     % Count second pass results
                      count_matches_second(ii) = count_matches_second(ii) + 1;
                        [tform, inlierlogoPoints, inlierScenePoints] = estimateGeometricTransform(matchedlogoPoints, matchedScenePoints,'affine');

                        newlogoPolygon = transformPointsForward(tform, logoPolygon);

                    hold on;
                    line(newlogoPolygon(:, 1), newlogoPolygon(:, 2), 'Color', 'r');

                end
            
            end
            end
            
            % Logo 2
            if(ii==2)
                
              if(First_pass_res(i,1+5*(ii-1)) ==0 && First_pass_res(i-1,1+5*(ii-1)) ==1)
                
            % Current frame
            currFrame = read(obj,i); % this operation is very slow and even deprecated - replace by frameRead
            sceneImage=rgb2gray(currFrame);
            sceneImage = imsharpen(sceneImage);
            % SURF for current frame
            [sceneFeatures, scenePoints]  = Compute_SURF_DES_KP(sceneImage);
            
            % Previous frame
             
            lastFrame=read(obj,i-1);
            lastsceneImage=rgb2gray(lastFrame);
            lastsceneImage = imsharpen(lastsceneImage);
            % Crop logo out of previous frame where it was detected
            croppedone = imcrop(lastsceneImage,First_pass_res(i-1,2+5*(ii-1):5+5*(ii-1)));
        
            % SURF for previous frame's cropped logo
            [newlogoFeatures, newlogoPoints] = Compute_SURF_DES_KP(croppedone);

            logoPolygon = [1, 1;...                           % top-left
            size(croppedone, 2), 1;...                 % top-right
            size(croppedone, 2), size(croppedone, 1);... % bottom-right
            1, size(croppedone, 1);...                 % bottom-left
            1, 1];


            [matchedlogoPoints, matchedScenePoints,logoct,scenect]=find_matchpts(newlogoPoints,scenePoints,newlogoFeatures,sceneFeatures);

            if logoct<Feature_Thres &&  scenect <Feature_Thres

                   % do nothing

            else
                 imshow(sceneImage);
 str = sprintf('Frame%d',i);
        title(str);
                 % Count second pass results
                  count_matches_second(ii) = count_matches_second(ii) + 1;
                    [tform, inlierlogoPoints, inlierScenePoints] = estimateGeometricTransform(matchedlogoPoints, matchedScenePoints,'affine');

                    newlogoPolygon = transformPointsForward(tform, logoPolygon);

                hold on;
                line(newlogoPolygon(:, 1), newlogoPolygon(:, 2), 'Color', 'b');

            end
            
              end
           end 
              
            end
         end
    end
     
    %% Score:
    load count_matches.mat
    % Logo 1
    percent_increase_Logo1 = (count_matches_second(1)/count_matches(1)) * 100;
    str = sprintf('Percent increase over first pass logo 1: %d %', round(percent_increase_Logo1));
    disp(str);
    % Logo 2
    percent_increase_logo2 = (count_matches_second(2)/count_matches(2)) * 100;
    str = sprintf('Percent increase over first pass logo 2: %d %', round(percent_increase_logo2));
    disp(str);