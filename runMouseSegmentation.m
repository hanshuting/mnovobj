function [] = runMouseSegmentation(param)
% Segmentation code for mouse behavior experiments, this is the main
% framework of dealing with all three conditions
% SH Nov 2017

%% extract parameters
fileIndx = param.fileIndx;
% dpath = param.dpath;
infopath = param.spath.finfo;
savepath = param.spath.seg;

%% process files
for n = 1:size(fileIndx,1)
    
    movieParam = getAviInfo(fileIndx(n,1));
    % movieParam = getVidInfo(dpath{n},fileIndx(n,1));
    objinfo_name = movieParam.fileName;
    fprintf('processing %s...\n',movieParam.fileName);
    if ~exist([savepath movieParam.fileName '_seg.mat'],'file')
        obj_region = false([movieParam.imageSize 2]);
        load([infopath movieParam.fileName '_info.mat']);
        [segAll,theta,centroid,a,b] = trackOFMouse(movieParam,box_region,obj_region);
        save([savepath movieParam.fileName '_seg.mat'],'segAll','theta',...
            'centroid','a','b','-v7.3');
    else
        fprintf('segmentation file exists, skipping this file\n');
    end
    
    if ~isnan(fileIndx(n,2))
        movieParam = getAviInfo(fileIndx(n,2));
        fprintf('processing %s...\n',movieParam.fileName);
        if ~exist([savepath movieParam.fileName '_seg.mat'],'file')
            load([infopath objinfo_name '_info.mat']);
            load([infopath movieParam.fileName '_info.mat']);
            [segAll,theta,centroid,a,b] = trackOFMouse(movieParam,box_region,fam_obj_region);
            save([savepath movieParam.fileName '_seg.mat'],'segAll','theta',...
                'centroid','a','b','-v7.3');
        else
            fprintf('segmentation file exists, skipping this file\n');
        end
    end
    
    if ~isnan(fileIndx(n,3))
        movieParam = getAviInfo(fileIndx(n,3));
        fprintf('processing %s...\n',movieParam.fileName);
        if ~exist([savepath movieParam.fileName '_seg.mat'],'file')
            load([infopath objinfo_name '_info.mat']);
            load([infopath movieParam.fileName '_info.mat']);
            [segAll,theta,centroid,a,b] = trackOFMouse(movieParam,box_region,nor_obj_region);
            save([savepath movieParam.fileName '_seg.mat'],'segAll','theta',...
                'centroid','a','b','-v7.3');
        else
            fprintf('segmentation file exists, skipping this file\n');
        end
    end
    
end

end
