%%%%%%%%%%%%%%%%%%%%%%% second pass interpolation %%%%%%%%%%%%%%%%%%%%%

%% load first pass metrics
load points_inter.mat 
load pass_one_inter.mat
%% change paraameters here
%interpolation properties
inter_flag = 1;
inter_fac = 1.5;
inter_method ='bilinear';
% total number of logos
[images,nfiles]=get_logos(1);
%image 1 is Discover logo
%image 2 is Geico logo
%array to store second pass result
dynamic=[];
%tolerance for bounding box 
tol=0;

%% ground truth- subjectively a user can make out the total number of times the logo appeared in given frame sequence
totalFrames_logo1=38;   % for discover
totalFrames_logo2=46;    % for geico

%% main
for ii=1:nfiles
    if ii==1
        inter_method='bicubic';
    else
         inter_method='bilinear';
    end
    %% Load video
    obj = VideoReader('mov_1.mp4');
    startFrame = 900;
    nFrames = obj.NumberOfFrames;
    endFrame=nFrames;
    vidHeight = obj.Height;
    vidWidth = obj.Width;
    Feature_Thres=3;
    
    for i = 900:945
        % dynamic array is also saved in the same fashion as first_pass_res 
        % make dynamic array entries zero first    
        dynamic(i,1+5*(ii-1):5+5*(ii-1))=0;
        %Case 1
        %if the previous frame has entry 1 and current frame has entry 0 
        % extract the logo from previous frame  
        %do the features matching with the logo extracted from the previous frame
        %repeat first pass operation 
        if(i~=0)
            if(First_pass_res(i,1+5*(ii-1))==0 && First_pass_res(i-1,1+5*(ii-1))~=0) 
                %get current frame
                currFrame = read(obj,i); 
                sceneImage=rgb2gray(currFrame);
                sceneImage = imsharpen(sceneImage);
                if inter_flag == 1
                    sceneImage = imresize(sceneImage,inter_fac,inter_method);
                end

                scenePoints = detectSURFFeatures(sceneImage);
                [sceneFeatures, scenePoints] = extractFeatures(sceneImage,scenePoints);

                %get previous frame
                lastFrame=read(obj,i-1);
                lastsceneImage=rgb2gray(lastFrame);
                lastsceneImage = imsharpen(lastsceneImage);
                if inter_flag == 1
                    lastsceneImage = imresize(lastsceneImage,inter_fac,inter_method);
                end
                % get the reference logo from the previous frame
                % coordinates are used to extract logo here 
                croppedone = imcrop(lastsceneImage,[First_pass_res(i-1,2+5*(ii-1)) First_pass_res(i-1,3+5*(ii-1)) First_pass_res(i-1,4+5*(ii-1)) First_pass_res(i-1,5+5*(ii-1))]);
                 %extract surf features using Compute_SURF_DES_KP function
                 %for new logo image
                newlogoPoints = detectSURFFeatures(croppedone);

                [newlogoFeatures, newlogoPoints] = extractFeatures(croppedone,newlogoPoints);

                logoPolygon = [1, 1;...                           % top-left
                size(croppedone, 2), 1;...                 % top-right
                size(croppedone, 2), size(croppedone, 1);... % bottom-right
                1, size(croppedone, 1);...                 % bottom-left
                1, 1];  

                newlogoPairs = matchFeatures(newlogoFeatures, sceneFeatures,'Unique', true );
                newlogoScenePoints =  newlogoPoints( newlogoPairs(:, 1), :);
                matchedScenePoints = scenePoints( newlogoPairs(:, 2), :);

                if newlogoScenePoints.Count<Feature_Thres &&  matchedScenePoints.Count <Feature_Thres

                else
                    [tform, inlierlogoPoints, inlierScenePoints] = estimateGeometricTransform(newlogoScenePoints, matchedScenePoints,'affine'); 

                    newlogoPolygon = transformPointsForward(tform, logoPolygon);

                    width = abs(newlogoPolygon(2,1) - newlogoPolygon(1,1))+tol*3;
                    height = abs(newlogoPolygon(3,2) - newlogoPolygon(2,2))+tol*3;
                    xpt=newlogoPolygon(1,1)-tol;
                    ypt=newlogoPolygon(1,2)-tol;

                    if xpt<1 | ypt<1 | width <1 | height <1  
                        dynamic(i,1+5*(ii-1):5+5*(ii-1))=0;
                    else

                        if abs(width) < abs(height)
                            p=1;
                        else 
                            dynamic(i,1+5*(ii-1))=1;
                            dynamic(i,2+5*(ii-1):5+5*(ii-1))=[xpt ypt width height];

                        end
                    end

                end

            end
        end
        %case 2
        %If current frame first pass entry is 0 and previous frame first pass entry is also 0
        % The dynamic pass entry for previous frame is 1 and current frame entry is 1
        % use the coordinates of the previous frame dynamic pass as
        % to extract logo and do feature matching
        %repeat the first pass again and update dynamic array entry
        if(i~=1)
            if(First_pass_res(i,1+5*(ii-1))~=1)
                if(dynamic(i,1+5*(ii-1))==0 && dynamic(i-1,1+5*(ii-1))~=0) 
                    %current frame
                    if debug==1
                        disp('value of i is ');
                        disp(i);
                    end
                    currFrame1 = read(obj,i); 
                    sceneImage1=rgb2gray(currFrame1);
                    sceneImage1 = imsharpen(sceneImage1);
                    if inter_flag == 1
                        sceneImage1 = imresize(sceneImage1,inter_fac,inter_method);
                    end
                    scenePoints1 = detectSURFFeatures(sceneImage1);
                    [sceneFeatures1, scenePoints1] = extractFeatures(sceneImage1,scenePoints1);

                    %previous frame
                    lastFrame1=read(obj,i-1);
                    lastsceneImage1=rgb2gray(lastFrame1);
                    lastsceneImage1 = imsharpen(lastsceneImage1);
                    if inter_flag == 1
                        lastsceneImage1 = imresize(lastsceneImage1,inter_fac,inter_method);
                    end
                    croppedone1 = imcrop(lastsceneImage1,[dynamic(i-1,2+5*(ii-1)) dynamic(i-1,3+5*(ii-1)) dynamic(i-1,4+5*(ii-1)) dynamic(i-1,5+5*(ii-1))]);

                    newlogoPoints1 = detectSURFFeatures(croppedone1);
                    if debug==1
                        figure;
                        imshow(croppedone1);
                    end
                    [newlogoFeatures1, newlogoPoints1] = extractFeatures(croppedone1,newlogoPoints1);

                    logoPolygon1 = [1, 1;...                           % top-left
                    size(croppedone1, 2), 1;...                 % top-right
                    size(croppedone1, 2), size(croppedone1, 1);... % bottom-right
                    1, size(croppedone1, 1);...                 % bottom-left
                    1, 1];  



                    newlogoPairs1 = matchFeatures(newlogoFeatures1, sceneFeatures1,'Unique', true );
                    newlogoScenePoints1 =  newlogoPoints1( newlogoPairs1(:, 1), :);
                    matchedScenePoints1 = scenePoints1( newlogoPairs1(:, 2), :);

                    if newlogoScenePoints1.Count<Feature_Thres &&  matchedScenePoints1.Count <Feature_Thres

                    else
                        [tform1, inlierlogoPoints1, inlierScenePoints1] = estimateGeometricTransform(newlogoScenePoints1, matchedScenePoints1,'affine'); 

                        newlogoPolygon1 = transformPointsForward(tform1, logoPolygon1);

                        width1 = abs(newlogoPolygon1(2,1) - newlogoPolygon1(1,1));
                        height1 = abs(newlogoPolygon1(3,2) - newlogoPolygon1(2,2));
                        xpt1=newlogoPolygon1(1,1);
                        ypt1=newlogoPolygon1(1,2);
                        if xpt1<1 | ypt1<1 | width1 <1 | height1 <1
                            dynamic(i,1+5*(ii-1):5+5*(ii-1))=0;
                        else 
                            if abs(width) < abs(height)
                                p=1;
                            else 
                                dynamic(i,1+5*(ii-1))=1;
                                dynamic(i,2+5*(ii-1):5+5*(ii-1))=[xpt1 ypt1 width1 height1];
                            end
                        end
                    end
                 end
             end

        end

    end
end

%% Results
str = sprintf('Results for interpolation case');
disp(str);

pass_one_score_logo1  = (count_matches(1)/totalFrames_logo1)*100;
pass_one_score_logo2  = (count_matches(2)/totalFrames_logo2)*100;

[C,pass_two_total_logo1]=Union(First_pass_res,dynamic,1,900,945);
[D,pass_two_total_logo2]=Union(First_pass_res,dynamic,6,900,945);

pass_two_score_logo1  = (pass_two_total_logo1/totalFrames_logo1)*100;
pass_two_score_logo2  = (pass_two_total_logo2/totalFrames_logo2)*100;


str = sprintf('Ground Truth Count for Discover - %d',totalFrames_logo1);
disp(str);
str = sprintf('Ground Truth Count for Geico - %d',totalFrames_logo2);
disp(str);

disp('Results for LOGO 1 - Discover');
format bank;
str = sprintf('Results for 1st Pass - %d percent Recall', round(pass_one_score_logo1));
disp(str);
str = sprintf('Results for 2nd Pass - %d percent Recall', round(pass_two_score_logo1));
disp(str);

disp('Results for LOGO 2 - GEICO');
str = sprintf('Results for 1st Pass - %d percent Recall', round(pass_one_score_logo2));
disp(str);
str = sprintf('Results for 2nd Pass - %d percent Recall', round(pass_two_score_logo2));
disp(str);

