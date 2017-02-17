function[matchptsquerry, matchptsframe,matchptsquerryct,matchptsframect ]=find_matchpts(querrypts,framepts,querryFeatures,frameFeatures)

    logoPairs = matchFeatures(querryFeatures, frameFeatures );
    matchptsquerry =  querrypts( logoPairs(:, 1), :);
    matchptsframe = framepts( logoPairs(:, 2), :);
    matchptsquerryct=matchptsquerry.Count;
    matchptsframect=matchptsframe.Count;
end