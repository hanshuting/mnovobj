function [movieParam] = getVidInfo(dpath,fileind)
% generate video information

movieParam = struct;
movieParam.filePath = dpath;
[movieParam.fileName,movieParam.numImages,...
    movieParam.fr,movieParam.imageSize] = fileinfo(fileind);

movieParam.frameStart = 1;
movieParam.frameEnd = movieParam.numImages;

end
