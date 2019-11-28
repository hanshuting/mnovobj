function [] = plot_box(data,cc1,cc2,p)

stepsz = 0.2;
mksz = 15;
ww = 0.1;
linew = 1.5;

h1 = scatter(ones(size(data{1,1}))-stepsz,data{1,1},mksz,cc1,'o');
h2 = scatter(ones(size(data{1,2}))+stepsz,data{1,2},mksz,cc1,'o','filled');
h3 = scatter(2*ones(size(data{2,1}))-stepsz,data{2,1},mksz,cc2,'o');
h4 = scatter(2*ones(size(data{2,2}))+stepsz,data{2,2},mksz,cc2,'o','filled');
plot(1-stepsz+[-ww ww],nanmean(data{1,1})*[1 1],'k','linewidth',linew)
plot(1+stepsz+[-ww ww],nanmean(data{1,2})*[1 1],'k','linewidth',linew)
plot(2-stepsz+[-ww ww],nanmean(data{2,1})*[1 1],'color',cc2,'linewidth',linew)
plot(2+stepsz+[-ww ww],nanmean(data{2,2})*[1 1],'color',cc2,'linewidth',linew)
yma = 1.1*max(cell2mat(data(:)'));
% ymi = 0.9*min(cell2mat(data(:)'));
ymi = 0;
if ranksum(data{1,1},data{1,2})<p
    scatter(1,yma,'k*');
end
if ranksum(data{2,1},data{2,2})<p
    scatter(2,yma,'k*');
end
if ranksum(data{1,1},data{2,1})<p
    scatter(1.5-stepsz,yma,'k*');
end
if ranksum(data{1,2},data{2,2})<p
    scatter(1.5+stepsz,yma,'k*');
end
if ymi==yma
    yma = yma+0.01;
    ymi = ymi-0.01;
end
xlim([0.5 2.5]);ylim([ymi yma]);
set(gca,'xtick',[1 2],'xticklabel',{'ctrl','expt'})
box off
legend([h1 h2 h3 h4],'ctrl pre','ctrl post','expt pre','expt post');

end
