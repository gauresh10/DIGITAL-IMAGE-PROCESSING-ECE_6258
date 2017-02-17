%%%%%%%%%%%%%%%%%%%%%% first pass simple%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% change parameters here
% Logo Read
[images,nfiles]=get_logos(1);
%image 1 is Discover logo
%image 2 is Geico logo

%array to store first pass result
First_pass_res=[];
%tolerance for bounding box 
tol=tol_first_pass_simple;
%array for counting the number of times logo appeared in the video frames
count_matches = zeros(1,nfiles); 
 
%% main 
% To get output for discover logo and supress geico logo

nfiles = 1;
% Looping through the two logos
for ii=1:nfiles
    %get the logo image - first discover and then geico
    currentfilename = images(ii);
    currentfilename=cell2mat(currentfilename);
    logo = currentfilename;
    %Display the logo
    figure;imshow(logo);title('Image of a LOGO');
    %Convert logo into grayscale image
    logo=rgb2gray(logo);
    %extract surf features using Compute_SURF_DES_KP function 
    [logoFeatures,logoPoints]=Compute_SURF_DES_KP(logo);
    % Find feature points 
    figure;imshow(logo);title('100 Strongest Feature Points from logo Image');
    hold on;
    plot(selectStrongest(logoPoints, 100));
    % Get the bounding polygon of the reference image.
    logoPolygon = [1, 1;...                           % top-left
            size(logo, 2), 1;...                 % top-right
            size(logo, 2), size(logo, 1);... % bottom-right
            1, size(logo, 1);...                 % bottom-left
            1, 1];                   % top-left again to close the polygon

    %% Video frame 
    
    obj = VideoReader('mov_1.mp4');
    startFrame = 900;
    nFrames = obj.NumberOfFrames;
    endFrame=nFrames;%total number of frames
    vidHeight = obj.Height;
    vidWidth = obj.Width;
    %define the threshold for number of features to be matched  
    Feature_Thres=3;
    %iterate from frame 900 to 945 - total 46 frames 
     if b_box ==1
     figure();
     end
    for i = 900:945
        %read the frame from video sequence
        currFrame = read(obj,i); 
        
        % To display the frame
        if(b_box == 1)
        imshow(currFrame);
        str = sprintf('Frame %d ',i);
        title(str);
        end
        %convert it into grayscale
        sceneImage=rgb2gray(currFrame);
        %sharpen the frame so that more distinct features cn be seen 
        sceneImage = imsharpen(sceneImage);
        %extract surf features using Compute_SURF_DES_KP function 
        [sceneFeatures, scenePoints]  =Compute_SURF_DES_KP(sceneImage);
        %find the matching features point between logo and the frame
        [matchedlogoPoints, matchedScenePoints,logoct,scenect]=find_matchpts(logoPoints,scenePoints,logoFeatures,sceneFeatures);
        % compare the number of features matched with user defined threshold
        %the first_pass_res entry 1 is a flag to denote if logo was present in that frame
        %the entries 2 to 5 is [xpt ypt width height] where (xpt, ypt) are the upper left coordinate of rectagular box
        %and width and height are properties that excep from this point
        
        % If nummber of features matched is less than user defined threshold
        % Then make all entries of the first_pass_res as zero 
        % Else do MSAC and get bounding box 
        % Then check bounding box coordinates 
        % If they are less than 1 discard it
        % If the width is smaller than height, discard it.
        % else save the bounding box coordinate and mark first entry of first_pass_res as 1
        
        if logoct<Feature_Thres &&  scenect <Feature_Thres
            %effectively scaled for multiple logos in our case just 2
            First_pass_res(i,1+5*(ii-1))=0;
            First_pass_res(i,2+5*(ii-1):5+5*(ii-1))=0;
        else
            [tform, inlierlogoPoints, inlierScenePoints] = estimateGeometricTransform(matchedlogoPoints, matchedScenePoints,'affine'); 
            newlogoPolygon = transformPointsForward(tform, logoPolygon);

            [xpt, ypt, width, height]=Box_Dim(newlogoPolygon,tol);
        
            if  (xpt<1 | ypt<1 | width <1 | height <1 )
                First_pass_res(i,1+5*(ii-1))=0;
                First_pass_res(i,2+5*(ii-1):5+5*(ii-1))=0;
            else
                if abs(width) < abs(height) 
                    First_pass_res(i,1+5*(ii-1))=0;
                    First_pass_res(i,2+5*(ii-1):5+5*(ii-1))=0;
                    
                else    
                    count_matches(ii) = count_matches(ii) + 1;
                    % To view height and width of bounding box
%                     str = sprintf('i is %d and width is %d and height is %d  ',i,abs(width),abs(height));
%                     disp(str);
                    First_pass_res(i,1+5*(ii-1))=1;
                    First_pass_res(i,2+5*(ii-1):5+5*(ii-1))=[xpt ypt width height];
                    croppedone = imcrop(sceneImage,[xpt ypt width height]);
                    str = sprintf('i is %d ',i);
         
                    
                    % To display bounding box
                    if b_box ==1
                        
                        hold on;
                        line(newlogoPolygon(:, 1), newlogoPolygon(:, 2), 'Color', 'y');
                        
                    end
                    
                     % To display cropped logo
                    if debug==1
                        figure(),
                        imshow(croppedone)
                        title(str)
                    end
                 end
            end
        end
    end

end 

%save the first_pass_res array so that these coodinates can be used for second pass
save ('points.mat','First_pass_res');
%save the total number of times the logo is detected in first pass
save('pass_one.mat','count_matches');



