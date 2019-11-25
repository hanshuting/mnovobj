function [] = getObjExptInfo(param)
% get object information in habituation, familarization and novel object
% exploration experiments

%% extract parameters
fileIndx = param.fileIndx;
% dpath = param.dpath;
savepath = param.spath.finfo;
num_obj = param.num_obj;

%% process each experiment
numExpt = size(fileIndx,1);
for n = 1:numExpt
    
    fprintf('\n*********************************************************\n');

    %% habituation
    [fname,fpath] = fileinfo_mikki_avi(fileIndx(n,1));
    fprintf('%s\n',fname);
    % movieParam = getVidInfo_mikki(dpath{n},fileIndx(n,1));
    % fprintf('%s\n',movieParam.fileName');
    fprintf('----------Habituation experiment----------\n');
    
    % select experiment box region
    vid = VideoReader([fpath '\' fname '.avi']);
    im = rgb2gray(readFrame(vid));
    % im = double(imread([movieParam.filePath movieParam.fileName '.tif'],1));
    figure;set(gcf,'color','w');
    imagesc(im);colormap(gray);
    fprintf('left click to draw boundary, right click to exit\n');
    title('select box region:');
    axis equal tight off
    [roi,Xsp,Ysp] = choose_polygon2(size(im,2),size(im,1));
    close
    % fprintf('\n');
    box_sz = mean([abs(Xsp(3)-Xsp(2)),abs(Xsp(4)-Xsp(1)),...
        abs(Ysp(1)-Ysp(2)),abs(Ysp(3)-Ysp(4))]);
    box_region = false(size(im));
    box_region(roi) = 1;
    box_bdr = cell2mat(bwboundaries(box_region));
    box_cent = struct2array(regionprops(box_region,'centroid'));
    
    % save([savepath movieParam.fileName '_info.mat'],'box_sz','box_region');
    save([savepath fname '_info.mat'],'box_sz','box_region');
    
    %% familarization
    if ~isnan(fileIndx(n,2))
        
    fprintf('----------Familarization experiment----------\n');
    [fname,fpath] = fileinfo_mikki_avi(fileIndx(n,2));
    % movieParam = getVidInfo_mikki(dpath{n},fileIndx(n,2));
    
    % select objects
    vid = VideoReader([fpath '\' fname '.avi']);
    im = rgb2gray(readFrame(vid));
    % im = double(imread([movieParam.filePath movieParam.fileName '.tif'],1));
    figure;set(gcf,'color','w');
    imagesc(im);colormap(gray);
    title('select object region');
    axis equal tight off
    fam_obj_roi = cell(num_obj,1);
    fprintf('left click to draw boundary, right click to exit\n');
    for i = 1:num_obj
        fprintf('choose the region of object %u: ',i);
        [roi,Xsp,Ysp] = choose_polygon2(size(im,2),size(im,1));
        fam_obj_roi{i} = roi;
        fprintf('\n');
    end
    % fprintf('\n');
    set(gcf,'position',[97 682 560 420])
    title('familarization')
    
    % object information
    fam_obj_region = zeros([size(im),num_obj]);
    fam_obj_r = zeros(num_obj,1);
    fam_obj_bdr = cell(num_obj,1);
    fam_obj_cent = zeros(num_obj,2);
    for i = 1:num_obj
        obj_region_single = false(size(im));
        obj_region_single(fam_obj_roi{i}) = 1;
        fam_obj_region(:,:,i) = obj_region_single;
        fam_obj_bdr{i} = cell2mat(bwboundaries(obj_region_single));
        fam_obj_r(i) = sqrt(length(fam_obj_roi{i}));
        obj_cent_single = regionprops(double(obj_region_single),'centroid');
        fam_obj_cent(i,:) = struct2array(obj_cent_single);
    end
    
%     save([savepath movieParam.fileName '_info.mat'],'fam_obj_roi',...
%         'fam_obj_region','fam_obj_r','fam_obj_bdr','fam_obj_cent');
    save([savepath fname '_info.mat'],'fam_obj_roi','fam_obj_region','fam_obj_r','fam_obj_bdr','fam_obj_cent');
    
    end
    
    %% novel object
    if ~isnan(fileIndx(n,3))
    
    fprintf('----------Novel object experiment----------\n');
    [fname,fpath] = fileinfo_mikki_avi(fileIndx(n,3));
    % movieParam = getVidInfo_mikki(dpath{n},fileIndx(n,3));
    
    % select objects
    vid = VideoReader([fpath '\' fname '.avi']);
    im = rgb2gray(readFrame(vid));
    % im = double(imread([movieParam.filePath movieParam.fileName '.tif'],1));
    figure;set(gcf,'color','w');
    imagesc(im);colormap(gray);
    title('select object region');
    axis equal tight off
    num_obj = 2;
    nor_obj_roi = cell(num_obj,1);
    fprintf('left click to draw boundary, right click to exit\n');
    for i = 1:num_obj
        fprintf('choose the region of object %u: ',i);
        [roi,Xsp,Ysp] = choose_polygon2(size(im,2),size(im,1));
        nor_obj_roi{i} = roi;
        fprintf('\n');
    end
    nor_obj_indx = input('novel object index: ');
    % fprintf('\n');
    close all
    
    % object information
    nor_obj_region = zeros([size(im),num_obj]);
    nor_obj_r = zeros(num_obj,1);
    nor_obj_bdr = cell(num_obj,1);
    nor_obj_cent = zeros(num_obj,2);
    for i = 1:num_obj
        obj_region_single = false(size(im));
        obj_region_single(nor_obj_roi{i}) = 1;
        nor_obj_region(:,:,i) = obj_region_single;
        nor_obj_bdr{i} = cell2mat(bwboundaries(obj_region_single));
        nor_obj_r(i) = sqrt(length(nor_obj_roi{i}));
        obj_cent_single = regionprops(double(obj_region_single),'centroid');
        nor_obj_cent(i,:) = struct2array(obj_cent_single);
    end
    
%     save([savepath movieParam.fileName '_info.mat'],'nor_obj_roi',...
%         'nor_obj_region','nor_obj_r','nor_obj_bdr','nor_obj_cent',...
%         'nor_obj_indx');
    save([savepath fname '_info.mat'],'nor_obj_roi',...
        'nor_obj_region','nor_obj_r','nor_obj_bdr','nor_obj_cent',...
        'nor_obj_indx');
    
    end
    
    close all
    
end

end