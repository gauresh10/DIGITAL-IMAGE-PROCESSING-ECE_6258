function [images,nfiles]=get_logos(para)
    cd('logo');
    imagefiles = [dir('*.jpg');dir('*.jpeg')];      
    nfiles = length(imagefiles);    % Number of files found
    %disp(nfiles)
    for ii=1:nfiles
       currentfilename = imagefiles(ii).name;
       currentimage = imread(currentfilename);
       images{ii} = currentimage;
    end
    cd ..
end