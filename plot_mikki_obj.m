function [] = plot_mikki_obj(data,cc1,cc2,p)

hold on;
stepsz = 0.2;
mksz = 15;
ww = 0.1;
linew = 1.5;

cpre = data{1,1};
cpost = data{1,2};
epre = data{2,1};
epost = data{2,2};

h1 = scatter(ones(size(cpre,1),1)-stepsz,cpre(:,1),mksz,cc1,'^');
h2 = scatter(ones(size(cpre,1),1)+stepsz,cpre(:,2),mksz,cc1,'^','filled');

scatter(2*ones(size(cpost,1),1)-stepsz,cpost(:,1),mksz,cc1,'^');
scatter(2*ones(size(cpost,1),1)+stepsz,cpost(:,2),mksz,cc1,'^','filled');

scatter(4*ones(size(epre,1),1)-stepsz,epre(:,1),mksz,cc2,'^');
scatter(4*ones(size(epre,1),1)+stepsz,epre(:,2),mksz,cc2,'^','filled');

scatter(5*ones(size(epost,1),1)-stepsz,epost(:,1),mksz,cc2,'^');
scatter(5*ones(size(epost,1),1)+stepsz,epost(:,2),mksz,cc2,'^','filled');

plot(1-stepsz+2*[-ww ww],nanmean(cpre(:,1))*[1 1],'color',cc1,'linewidth',linew)
plot(1+stepsz+2*[-ww ww],nanmean(cpre(:,2))*[1 1],'color',cc1,'linewidth',linew)

plot(2-stepsz+2*[-ww ww],nanmean(cpost(:,1))*[1 1],'color',cc1,'linewidth',linew)
plot(2+stepsz+2*[-ww ww],nanmean(cpost(:,2))*[1 1],'color',cc1,'linewidth',linew)

plot(4-stepsz+2*[-ww ww],nanmean(epre(:,1))*[1 1],'color',cc2,'linewidth',linew)
plot(4+stepsz+2*[-ww ww],nanmean(epre(:,2))*[1 1],'color',cc2,'linewidth',linew)

plot(5-stepsz+2*[-ww ww],nanmean(epost(:,1))*[1 1],'color',cc2,'linewidth',linew)
plot(5+stepsz+2*[-ww ww],nanmean(epost(:,2))*[1 1],'color',cc2,'linewidth',linew)

yma = 1.1*max([cpre(:);cpost(:);epre(:);epost(:)]);
ymi = 0.9*min([cpre(:);cpost(:);epre(:);epost(:)]);
xlim([0 6]);ylim([ymi yma]);
set(gca,'xtick',[1 2 4 5],'xticklabel',{'ctrl pre','ctrl post','expt pre','expt post'},...
    'xticklabelrotation',30)
box off

legend([h1 h2],{'fam','nov'})

end