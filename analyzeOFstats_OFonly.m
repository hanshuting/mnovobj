function [] = analyzeOFstats_OFonly(param)

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
rest_time_center_all = cell(2,2);
run_time_center_all = cell(2,2);
rest_time_edge_all = cell(2,2);
run_time_edge_all = cell(2,2);
corner_rest_time_all = cell(2,2);
spd_all = cell(2,2);
num_stop_all = cell(2,2);
displace_all = cell(2,2);

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
            ld = load([statspath movieParam.fileName '_results_OFonly.mat']);

            edge_time_all{ii,jj}(n) = ld.edge_time/fr;
            cent_time_all{ii,jj}(n) = ld.cent_time/fr;
            rest_time_all{ii,jj}(n) = ld.rest_time/fr;
            displace_all{ii,jj}(n) = nansum(ld.displace);
            
            rest_time_center_all{ii,jj}(n) = ld.rest_time_center;
            run_time_center_all{ii,jj}(n) = ld.run_time_center;
            rest_time_edge_all{ii,jj}(n) = ld.rest_time_edge;
            run_time_edge_all{ii,jj}(n) = ld.run_time_edge;
            
            corner_rest_time_all{ii,jj}(n) = ld.corner_rest_time;
            
            spd_all{ii,jj}(n) = ld.spd;
            num_stop_all{ii,jj}(n) = ld.num_stop;
            
        end
    end
end


%% plot general stats
cc = struct();
cc.orange = [0.8 0.4 0];
figure;set(gcf,'color','w','position',[2000 473 748 445]);

% edge time
subplot(2,5,1); hold on;
plot_box_pair(edge_time_all,[0 0 0],cc.orange,p)
ylabel('edge time (s)');
legend('off')

% center time
subplot(2,5,2); hold on;
plot_box_pair(cent_time_all,[0 0 0],cc.orange,p)
ylabel('center time (s)');
legend('off')

% rest time
subplot(2,5,3); hold on;
plot_box_pair(rest_time_all,[0 0 0],cc.orange,p)
ylabel('rest time (s)');
legend('off')

% rest time center
subplot(2,5,4); hold on;
plot_box_pair(rest_time_center_all,[0 0 0],cc.orange,p)
ylabel('rest time center (s)');
legend('off')

% rest time edge
subplot(2,5,5); hold on;
plot_box_pair(rest_time_edge_all,[0 0 0],cc.orange,p)
ylabel('rest time edge (s)');
legend('off')

% run time center
subplot(2,5,6); hold on;
plot_box_pair(run_time_center_all,[0 0 0],cc.orange,p)
ylabel('run time center (s)');
legend('off')

% run time edge
subplot(2,5,7); hold on;
plot_box_pair(run_time_edge_all,[0 0 0],cc.orange,p)
ylabel('run time edge (s)');
legend('off')

% cornere rest time
subplot(2,5,8); hold on;
plot_box_pair(corner_rest_time_all,[0 0 0],cc.orange,p)
ylabel('corner rest time (s)');
legend('off')

% speed
subplot(2,5,9); hold on;
plot_box_pair(spd_all,[0 0 0],cc.orange,p)
ylabel('speed');
legend('off')

% num stop
subplot(2,5,10); hold on;
plot_box_pair(num_stop_all,[0 0 0],cc.orange,p)
ylabel('num stop');

saveas(gcf,[figpath 'OFonly_stats.fig']);




end

