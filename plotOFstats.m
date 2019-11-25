
%% parameters
% N-by-3 file index, columns arranged as habi->fam->nor
fileIndx = [525,526,527;
           531,532,533;
           537,538,539];
fileIndx(:,:,2) = [528,529,530;
                   534,535,536;
                   540,541,542];
datapath = 'E:\Data\mouse_behavior\results\stats\';
savepath = 'E:\Data\mouse_behavior\results\stats\';
figpath = 'E:\Data\mouse_behavior\results\fig\';
obj_expt_thresh = 5*60; % in seconds
p = 0.05;

%% load data
numExpt = size(fileIndx,1);

% initialize
edge_time_all = zeros(numExpt,2);
cent_time_all = zeros(numExpt,2);
rest_time_all = zeros(numExpt,2);
fam_region_time_expt_all = zeros(numExpt,2,2);
nor_region_time_expt_all = zeros(numExpt,2,2);
fam_region_time_thresh_all = zeros(numExpt,2,2);
nor_region_time_thresh_all = zeros(numExpt,2,2);
fam_obj_time_thresh_all = zeros(numExpt,2,2);
nor_obj_time_thresh_all = zeros(numExpt,2,2);
fam_obj_time_expt_all = zeros(numExpt,2,2);
nor_obj_time_expt_all = zeros(numExpt,2,2);
fam_obj_cut_all = zeros(numExpt,2);
nor_obj_cut_all = zeros(numExpt,2);
tw_dist_all = cell(numExpt,2);

% go through files
for n = 1:numExpt
    
    % pre
    movieParam = paramAll(fileIndx(n,1,1));
    load([datapath movieParam.fileName '_results.mat']);
    
    edge_time_all(n,1) = edge_time/movieParam.fr;
    cent_time_all(n,1) = cent_time/movieParam.fr;
    rest_time_all(n,1) = rest_time/movieParam.fr;
    tw_dist_all{n,1} = tw_dist;
    fam_obj_time_thresh_all(n,1,1) = fam_obj_time_thresh(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    fam_obj_time_thresh_all(n,1,2) = fam_obj_time_thresh(nor_obj_indx)...
        /movieParam.fr;
    fam_obj_time_expt_all(n,1,1) = fam_obj_time_expt(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    fam_obj_time_expt_all(n,1,2) = fam_obj_time_expt(nor_obj_indx)/movieParam.fr;
    fam_region_time_expt_all(n,1,1) = fam_region_time_expt(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    fam_region_time_expt_all(n,1,2) = fam_region_time_expt(nor_obj_indx)/movieParam.fr;
    fam_region_time_thresh_all(n,1,1) = fam_region_time_thresh(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    fam_region_time_thresh_all(n,1,2) = fam_region_time_thresh(nor_obj_indx)/movieParam.fr;
    fam_obj_cut_all(n,1) = fam_obj_cut_time;
    nor_obj_time_thresh_all(n,1,1) = nor_obj_time_thresh(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    nor_obj_time_thresh_all(n,1,2) = nor_obj_time_thresh(nor_obj_indx)/movieParam.fr;
    nor_obj_time_expt_all(n,1,1) = nor_obj_time_expt(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    nor_obj_time_expt_all(n,1,2) = nor_obj_time_expt(nor_obj_indx)/movieParam.fr;
    nor_region_time_expt_all(n,1,1) = nor_region_time_expt(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    nor_region_time_expt_all(n,1,2) = nor_region_time_expt(nor_obj_indx)/movieParam.fr;
    nor_region_time_thresh_all(n,1,1) = nor_region_time_thresh(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    nor_region_time_thresh_all(n,1,2) = nor_region_time_thresh(nor_obj_indx)/movieParam.fr;
    nor_obj_cut_all(n,1) = nor_obj_cut_time;
    
    
    % post
    movieParam = paramAll(fileIndx(n,1,2));
    load([datapath movieParam.fileName '_results.mat']);
    
    edge_time_all(n,2) = edge_time/movieParam.fr;
    cent_time_all(n,2) = cent_time/movieParam.fr;
    rest_time_all(n,2) = rest_time/movieParam.fr;
    tw_dist_all{n,2} = tw_dist;
    fam_obj_time_thresh_all(n,2,1) = fam_obj_time_thresh(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    fam_obj_time_thresh_all(n,2,2) = fam_obj_time_thresh(nor_obj_indx)/movieParam.fr;
    fam_obj_time_expt_all(n,2,1) = fam_obj_time_expt(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    fam_obj_time_expt_all(n,2,2) = fam_obj_time_expt(nor_obj_indx)/movieParam.fr;
    fam_region_time_expt_all(n,2,1) = fam_region_time_expt(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    fam_region_time_expt_all(n,2,2) = fam_region_time_expt(nor_obj_indx)...
        /movieParam.fr;
    fam_region_time_thresh_all(n,2,1) = fam_region_time_thresh(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    fam_region_time_thresh_all(n,2,2) = fam_region_time_thresh(nor_obj_indx)...
        /movieParam.fr;fam_obj_cut_all(n,2) = fam_obj_cut_time;
    nor_obj_time_thresh_all(n,2,1) = nor_obj_time_thresh(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    nor_obj_time_thresh_all(n,2,2) = nor_obj_time_thresh(nor_obj_indx)/movieParam.fr;
    nor_obj_time_expt_all(n,2,1) = nor_obj_time_expt(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    nor_obj_time_expt_all(n,2,2) = nor_obj_time_expt(nor_obj_indx)/movieParam.fr;
    nor_region_time_expt_all(n,2,1) = nor_region_time_expt(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    nor_region_time_expt_all(n,2,2) = nor_region_time_expt(nor_obj_indx)/movieParam.fr;
    nor_region_time_thresh_all(n,2,1) = nor_region_time_thresh(setdiff(1:2,nor_obj_indx))...
        /movieParam.fr;
    nor_region_time_thresh_all(n,2,2) = nor_region_time_thresh(nor_obj_indx)/movieParam.fr;
    nor_obj_cut_all(n,2) = nor_obj_cut_time;
    
end

%% habituation plots
h = figure;
set(h,'color','w','position',[1992,394,595,518],'PaperPositionMode','auto')
gridsz = 0.2;

% edge time
subplot(2,2,1);
hold on;
scatter((1-gridsz)*ones(size(edge_time_all,1),1),...
    edge_time_all(:,1),'k','linewidth',1);
scatter((1+gridsz)*ones(size(edge_time_all,1),1),...
    edge_time_all(:,2),'k','filled','linewidth',1);
plot((ones(size(edge_time_all,1),1)*[(1-gridsz),(1+gridsz)])',...
    edge_time_all','k-');
[~,pval] = ttest(edge_time_all(:,1),edge_time_all(:,2));
if pval<p
    scatter(1,1.2*max(edge_time_all(:)),20,'k*');
end
xlim([1-gridsz*2,1+gridsz*2]);
set(gca,'xtick',[1-gridsz,1+gridsz],'xticklabel',{'pre','post'})
ylabel('edge time (s)');
box off

% center time
subplot(2,2,2);
hold on;
scatter((1-gridsz)*ones(size(cent_time_all,1),1),...
    cent_time_all(:,1),'k','linewidth',1);
scatter((1+gridsz)*ones(size(cent_time_all,1),1),...
    cent_time_all(:,2),'k','filled','linewidth',1);
plot((ones(size(cent_time_all,1),1)*[(1-gridsz),(1+gridsz)])',...
    cent_time_all','k-');
[~,pval] = ttest(cent_time_all(:,1),cent_time_all(:,2));
if pval<p
    scatter(1,1.2*max(cent_time_all(:)),20,'k*');
end
xlim([1-gridsz*2,1+gridsz*2]);
set(gca,'xtick',[1-gridsz,1+gridsz],'xticklabel',{'pre','post'})
ylabel('center time (s)');
box off

% rest time
subplot(2,2,3);
hold on;
scatter((1-gridsz)*ones(size(rest_time_all,1),1),...
    rest_time_all(:,1),'k','linewidth',1);
scatter((1+gridsz)*ones(size(rest_time_all,1),1),...
    rest_time_all(:,2),'k','filled','linewidth',1);
plot((ones(size(cent_time_all,1),1)*[(1-gridsz),(1+gridsz)])',...
    rest_time_all','k-');
[~,pval] = ttest(rest_time_all(:,1),rest_time_all(:,2));
if pval<p
    scatter(1,1.2*max(rest_time_all(:)),20,'k*');
end
xlim([1-gridsz*2,1+gridsz*2]);
set(gca,'xtick',[1-gridsz,1+gridsz],'xticklabel',{'pre','post'})
ylabel('rest time (s)');
box off

subplot(2,2,4);
hold on;
h = boxplot(cell2mat(tw_dist_all(:,1)),...
    'positions',1-gridsz,'width',gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
h = boxplot(cell2mat(tw_dist_all(:,2)),...
    'positions',1+gridsz,'width',gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
pval = ranksum(cell2mat(tw_dist_all(:,1)),cell2mat(tw_dist_all(:,2)));
if pval<p
    scatter(1,max(cell2mat(tw_dist_all(:))),20,'k*');
end
xlim([1-gridsz*2,1+gridsz*2]);
set(gca,'xtick',[1-gridsz,1+gridsz],'xticklabel',{'pre','post'})
ylabel('distance (box %)')
box off

saveas(gcf,[figpath 'habi_stats.fig']);

%% object exploration plots - by total exploration time
h = figure;
set(h,'color','w','position',[1992,83,854,209],'PaperPositionMode','auto')
gridsz = 0.2;

% object time lateralization
subplot(1,3,1);
hold on;
pre_fam_region_time_ratio = reshape(fam_region_time_expt_all(:,1,2),[],1)./...
    reshape(fam_region_time_expt_all(:,1,1),[],1);
post_fam_region_time_ratio = reshape(fam_region_time_expt_all(:,2,2),[],1)./...
    reshape(fam_region_time_expt_all(:,2,1),[],1);
pre_nor_region_time_ratio = reshape(nor_region_time_expt_all(:,1,2),[],1)./...
    reshape(nor_region_time_expt_all(:,1,1),[],1);
post_nor_region_time_ratio = reshape(nor_region_time_expt_all(:,2,2),[],1)./...
    reshape(nor_region_time_expt_all(:,2,1),[],1);
h = boxplot(pre_fam_region_time_ratio,'positions',1-gridsz,'width',...
    gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
h = boxplot(pre_nor_region_time_ratio,'positions',1+gridsz,'width',...
    gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
h = boxplot(post_fam_region_time_ratio,'positions',2-gridsz,'width',...
    gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
h = boxplot(post_nor_region_time_ratio,'positions',2+gridsz,'width',....
    gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
xlim([1-gridsz*2,2+gridsz*2]);
ylim([0 5]);
set(gca,'xtick',[1-gridsz,1+gridsz,2-gridsz,2+gridsz],'xticklabel',...
    {'pre fam','pre nov','post fam','post nov'},'XTickLabelRotation',45)
ylabel('region t_{nov}/t_{fam}','Interpreter','tex');
box off

% object time ratio
subplot(1,3,2);
hold on;
pre_fam_ratio = reshape(fam_obj_time_thresh_all(:,1,2),[],1)./...
    reshape(fam_obj_time_thresh_all(:,1,1),[],1);
post_fam_ratio = reshape(fam_obj_time_thresh_all(:,2,2),[],1)./...
    reshape(fam_obj_time_thresh_all(:,2,1),[],1);
pre_nor_ratio = reshape(nor_obj_time_thresh_all(:,1,2),[],1)./...
    reshape(nor_obj_time_thresh_all(:,1,1),[],1);
post_nor_ratio = reshape(nor_obj_time_thresh_all(:,2,2),[],1)./...
    reshape(nor_obj_time_thresh_all(:,2,1),[],1);
h = boxplot(pre_fam_ratio,'positions',1-gridsz,'width',gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
h = boxplot(pre_nor_ratio,'positions',1+gridsz,'width',gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
h = boxplot(post_fam_ratio,'positions',2-gridsz,'width',gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
h = boxplot(post_nor_ratio,'positions',2+gridsz,'width',gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
xlim([1-gridsz*2,2+gridsz*2]);
ylim([0 max([pre_nor_ratio(:);pre_fam_ratio(:);...
    post_fam_ratio(:);post_nor_ratio(:)])])
set(gca,'xtick',[1-gridsz,1+gridsz,2-gridsz,2+gridsz],'xticklabel',...
    {'pre fam','pre nov','post fam','post nov'},'XTickLabelRotation',45)
ylabel('t_{nov}/t_{fam}','Interpreter','tex');
box off

% time spent to reach threshold
subplot(1,3,3);
hold on;
h = boxplot(fam_obj_cut_all(:,1),'positions',1-gridsz,'width',gridsz*0.5,...
    'colors','k');
set(h(7,:),'visible','off')
h = boxplot(nor_obj_cut_all(:,1),'positions',1+gridsz,'width',gridsz*0.5,...
    'colors','k');
set(h(7,:),'visible','off')
h = boxplot(fam_obj_cut_all(:,2),'positions',2-gridsz,'width',gridsz*0.5,...
    'colors','k');
set(h(7,:),'visible','off')
h = boxplot(nor_obj_cut_all(:,2),'positions',2+gridsz,'width',gridsz*0.5,...
    'colors','k');
set(h(7,:),'visible','off')
xlim([1-gridsz*2,2+gridsz*2]);ylim([0 max([nor_obj_cut_all(:);fam_obj_cut_all(:)])]);
set(gca,'xtick',[1-gridsz,1+gridsz,2-gridsz,2+gridsz],'xticklabel',...
    {'pre fam','pre nov','post fam','post nov'},'XTickLabelRotation',45)
ylabel('t_{cut off} (s)','Interpreter','tex');
box off


saveas(gcf,[figpath 'obj_expl_stats.fig']);

%% object exploration plots - by experiment time
h = figure;
set(h,'color','w','position',[1992,83,854,209],'PaperPositionMode','auto')
gridsz = 0.2;

% object time lateralization
subplot(1,3,1);
hold on;
pre_fam_region_time_ratio = reshape(fam_region_time_thresh_all(:,1,2),[],1)./...
    reshape(fam_region_time_thresh_all(:,1,1),[],1);
post_fam_region_time_ratio = reshape(fam_region_time_thresh_all(:,2,2),[],1)./...
    reshape(fam_region_time_thresh_all(:,2,1),[],1);
pre_nor_region_time_ratio = reshape(nor_region_time_thresh_all(:,1,2),[],1)./...
    reshape(nor_region_time_thresh_all(:,1,1),[],1);
post_nor_region_time_ratio = reshape(nor_region_time_thresh_all(:,2,2),[],1)./...
    reshape(nor_region_time_thresh_all(:,2,1),[],1);
h = boxplot(pre_fam_region_time_ratio,'positions',1-gridsz,'width',...
    gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
h = boxplot(pre_nor_region_time_ratio,'positions',1+gridsz,'width',...
    gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
h = boxplot(post_fam_region_time_ratio,'positions',2-gridsz,'width',...
    gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
h = boxplot(post_nor_region_time_ratio,'positions',2+gridsz,'width',....
    gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
xlim([1-gridsz*2,2+gridsz*2]);
ylim([0 5]);
set(gca,'xtick',[1-gridsz,1+gridsz,2-gridsz,2+gridsz],'xticklabel',...
    {'pre fam','pre nov','post fam','post nov'},'XTickLabelRotation',45)
ylabel('region t_{nov}/t_{fam}','Interpreter','tex');
box off

% object time ratio
subplot(1,3,2);
hold on;
pre_fam_expt_ratio = reshape(fam_obj_time_expt_all(:,1,2),[],1)./...
    reshape(fam_obj_time_expt_all(:,1,1),[],1);
post_fam_expt_ratio = reshape(fam_obj_time_expt_all(:,2,2),[],1)./...
    reshape(fam_obj_time_expt_all(:,2,1),[],1);
pre_nor_expt_ratio = reshape(nor_obj_time_expt_all(:,1,2),[],1)./...
    reshape(nor_obj_time_expt_all(:,1,1),[],1);
post_nor_expt_ratio = reshape(nor_obj_time_expt_all(:,2,2),[],1)./...
    reshape(nor_obj_time_expt_all(:,2,1),[],1);
h = boxplot(pre_fam_expt_ratio,'positions',1-gridsz,'width',gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
h = boxplot(pre_nor_expt_ratio,'positions',1+gridsz,'width',gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
h = boxplot(post_fam_expt_ratio,'positions',2-gridsz,'width',gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
h = boxplot(post_nor_expt_ratio,'positions',2+gridsz,'width',gridsz*0.5,'colors','k');
set(h(7,:),'visible','off')
xlim([1-gridsz*2,2+gridsz*2]);
ylim([0 max([pre_nor_expt_ratio(:);pre_fam_expt_ratio(:);...
    post_fam_expt_ratio(:);post_nor_expt_ratio(:)])])
set(gca,'xtick',[1-gridsz,1+gridsz,2-gridsz,2+gridsz],'xticklabel',...
    {'pre fam','pre nov','post fam','post nov'},'XTickLabelRotation',45)
ylabel('t_{nov}/t_{fam}','Interpreter','tex');
box off

% total exploration time
subplot(1,3,3);
hold on;
h = boxplot(sum(fam_obj_time_expt_all(:,1,:),3),'positions',1-gridsz,'width',gridsz*0.5,...
    'colors','k');
set(h(7,:),'visible','off')
h = boxplot(sum(nor_obj_time_expt_all(:,1,:),3),'positions',1+gridsz,'width',gridsz*0.5,...
    'colors','k');
set(h(7,:),'visible','off')
h = boxplot(sum(fam_obj_time_expt_all(:,2,:),3),'positions',2-gridsz,'width',gridsz*0.5,...
    'colors','k');
set(h(7,:),'visible','off')
h = boxplot(sum(nor_obj_time_expt_all(:,2,:),3),'positions',2+gridsz,'width',gridsz*0.5,...
    'colors','k');
set(h(7,:),'visible','off')
xlim([1-gridsz*2,2+gridsz*2]);
ylim([0 max([fam_obj_time_expt_all(:);nor_obj_time_expt_all(:)])])
set(gca,'xtick',[1-gridsz,1+gridsz,2-gridsz,2+gridsz],'xticklabel',...
    {'pre fam','pre nov','post fam','post nov'},'XTickLabelRotation',45)
ylabel('t_{explore} (s)','Interpreter','tex');
box off


saveas(gcf,[figpath 'obj_expl_stats.fig']);


