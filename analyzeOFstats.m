function [] = analyzeOFstats(param)

%% extract parameters
ctrlIndx = param.ctrlIndx;
exptIndx = param.exptIndx;
% preIndx = param.preIndx;
% postIndx = param.postIndx;
statspath = param.spath.stats;
figpath = param.spath.fig;
p = param.p;

%% initialize
% numExpt = size(preIndx,1);
edge_time_all = cell(2,2);
cent_time_all = cell(2,2);
rest_time_all = cell(2,2);
displace_all = cell(2,2);
displace_fam_all = cell(2,2);
displace_nov_all = cell(2,2);

fam_obj_time_all = cell(2,2);
nor_obj_time_all = cell(2,2);
fam_region_time_all = cell(2,2);
nor_region_time_all = cell(2,2);

fam_expt_time_all = cell(2,2);
nor_expt_time_all = cell(2,2);

fam_cut_time_all = cell(2,2);
nor_cut_time_all = cell(2,2);

%% load data
fprintf('loading data...\n');

% ctrl, pre
for ii = 1:2 % 1: ctrl; 2: expt
    for jj = 1:2 % 1: pre; 2: post
        if ii==1
            indx = ctrlIndx{jj};
        else
            indx = exptIndx{jj};
        end
        for n = 1:size(indx,1)

%             movieParam = getVidInfo('',indx(n,1));
            movieParam = getAviInfo(indx(n,1));
            fr = movieParam.fr;
            ld = load([statspath movieParam.fileName '_results.mat']);

            edge_time_all{ii,jj}(n) = ld.edge_time/fr;
            cent_time_all{ii,jj}(n) = ld.cent_time/fr;
            rest_time_all{ii,jj}(n) = ld.rest_time/fr;
            displace_all{ii,jj}(n) = nansum(ld.displace);
            displace_fam_all{ii,jj}(n) = nansum(ld.displace_fam);
            displace_nov_all{ii,jj}(n) = nansum(ld.displace_nor);

            fam_obj_time_all{ii,jj}(n,:) = ld.fam_obj_time_final/fr;
            nor_obj_time_all{ii,jj}(n,1) = ld.nor_obj_time_final(setdiff(1:2,ld.nor_obj_indx))/fr;
            nor_obj_time_all{ii,jj}(n,2) = ld.nor_obj_time_final(ld.nor_obj_indx)/fr;
            fam_region_time_all{ii,jj}(n,:) = ld.fam_region_time_expt/fr;
            nor_region_time_all{ii,jj}(n,1) = ld.nor_region_time_expt(setdiff(1:2,ld.nor_obj_indx))/fr;
            nor_region_time_all{ii,jj}(n,2) = ld.nor_region_time_expt(ld.nor_obj_indx)/fr;

            fam_expt_time_all{ii,jj}(n,1) = ld.fam_obj_time_expt(setdiff(1:2,ld.nor_obj_indx))/fr;
            fam_expt_time_all{ii,jj}(n,2) = ld.fam_obj_time_expt(ld.nor_obj_indx)/fr;
            nor_expt_time_all{ii,jj}(n,1) = ld.nor_obj_time_expt(setdiff(1:2,ld.nor_obj_indx))/fr;
            nor_expt_time_all{ii,jj}(n,2) = ld.nor_obj_time_expt(ld.nor_obj_indx)/fr;
            fam_cut_time_all{ii,jj}(n) = ld.fam_obj_cut_time/fr;
            nor_cut_time_all{ii,jj}(n) = ld.nor_obj_cut_time/fr;

        end
    end
end

% clean up NaNs
for ii = 1:2
    for jj = 1:2
        displace_fam_all{ii,jj}(isnan(displace_fam_all{ii,jj})) = 0;
        displace_nov_all{ii,jj}(isnan(displace_nov_all{ii,jj})) = 0;
        fam_cut_time_all{ii,jj}(isnan(fam_cut_time_all{ii,jj})) = param.expt_thresh;
        nor_cut_time_all{ii,jj}(isnan(nor_cut_time_all{ii,jj})) = param.expt_thresh;
    end
end

%% plot general stats
cc = struct();
cc.orange = [0.8 0.4 0];
figure;set(gcf,'color','w','position',[2000 473 748 445]);

% edge time
subplot(2,3,1); hold on;
plot_box_pair(edge_time_all,[0 0 0],cc.orange,p)
ylabel('edge time (s)');
legend('off')

% center time
subplot(2,3,2); hold on;
plot_box_pair(cent_time_all,[0 0 0],cc.orange,p)
ylabel('center time (s)');
legend('off')

% rest time
subplot(2,3,3); hold on;
plot_box_pair(rest_time_all,[0 0 0],cc.orange,p)
ylabel('rest time (s)');
legend('off')

% distance traveled
subplot(2,3,4); hold on;
plot_box_pair(displace_all,[0 0 0],cc.orange,p)
ylabel('distance traveled (habi)');
legend('off')

% distance traveled - fam
subplot(2,3,5); hold on;
plot_box_pair(displace_fam_all,[0 0 0],cc.orange,p)
ylabel('distance traveled (fam)');
legend('off')

% distance traveled - fam
subplot(2,3,6); hold on;
plot_box_pair(displace_nov_all,[0 0 0],cc.orange,p)
ylabel('distance traveled (nov)');

saveas(gcf,[figpath 'stats_general.fig']);

%% plot object experiment statas
figure;set(gcf,'color','w','position',[2000 473 748 445]);

% lateralization time nov
subplot(2,4,1); hold on;
plot_obj(nor_region_time_all,[0 0 0],cc.orange,p)
ylabel('novel region time (s)');
legend('off')

% object time in the first 5min
subplot(2,4,2); hold on;
plot_obj(fam_expt_time_all,[0 0 0],cc.orange,p)
ylabel('fam obj time in first x min (s)');
legend('off')

subplot(2,4,3); hold on;
plot_obj(nor_expt_time_all,[0 0 0],cc.orange,p)
ylabel('nov obj time in first x min (s)');
% legend('off')

% total exploration time fam
subplot(2,4,4); hold on;
plot_box_pair(cellfun(@(x) sum(x,2)',fam_expt_time_all,'uniformoutput',false),...
    [0 0 0],cc.orange,p)
ylabel('total exploration time fam(s)');
legend('off');

% lateralization time fam
subplot(2,4,5); hold on;
plot_obj(fam_region_time_all,[0 0 0],cc.orange,p)
ylabel('fam region time (s)');
legend('off')

% experiment cutoff time
subplot(2,4,6); hold on;
plot_box_pair(fam_cut_time_all,[0 0 0],cc.orange,p)
ylabel('fam obj cutoff time(s)');
legend('off')

subplot(2,4,7); hold on;
plot_box_pair(nor_cut_time_all,[0 0 0],cc.orange,p)
ylabel('nov obj cutoff time(s)');
legend('off')

% total exploration time nov
subplot(2,4,8); hold on;
plot_box_pair(cellfun(@(x) sum(x,2)',nor_expt_time_all,'uniformoutput',false),...
    [0 0 0],cc.orange,p)
ylabel('total exploration time nov(s)');

% save figure
saveas(gcf,[figpath 'stats_obj.fig']);

%% object time ratio
% ctrl
obj_time_ratio_ctrl = cell(2,2); % {pre, post}
obj_time_ratio_ctrl{1,1} = fam_expt_time_all{1,1}(:,2)'./fam_expt_time_all{1,1}(:,1)';
obj_time_ratio_ctrl{1,2} = nor_expt_time_all{1,1}(:,2)'./nor_expt_time_all{1,1}(:,1)';
obj_time_ratio_ctrl{2,1} = fam_expt_time_all{1,2}(:,2)'./fam_expt_time_all{1,2}(:,1)';
obj_time_ratio_ctrl{2,2} = nor_expt_time_all{1,2}(:,2)'./nor_expt_time_all{1,2}(:,1)';

for ii = 1:2
    for jj = 1:2
        tmp = obj_time_ratio_ctrl{ii,jj};
        tmp(isinf(tmp)) = max(tmp(~isinf(tmp)));
        tmp(isnan(tmp)) = 0;
        obj_time_ratio_ctrl{ii,jj} = tmp;
    end
end


% expt
obj_time_ratio_expt = cell(2,2); % {pre, post}
obj_time_ratio_expt{1,1} = fam_expt_time_all{2,1}(:,2)'./fam_expt_time_all{2,1}(:,1)';
obj_time_ratio_expt{1,2} = nor_expt_time_all{2,1}(:,2)'./nor_expt_time_all{2,1}(:,1)';
obj_time_ratio_expt{2,1} = fam_expt_time_all{2,2}(:,2)'./fam_expt_time_all{2,2}(:,1)';
obj_time_ratio_expt{2,2} = nor_expt_time_all{2,2}(:,2)'./nor_expt_time_all{2,2}(:,1)';

for ii = 1:2
    for jj = 1:2
        tmp = obj_time_ratio_expt{ii,jj};
        tmp(isinf(tmp)) = max(tmp(~isinf(tmp)));
        tmp(isnan(tmp)) = 0;
        obj_time_ratio_expt{ii,jj} = tmp;
    end
end

figure; set(gcf,'color','w')
subplot(1,2,1); hold on
plot_box_pair(obj_time_ratio_ctrl,[0 0 0],cc.orange,p)
set(gca,'xtick',[1 2],'xticklabel',{'pre','post'})
ylabel('object time ratio (ctrl)');
legend off
subplot(1,2,2); hold on
plot_box_pair(obj_time_ratio_expt,[0 0 0],cc.orange,p)
set(gca,'xtick',[1 2],'xticklabel',{'pre','post'})
ylabel('object time ratio (expt)');
legend off

% distance traveled ratio
% dist_ratio = cell(3,2);
% dist_ratio{1,1} = displace_all{1,2}./displace_all{1,1};
% dist_ratio{1,2} = displace_all{2,2}./displace_all{2,1};
% dist_ratio{2,1} = displace_fam_all{1,2}./displace_fam_all{1,1};
% dist_ratio{2,2} = displace_fam_all{2,2}./displace_fam_all{2,1};
% dist_ratio{3,1} = displace_nov_all{1,2}./displace_nov_all{1,1};
% dist_ratio{3,2} = displace_nov_all{2,2}./displace_nov_all{2,1};
% 
% subplot(1,2,2); hold on
% stepsz = 0.2;
% mksz = 15;
% ww = 0.1; linew = 1.5;
% % plot([ones(size(dist_ratio{1,1}))-stepsz;ones(size(dist_ratio{1,1}))+stepsz],...
% %     [dist_ratio{1,1},dist_ratio{1,2}],'color',0.7*[1 1 1]);
% % plot([2*ones(size(dist_ratio{3,1}))-stepsz;2*ones(size(dist_ratio{2,1}))+stepsz],...
% %     [dist_ratio{2,1},dist_ratio{2,2}],'color',0.7*[1 1 1]);
% % plot([3*ones(size(dist_ratio{3,1}))-stepsz;3*ones(size(dist_ratio{3,1}))+stepsz],...
% %     [dist_ratio{3,1},dist_ratio{3,2}],'color',0.7*[1 1 1]);
% scatter(ones(size(displace_all{1,1}))-stepsz,dist_ratio{1,1},mksz,'ko');
% scatter(ones(size(displace_all{2,1}))+stepsz,dist_ratio{1,2},mksz,'ko','filled');
% scatter(2*ones(size(displace_fam_all{1,1}))-stepsz,dist_ratio{2,1},mksz,'ko');
% scatter(2*ones(size(displace_fam_all{2,1}))+stepsz,dist_ratio{2,2},mksz,'ko','filled');
% scatter(3*ones(size(displace_nov_all{1,1}))-stepsz,dist_ratio{3,1},mksz,'ko');
% scatter(3*ones(size(displace_nov_all{2,1}))+stepsz,dist_ratio{3,2},mksz,'ko','filled');
% plot(1-stepsz+[-ww ww],nanmean(dist_ratio{1,1})*[1 1],'k','linewidth',linew)
% plot(1+stepsz+[-ww ww],nanmean(dist_ratio{1,2})*[1 1],'k','linewidth',linew)
% plot(2-stepsz+[-ww ww],nanmean(dist_ratio{2,1})*[1 1],'k','linewidth',linew)
% plot(2+stepsz+[-ww ww],nanmean(dist_ratio{2,2})*[1 1],'k','linewidth',linew)
% plot(3-stepsz+[-ww ww],nanmean(dist_ratio{3,1})*[1 1],'k','linewidth',linew)
% plot(3+stepsz+[-ww ww],nanmean(dist_ratio{3,2})*[1 1],'k','linewidth',linew)
% xlim([0.5 3.5]); %ylim([ymi yma]);
% set(gca,'xtick',1:3,'xticklabel',{'hab','fam','nov'})
% ylabel('ratio of distance traveled')

saveas(gcf,[figpath 'obj_time_ratio.fig']);

%% % fam object time
% subplot(2,3,4);
% hold on;
% cpre = reshape(fam_obj_time_all{1,1},[],1);
% cpost = reshape(fam_obj_time_all{1,2},[],1);
% epre = reshape(fam_obj_time_all{2,1},[],1);
% epost = reshape(fam_obj_time_all{2,2},[],1);
% scatter(ones(size(cpre))-stepsz,cpre,mksz,'ko');
% scatter(ones(size(cpost))+stepsz,cpost,mksz,'ko','filled');
% scatter(2*ones(size(epre))-stepsz,epre,mksz,cc.orange,'o');
% scatter(2*ones(size(epost))+stepsz,epost,mksz,cc.orange,'o','filled');
% plot(1-stepsz+[-ww ww],nanmean(cpre)*[1 1],'k','linewidth',linew)
% plot(1+stepsz+[-ww ww],nanmean(cpost)*[1 1],'k','linewidth',linew)
% plot(2-stepsz+[-ww ww],nanmean(epre)*[1 1],'color',cc.orange,'linewidth',linew)
% plot(2+stepsz+[-ww ww],nanmean(epost)*[1 1],'color',cc.orange,'linewidth',linew)
% yma = 1.1*max([cpre;cpost;epre;epost]);
% ymi = 0.9*min([cpre;cpost;epre;epost]);
% if ranksum(cpre,cpost)<p
%     scatter(1,yma,'k*');
% end
% if ranksum(epre,epost)<p
%     scatter(2,yma,'k*');
% end
% if ranksum(cpre,epre)<p
%     scatter(1.5-stepsz,yma,'k*');
% end
% if ranksum(cpost,epost)<p
%     scatter(1.5+stepsz,yma,'k*');
% end
% xlim([0.5 2.5]);ylim([ymi yma]);
% set(gca,'xtick',[1 2],'xticklabel',{'ctrl','expt'})
% ylabel('fam obj time (s)');
% box off
% 
% 
% % novel object time
% subplot(2,3,5);
% hold on;
% cpre = nor_obj_time_all{1,1};
% cpost = nor_obj_time_all{1,2};
% epre = nor_obj_time_all{2,1};
% epost = nor_obj_time_all{2,2};
% scatter(ones(size(cpre,1),1)-stepsz,cpre(:,1),mksz,'ko');
% scatter(ones(size(cpost,1),1)+stepsz,cpost(:,1),mksz,'ko','filled');
% scatter(2*ones(size(epre,1),1)-stepsz,epre(:,1),mksz,cc.orange,'o');
% scatter(2*ones(size(epost,1),1)+stepsz,epost(:,1),mksz,cc.orange,'o','filled');
% scatter(4*ones(size(cpre,1),1)-stepsz,cpre(:,2),mksz,'ko');
% scatter(4*ones(size(cpost,1),1)+stepsz,cpost(:,2),mksz,'ko','filled');
% scatter(5*ones(size(epre,1),1)-stepsz,epre(:,2),mksz,cc.orange,'o');
% scatter(5*ones(size(epost,1),1)+stepsz,epost(:,2),mksz,cc.orange,'o','filled');
% plot(1-stepsz+2*[-ww ww],nanmean(cpre(:,1))*[1 1],'k','linewidth',linew)
% plot(1+stepsz+2*[-ww ww],nanmean(cpost(:,1))*[1 1],'k','linewidth',linew)
% plot(2-stepsz+2*[-ww ww],nanmean(epre(:,1))*[1 1],'color',cc.orange,'linewidth',linew)
% plot(2+stepsz+2*[-ww ww],nanmean(epost(:,1))*[1 1],'color',cc.orange,'linewidth',linew)
% plot(4-stepsz+2*[-ww ww],nanmean(cpre(:,2))*[1 1],'k','linewidth',linew)
% plot(4+stepsz+2*[-ww ww],nanmean(cpost(:,2))*[1 1],'k','linewidth',linew)
% plot(5-stepsz+2*[-ww ww],nanmean(epre(:,2))*[1 1],'color',cc.orange,'linewidth',linew)
% plot(5+stepsz+2*[-ww ww],nanmean(epost(:,2))*[1 1],'color',cc.orange,'linewidth',linew)
% yma = 1.1*max([cpre(:);cpost(:);epre(:);epost(:)]);
% ymi = 0.9*min([cpre(:);cpost(:);epre(:);epost(:)]);
% % if ranksum(cpre,cpost)<p
% %     scatter(1,yma,'k*');
% % end
% % if ranksum(epre,epost)<p
% %     scatter(2,yma,'k*');
% % end
% % if ranksum(cpre,epre)<p
% %     scatter(1.5-stepsz,yma,'k*');
% % end
% % if ranksum(cpost,epost)<p
% %     scatter(1.5+stepsz,yma,'k*');
% % end
% xlim([0 6]);ylim([ymi yma]);
% set(gca,'xtick',[1.5 4.5],'xticklabel',{'fam','nov'})
% ylabel('novel obj time (s)');
% box off




end

