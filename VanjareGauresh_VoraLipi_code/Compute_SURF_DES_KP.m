function [Features,Points]=Compute_SURF_DES_KP(image)
    imagePoints = detectSURFFeatures(image);
    [Features, Points] = extractFeatures(image, imagePoints);

end