function [] = analyzeOFonly(param)
% Analysis for open field behavior experiments, this scripts combines all
% post-processing from the tracking result
% SH Nov 2017

%% extract parameters
fileIndx = param.fileIndx;
% dpath = param.dpath;
infopath = param.spath.finfo;
segpath = param.spath.seg;
savepath = param.spath.stats;
figpath = param.spath.fig;
obj_time_thresh = param.obj_time_thresh; % total exploration time cut off for object experiments
expt_thresh = param.expt_thresh;
obj_expt_thresh = param.obj_expt_thresh;
num_obj = param.num_obj;
r = param.r;
plot_traj = param.plot_traj;

%% analyze videos
numExpt = size(fileIndx,1);
for n = 1:numExpt
    
%     if n==11
%         n;
%     end
    
    % load results
    % movieParam = getVidInfo(dpath{n},fileIndx(n,1));
    movieParam = getAviInfo(fileIndx(n,1));
    fprintf('\nanalyzing %s...\n',movieParam.fileName);
    fprintf('1. habituation\n');
    if movieParam.numImages>=expt_thresh*movieParam.fr;
        exptIndx = 1:expt_thresh*movieParam.fr;
    else
        exptIndx = 1:movieParam.numImages;
    end
    dims = [movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages];
    load([segpath movieParam.fileName '_seg.mat']);
    load([infopath movieParam.fileName '_info.mat']);
    
%     if movieParam.numImages>=obj_expt_thresh*movieParam.fr;
%         keepIndx = 1:obj_expt_thresh*movieParam.fr;
%     else
%         keepIndx = 1:movieParam.numImages;
%     end
    
    %-------- plot trajectory and density -------%
    % density map
%     cent_centroid = centroid-ones(size(centroid,1),1)*(dims(1:2)/2);
%     maxVal = max(movieParam.imageSize/2);
%     sigma = maxVal/40;
%     numPoints = ceil(maxVal*2);
%     rangeVals = [-maxVal maxVal];
%     [xx,dens] = findPointDensity(cent_centroid,sigma,numPoints,rangeVals);

    % plot trajectory
    if plot_traj
        hf = figure;set(gcf,'color','w','position',[1962 768 1076 273]);
        subplot(1,3,1)
        cent_plot = centroid(exptIndx,:);
        cent_plot = cent_plot(~any(isnan(cent_plot)'),:);
        plot(cent_plot(:,1),cent_plot(:,2),'k');
        title(movieParam.fileName,'interpreter','none');
        axis equal tight off xy
    end
    
    % density
%     figure;set(gcf,'color','w');
%     imagesc(dens);
%     title(movieParam.fileName,'interpreter','none');
%     axis equal tight off xy
%     saveas(gcf,[figpath movieParam.fileName '_density.fig']);

    % --------- time spent at edges ------------ %
    edge_dist = round(1/4*box_sz);
%     edge_region = true(dims(1),dims(2));
%     edge_region(edge_dist+1:dims(1)-edge_dist,edge_dist+1:dims(2)-edge_dist) = 0;
    edge_region = box_region&(~imerode(box_region,strel('square',round(edge_dist))));
    edge_time = 0;
    for i = 1:exptIndx(end)
        indx1 = max([1,round(centroid(i,2))]);
        indx2 = max([1,round(centroid(i,1))]);
        if edge_region(indx1,indx2)==1
            edge_time = edge_time+1;
        end
    end
    
    % --------- time spent in the center ---------- %
    cent_dist = round(4/12*box_sz);
    box_cent = round(dims(1:2)/2);
    cent_region = false(dims(1),dims(2));
    cent_region(box_cent(1)-cent_dist:box_cent(1)+cent_dist,box_cent(2)-...
        cent_dist:box_cent(2)+cent_dist) = 1;
    cent_time = 0;
    for i = 1:exptIndx(end)
        indx1 = max([1,round(centroid(i,2))]);
        indx2 = max([1,round(centroid(i,1))]);
        if cent_region(indx1,indx2)==1
            cent_time = cent_time+1;
        end
    end
    
    % --------- time spent resting ------------%
    min_displ = nanmean(a)/10/movieParam.fr;
    displace = sqrt((centroid(exptIndx(2:end),1)-centroid(exptIndx(1:end-1),1)).^2+...
        (centroid(exptIndx(2:end),2)-centroid(exptIndx(1:end-1),2)).^2);
    rest_time_indx = displace<min_displ;
    run_time_indx = ~rest_time_indx;
    rest_time = nansum(rest_time_indx);
    
    indx = sub2ind(dims(1:2),ceil(centroid(rest_time_indx,2)),ceil(centroid(rest_time_indx,1)));
    indx = indx(~isnan(indx));
    rest_time_center = sum(cent_region(indx))/movieParam.fr;
    
    indx = sub2ind(dims(1:2),ceil(centroid(run_time_indx,2)),ceil(centroid(run_time_indx,1)));
    indx = indx(~isnan(indx));
    run_time_center = sum(cent_region(indx))/movieParam.fr;
    
    indx = sub2ind(dims(1:2),ceil(centroid(rest_time_indx,2)),ceil(centroid(rest_time_indx,1)));
    indx = indx(~isnan(indx));
    rest_time_edge = sum(edge_region(indx))/movieParam.fr;
    
    indx = sub2ind(dims(1:2),ceil(centroid(run_time_indx,2)),ceil(centroid(run_time_indx,1)));
    indx = indx(~isnan(indx));
    run_time_edge = sum(edge_region(indx))/movieParam.fr;
    
    
%     rest_time_center = sum(cent_region(sub2ind(dims(1:2),ceil(centroid(rest_time_indx,2)),...
%         ceil(centroid(rest_time_indx,1)))))/movieParam.fr;
%     run_time_center = sum(cent_region(sub2ind(dims(1:2),ceil(centroid(run_time_indx,2)),...
%         ceil(centroid(run_time_indx,1)))))/movieParam.fr;
%     rest_time_edge = sum(edge_region(sub2ind(dims(1:2),ceil(centroid(rest_time_indx,2)),...
%         ceil(centroid(rest_time_indx,1)))))/movieParam.fr;
%     run_time_edge = sum(edge_region(sub2ind(dims(1:2),ceil(centroid(run_time_indx,2)),...
%         ceil(centroid(run_time_indx,1)))))/movieParam.fr;
    
    % number of stop time
    conv_tw = ones(round(1*movieParam.fr),1); % 1s convolution window
    rest_time_conv = logical(conv(double(rest_time_indx),conv_tw,'same'));
    num_stop = sum(diff(rest_time_conv)==1);
    
    % average speed
    spd = sum(run_time_indx)/nansum(displace(run_time_indx))/movieParam.fr;
    
    % corner time
    corner_region = false(dims(1),dims(2));
    [xx,yy] = ind2sub(dims(1:2),find(edge_region==1));
    box_xmin = min(xx); box_xmax = max(xx);
    box_ymin = min(yy); box_ymax = max(yy);
    corner_mask_indx = ((xx>(box_xmax-edge_dist)) | (xx<(box_xmin+edge_dist)))...
        & ((yy>(box_ymax-edge_dist)) | (yy<(box_ymin+edge_dist)));
    corner_mask_indx = sub2ind(dims(1:2),xx(corner_mask_indx),yy(corner_mask_indx));
    corner_region(corner_mask_indx) = 1;
    corner_rest_time = sum(corner_region(sub2ind(dims(1:2),round(centroid(rest_time_indx,2)),...
        round(centroid(rest_time_indx,1)))))/movieParam.fr;
    
    % --------- distance traveled in a defined time interval --------- %
    tw_sec = 10; % seconds
    tw = round(tw_sec*movieParam.fr);
    tw_dist = zeros(exptIndx(end)-tw,1);
    for i = 1:tw
        tw_dist = tw_dist+displace(i:exptIndx(end)-tw+i-1);
    end
    tw_dist = tw_dist/box_sz;
    
    save([savepath movieParam.fileName '_results_OFonly.mat'],'edge_time','cent_time','rest_time',...
        'rest_time_center','rest_time_edge','run_time_center','run_time_edge',...
        'corner_rest_time','spd','num_stop','displace','tw_dist','-v7.3');
    
end
