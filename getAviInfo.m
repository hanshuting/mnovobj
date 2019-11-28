function [movieParam] = getAviInfo(findx)
% [movieParam] = getAviInfo(findx)
% AVI indexing code written for mouse behavior experiments, returns a
% structure including all necessary information of avi files
% SH Nov 2017

[fname,fpath] = fileinfo_avi(findx);
vid = VideoReader([fpath '\' fname '.avi']);

movieParam = struct();
movieParam.filePath = fpath;
movieParam.fileName = fname;
movieParam.imageSize = [vid.Height,vid.Width];
movieParam.numImages = round(vid.Duration*vid.FrameRate);
movieParam.fr = vid.FrameRate;

% just to make sure...
if round(movieParam.numImages)~=movieParam.numImages
    warning('numImages seems to be incorrect, please check file');
end

end
