

%% Video frame 
%     obj = VideoReader('myVideo_logo.avi');

    obj = VideoReader(videofile);
    nFrames = obj.NumberOfFrames;
    endFrame=nFrames;
    vidHeight = obj.Height;
    vidWidth = obj.Width;
    
    totalframes = 100;
%%
nfiles = 2;
% Keep a count of matched logos
count_matches = zeros(1,nfiles);
%% Logo Read

logo = imread('coco_1.jpg');
logo=rgb2gray(logo);
% imshow(logo);

logo1 = imread('shell.jpeg');
logo1 =rgb2gray(logo1);
% figure();
% imshow(logo1);

%% Static stuff

    [logoFeatures,logoPoints]=Compute_SURF_DES_KP(logo);
    [logoFeatures1,logoPoints1]=Compute_SURF_DES_KP(logo1);

    % Get the bounding polygon of the reference image.
    logoPolygon = [1, 1;...                           % top-left
            size(logo, 2), 1;...                 % top-right
            size(logo, 2), size(logo, 1);... % bottom-right
            1, size(logo, 1);...                 % bottom-left
            1, 1];                   % top-left again to close the polygon

     % Get the bounding polygon of the reference image.
    logoPolygon1 = [1, 1;...                           % top-left
            size(logo1, 2), 1;...                 % top-right
            size(logo1, 2), size(logo1, 1);... % bottom-right
            1, size(logo1, 1);...                 % bottom-left
            1, 1];
 %% Loop for all frames  
    Feature_Thres=3;
    for i = 1:totalframes
         % Read the frame
        currFrame = read(obj,i); % this operation is very slow and even deprecated - replace by frameRead  
        sceneImage=rgb2gray(currFrame);
        % Sharpen
        sceneImage = imsharpen(sceneImage);
        % Extract surf features
        [sceneFeatures, scenePoints]  =Compute_SURF_DES_KP(sceneImage);
         imshow(sceneImage);
            str = sprintf('Frame%d',i);
            title(str);
        
    for ii = 1:nfiles
           
   if(ii ==1)     
        % Find matchpoints between logo and scene image
        [matchedlogoPoints, matchedScenePoints,logoct,scenect]=find_matchpts(logoPoints,scenePoints,logoFeatures,sceneFeatures);

           
            
        if logoct<Feature_Thres &&  scenect <Feature_Thres
           
            First_pass_res(i,1+5*(ii-1))=0;
            First_pass_res(i,2+5*(ii-1):5+5*(ii-1))=0;
            
        else
           
            % Outlier removal using M-SAC
            [tform, inlierlogoPoints, inlierScenePoints] = estimateGeometricTransform(matchedlogoPoints, matchedScenePoints,'affine'); 
            % Using tform map old logo bounding box to new one 
            newlogoPolygon = transformPointsForward(tform, logoPolygon);
         
            [xpt, ypt, width, height]=Box_Dim(newlogoPolygon);

            croppedone = imcrop(sceneImage,[xpt ypt width height]);
               if  (xpt<1 | ypt<1 | width <1 | height <1 )
                First_pass_res(i,1+5*(ii-1))=0;
                First_pass_res(i,2+5*(ii-1):5+5*(ii-1))=0;
            else
                if abs(width) < abs(height) 
                    First_pass_res(i,1+5*(ii-1))=0;
                    First_pass_res(i,2+5*(ii-1):5+5*(ii-1))=0;
                    
                else 
             % Increment counter for matched logos
            count_matches(ii) = count_matches(ii) + 1;
                    First_pass_res(i,1+5*(ii-1))=1;
                    First_pass_res(i,2+5*(ii-1):5+5*(ii-1))=[xpt ypt width height];
                    hold on;
                    line(newlogoPolygon(:, 1), newlogoPolygon(:, 2), 'Color', 'y');
                     str = sprintf('Frame%d',i);
                    title(str)
                end
               end
        end
   end     
        % Logo 2
     if(ii==2)   
         % Find matchpoints between logo and scene image
        [matchedlogoPoints1, matchedScenePoints1,logoct1,scenect1]=find_matchpts(logoPoints1,scenePoints,logoFeatures1,sceneFeatures);
        if logoct1<Feature_Thres &&  scenect1 <Feature_Thres
           
            First_pass_res(i,1+5*(ii-1))=0;
            First_pass_res(i,2+5*(ii-1):5+5*(ii-1))=0;
            
             str = sprintf('Frame%d',i);
            title(str)
        else
           
            % Outlier removal using M-SAC
            [tform1, inlierlogoPoints1, inlierScenePoints1] = estimateGeometricTransform(matchedlogoPoints1, matchedScenePoints1,'affine'); 
            % Using tform map old logo bounding box to new one 
            newlogoPolygon1 = transformPointsForward(tform1, logoPolygon1);
         
            [xpt, ypt, width, height]=Box_Dim(newlogoPolygon1);

            croppedone = imcrop(sceneImage,[xpt ypt width height]);
          if  (xpt<1 | ypt<1 | width <1 | height <1 | width>400)
                First_pass_res(i,1+5*(ii-1))=0;
                First_pass_res(i,2+5*(ii-1):5+5*(ii-1))=0;
            else
                if abs(width) < abs(height) 
                    First_pass_res(i,1+5*(ii-1))=0;
                    First_pass_res(i,2+5*(ii-1):5+5*(ii-1))=0;
                    
                else 
             % Increment counter for matched logos
            count_matches(ii) = count_matches(ii) + 1;
            First_pass_res(i,1+5*(ii-1))=1;
            First_pass_res(i,2+5*(ii-1):5+5*(ii-1))=[xpt ypt width height];

            hold on;
            line(newlogoPolygon1(:, 1), newlogoPolygon1(:, 2), 'Color', 'b');
             str = sprintf('Frame%d',i);
            title(str)
                end
          end
          
          
        end
         
     end
     
    end
    end


save ('points.mat','First_pass_res');

%% Scores

save('count_matches','count_matches');

% Logo 1

score1  = (count_matches(1)/totalframes)*100;

% Logo 2
score2 = (count_matches(2)/totalframes)*100;


str = sprintf('Logo 1 score First pass: %d %', round(score1));
disp(str);
str = sprintf('Logo 2 score First pass: %d %', round(score2));
disp(str);