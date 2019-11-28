function [] = analyzeOFtraj(param)
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
    
    if n==11
        n;
    end
    
    %% habituation
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
    
%     if plot_traj
%         hf2 = figure; set(hf2,'position',[1966 464 1086 213]);
%         subplot(1,4,1); imagesc(box_region+edge_region); axis tight equal; 
%     end
    
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
    
%     if plot_traj
%         figure(hf2);
%         subplot(1,4,2); imagesc(box_region+cent_region); axis tight equal
%     end
    
    % --------- time spent resting ------------%
    min_displ = nanmean(a)/10/movieParam.fr;
    displace = sqrt((centroid(exptIndx(2:end),1)-centroid(exptIndx(1:end-1),1)).^2+...
        (centroid(exptIndx(2:end),2)-centroid(exptIndx(1:end-1),2)).^2);
    rest_time = nansum(displace<min_displ);
    
    % --------- distance traveled in a defined time interval --------- %
    tw_sec = 10; % seconds
    tw = round(tw_sec*movieParam.fr);
    tw_dist = zeros(exptIndx(end)-tw,1);
    for i = 1:tw
        tw_dist = tw_dist+displace(i:exptIndx(end)-tw+i-1);
    end
    tw_dist = tw_dist/box_sz;
    
    
    %% familarization
    % load results
    fprintf('2. familarization\n');
    movieParam = getAviInfo(fileIndx(n,2));
%     movieParam = getVidInfo(dpath{n},fileIndx(n,2));
    dims = [movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages];
    load([segpath movieParam.fileName '_seg.mat']);
    load([infopath movieParam.fileName '_info.mat']);
    
    if movieParam.numImages>=expt_thresh*movieParam.fr;
        exptIndx = 1:expt_thresh*movieParam.fr;
    else
        exptIndx = 1:movieParam.numImages;
    end
    
    if movieParam.numImages>=obj_expt_thresh*movieParam.fr;
        keepIndx = 1:obj_expt_thresh*movieParam.fr;
    else
        keepIndx = 1:movieParam.numImages;
    end
    
    % plot trace
    if plot_traj
        figure(hf); subplot(1,3,2)
        cent_plot = centroid(exptIndx,:);
        cent_plot = cent_plot(~any(isnan(cent_plot)'),:);
        hold on; imagesc(sum(fam_obj_region,3)); colormap(gray);
        plot(cent_plot(:,1),cent_plot(:,2),'r');
        title(movieParam.fileName,'interpreter','none');
        axis equal tight off xy
%         saveas(gcf,[figpath movieParam.fileName '_trajectory.fig']);

%         figure(hf2); subplot(1,4,3);
%         imagesc(sum(fam_obj_region,3)); axis tight equal;
    end
    
    displace_fam = sqrt((centroid(exptIndx(2:end),1)-centroid(exptIndx(1:end-1),1)).^2+...
        (centroid(exptIndx(2:end),2)-centroid(exptIndx(1:end-1),2)).^2);
    
    %------- time of the mouse spent with the objects --------%
    % frames where mouse is close to the object
    fam_obj_dist = zeros(size(centroid,1),num_obj);
    for i = 1:size(centroid,1)
        for j = 1:num_obj
            fam_obj_dist(i,j) = min(pdist2(fam_obj_bdr{j},centroid(i,[2,1])));
        end
    end
    fam_obj_dist = fam_obj_dist(exptIndx,:);
    [fam_obj_dist,fam_obj_num] = min(fam_obj_dist,[],2);
%     fam_obj_time = fam_obj_dist<(nanmean(a)/2+fam_obj_r(fam_obj_num)/2)*r;
    fam_obj_time = fam_obj_dist<nanmean(a)/2*r;
    
    % frames where the mouse is orienting towards the object
    fam_obj_theta = zeros(size(centroid,1),num_obj);
    for i = 1:num_obj
        fam_obj_theta(:,i) = 180-rad2deg(atan2(fam_obj_cent(i,1)-centroid(:,1),...
            fam_obj_cent(i,2)-centroid(:,2)));
    end
    fam_obj_theta(fam_obj_theta>=360) = fam_obj_theta(fam_obj_theta>=360)-360;
    fam_obj_theta(fam_obj_theta<0) = fam_obj_theta(fam_obj_theta<0)+360;
    fam_obj_theta_closest = zeros(size(centroid,1),1);
    for i = 1:length(exptIndx)
        fam_obj_theta_closest(i) = fam_obj_theta(i,fam_obj_num(i));
    end
    fam_obj_time_frame = fam_obj_time & abs(theta(exptIndx)-fam_obj_theta_closest(exptIndx))<60;
    fam_obj_time_final = zeros(num_obj,1);
    for i = 1:num_obj
        fam_obj_time_final(i) = sum(fam_obj_time_frame&fam_obj_num==i);
    end
    
    % ----------- time until test criteria are met ------------ %
    % by experiment time
    fam_obj_time_expt = zeros(num_obj,1);
    for i = 1:num_obj
        fam_obj_time_expt(i) = sum(fam_obj_time_frame(keepIndx)...
            &fam_obj_num(keepIndx)==i);
    end
    
    % by total exploration time
    fam_obj_cum_time = cumsum(fam_obj_time_frame);
    fam_obj_cut_time = find(fam_obj_cum_time>obj_time_thresh*movieParam.fr,1);
    if isempty(fam_obj_cut_time)
        fam_obj_cut_time = exptIndx(end);
    end
    fam_obj_time_thresh = zeros(num_obj,1);
    for i = 1:num_obj
        fam_obj_time_thresh(i) = sum(fam_obj_time_frame(1:fam_obj_cut_time)...
            &fam_obj_num(1:fam_obj_cut_time)==i);
    end
    
    %------- time of the mouse spent on two sides of the box --------%
    fam_obj_midx = mean(fam_obj_cent(:,1));
    
    % by experiment time
    fam_region_time_expt = [sum(centroid(keepIndx,1)<fam_obj_midx),...
        sum(centroid(keepIndx,1)>fam_obj_midx)];
    
    % by total exploration
    fam_region_time_thresh = [sum(centroid(1:fam_obj_cut_time,1)<fam_obj_midx),...
        sum(centroid(1:fam_obj_cut_time,1)>fam_obj_midx)];
    
    
    %% novel object
    if isnan(fileIndx(n,3))
        nor_obj_time_frame = NaN;
        nor_obj_time_final = [0 0];
        nor_obj_indx = 1;
        nor_obj_time_thresh = [NaN NaN];
        nor_obj_cut_time = NaN;
        nor_region_time_expt = [0 0];
        nor_region_time_thresh = [NaN NaN];
        nor_obj_time_expt = [0 0];
        nor_obj_num = NaN;
        displace_nor = 0;
    else

        % load results
        fprintf('3. novel object\n');
        movieParam = getAviInfo(fileIndx(n,3));
%         movieParam = getVidInfo(dpath{n},fileIndx(n,3));
        dims = [movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages];
        load([segpath movieParam.fileName '_seg.mat']);
        load([infopath movieParam.fileName '_info.mat']);

        if movieParam.numImages>=expt_thresh*movieParam.fr;
            exptIndx = 1:expt_thresh*movieParam.fr;
        else
            exptIndx = 1:movieParam.numImages;
        end

        if movieParam.numImages>=obj_expt_thresh*movieParam.fr;
            keepIndx = 1:obj_expt_thresh*movieParam.fr;
        else
            keepIndx = 1:movieParam.numImages;
        end

        % plot trace
        if plot_traj
            figure(hf); subplot(1,3,3)
            cent_plot = centroid(exptIndx,:);
            cent_plot = cent_plot(~any(isnan(cent_plot)'),:);
            hold on; imagesc(sum(nor_obj_region,3)); colormap(gray);
            plot(cent_plot(:,1),cent_plot(:,2),'r');
            title(movieParam.fileName,'interpreter','none');
            axis equal tight off xy
            saveas(gcf,[figpath movieParam.fileName '_trajectory.fig']);
            
%             figure(hf2); subplot(1,4,4);
%             imagesc(sum(nor_obj_region,3)); axis equal tight;
%             title(movieParam.fileName,'interpreter','none');
        end
        
        displace_nor = sqrt((centroid(exptIndx(2:end),1)-centroid(exptIndx(1:end-1),1)).^2+...
            (centroid(exptIndx(2:end),2)-centroid(exptIndx(1:end-1),2)).^2);
        
        %------- time of the mouse spent with the objects --------%
        % frames where mouse is close to the object
        nor_obj_dist = zeros(size(centroid,1),num_obj);
        for i = 1:size(centroid,1)
            for j = 1:num_obj
                nor_obj_dist(i,j) = min(pdist2(nor_obj_bdr{j},centroid(i,[2,1])));
            end
        end
        nor_obj_dist = nor_obj_dist(exptIndx,:);
        [nor_obj_dist,nor_obj_num] = min(nor_obj_dist,[],2);
%         nor_obj_time = nor_obj_dist<(nanmean(a)/2+nor_obj_r(nor_obj_num)/2)*r;
        nor_obj_time = nor_obj_dist<nanmean(a)/2*r;

        % frames where the mouse is orienting towards the object
        nor_obj_theta = zeros(size(centroid,1),num_obj);
        for i = 1:num_obj
            nor_obj_theta(:,i) = 180-rad2deg(atan2(nor_obj_cent(i,1)-centroid(:,1),...
                nor_obj_cent(i,2)-centroid(:,2)));
        end
        nor_obj_theta(nor_obj_theta>=360) = nor_obj_theta(nor_obj_theta>=360)-360;
        nor_obj_theta(nor_obj_theta<0) = nor_obj_theta(nor_obj_theta<0)+360;
        nor_obj_theta_closest = zeros(size(centroid,1),1);
        for i = 1:length(exptIndx)
            nor_obj_theta_closest(i) = nor_obj_theta(i,nor_obj_num(i));
        end
        nor_obj_time_frame = nor_obj_time & abs(theta(exptIndx)-nor_obj_theta_closest(exptIndx))<60;
        nor_obj_time_final = zeros(num_obj,1);
        for i = 1:num_obj
            nor_obj_time_final(i) = sum(nor_obj_time_frame&nor_obj_num==i);
        end

        % ----------- time until test criteria are met ------------ %
        % by experiment time
        nor_obj_time_expt = zeros(num_obj,1);
        for i = 1:num_obj
            nor_obj_time_expt(i) = sum(nor_obj_time_frame(keepIndx)...
                &nor_obj_num(keepIndx)==i);
        end

        % by total exploration time
        nor_obj_cum_time = cumsum(nor_obj_time_frame);
        nor_obj_cut_time = find(nor_obj_cum_time>obj_time_thresh*movieParam.fr,1);
        if isempty(nor_obj_cut_time)
            nor_obj_cut_time = exptIndx(end);
        end
        nor_obj_time_thresh = zeros(num_obj,1);
        for i = 1:num_obj
            nor_obj_time_thresh(i) = sum(nor_obj_time_frame(1:nor_obj_cut_time)...
                &nor_obj_num(1:nor_obj_cut_time)==i);
        end

        %------- time of the mouse spent on two sides of the box --------%
        nor_obj_midx = mean(nor_obj_cent(:,1));

        % by experiment time
        nor_region_time_expt = [sum(centroid(keepIndx,1)<nor_obj_midx),...
            sum(centroid(keepIndx,1)>nor_obj_midx)];

        % by total exploration time
        nor_region_time_thresh = [sum(centroid(1:nor_obj_time_thresh,1)<nor_obj_midx),...
            sum(centroid(1:nor_obj_time_thresh,1)>nor_obj_midx)];
        
    end
    
    %% save results
    fprintf('saving results...\n');
%     fname = fileinfo(fileIndx(n,1));
    fname = fileinfo_avi(fileIndx(n,1));
    save([savepath fname '_results.mat'],'edge_time',...
        'cent_time','rest_time','fam_obj_time_frame','fam_obj_time_final',...
        'nor_obj_time_frame','nor_obj_time_final','nor_obj_indx',...
        'fam_obj_time_thresh','nor_obj_time_thresh','tw_dist',...
        'fam_obj_cut_time','nor_obj_cut_time','fam_region_time_expt',...
        'fam_region_time_thresh','nor_region_time_expt',...
        'nor_region_time_thresh','fam_obj_time_expt','nor_obj_time_expt',...
        'fam_obj_num','nor_obj_num','displace','displace_fam','displace_nor');
    
end

end
