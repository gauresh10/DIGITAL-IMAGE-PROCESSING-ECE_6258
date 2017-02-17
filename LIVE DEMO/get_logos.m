function [images,nfiles]=get_logos(para)
    cd('cropped_logo');
    imagefiles = dir('*.jpg');      
    nfiles = length(imagefiles);    % Number of files found
    %disp(nfiles)
    for ii=1:nfiles
       currentfilename = imagefiles(ii).name;
       currentimage = imread(currentfilename);
       images{ii} = currentimage;
    end
    cd ..
end