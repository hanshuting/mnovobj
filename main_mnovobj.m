%% parameters
% N-by-3 file index, columns arranged as habi->fam->nor
param = struct();

% NOTE: set the last video index to NaN if mouse failed the test
% ---------- new dataset Nov 2017 ----------- %
% 1 month old
% param.fileIndx = [1:3; 4:6; 7:9; 10:12; 25:27; 28:30; 31:33; 34:36; 37:39; ...
%     40:42; 43:45; 46:48; 73:75; 76:78; 79:81; 82:84; 85:87; 88:90; ];
% % param.fileIndx = [10:12]; % new files
% param.exptIndx = {[1:3; 7:9; 25:27;],[4:6; 10:12; 28:30;]}; % {pre, post}
% param.ctrlIndx = {[31:33; 37:39; 43:45; 73:75; 79:81; 85:87;],...
%     [34:36; 40:42; 46:48; 76:78; 82:84; 88:90;]};
% param.pbase = 'G:\Data\Michael_mice_behavior_videos\results\1month_old';

% adult
% param.fileIndx = [144:146; 150:152; 156:158; 147:149; 153:155; 159:161; 162:164;...
%     189:191; 219:221; 225:227; 192:194;  222:224; 228:230; 321:323; 324:326; ...
%     327:329; 330:332; 303:305; 306:308; 309:311; 312:314; 315:317; 318:320;]; 
% param.exptIndx = {[144:146; 150:152; 156:158; 321:323; 327:329;],...
%     [147:149; 153:155; 159:161; 324:326; 330:332;]};  % 162:164;
% param.ctrlIndx = {[189:191; 219:221; 225:227; 303:305; 309:311; 315:317;],...
%     [192:194; 222:224; 228:230; 306:308; 312:314; 318:320;]};

% elderly
% param.fileIndx = [231:233; 237:239; 243:245; 249:251; 255:257; 234:236; ...
%     240:242; 246:248; 252:254; 258:260; 261:263; 267:269; 273:275; 279:281;...
%     285:287; 291:293; 297:299; 264:266; 270:272; 276:277,NaN; 282:284; 288:290;...
%     294:296; 300:302];
% param.exptIndx = {[231:233; 237:239; 243:245; 249:251; 255:257],...
%     [234:236; 240:242; 246:248; 252:254; 258:260]};
% param.ctrlIndx = {[261:263; 267:269; 273:275; 279:281; 285:287; 291:293; 297:299],...
%     [264:266; 270:272; 276:277,NaN; 282:284; 288:290; 294:296; 300:302]};

% adult and elderly
param.fileIndx = [144:146; 150:152; 156:158; 147:149; 153:155; 159:161; 162:164;...
    189:191; 219:221; 225:227; 192:194;  222:224; 228:230; 321:323; 324:326; ...
    327:329; 330:332; 303:305; 306:308; 309:311; 312:314; 315:317; 318:320;...
    231:233; 237:239; 243:245; 249:251; 255:257; 234:236; ...
    240:242; 246:248; 252:254; 258:260; 261:263; 267:269; 273:275; 279:281;...
    285:287; 291:293; 297:299; 264:266; 270:272; 276:277,NaN; 282:284; 288:290;...
    294:296; 300:302]; 
param.exptIndx = {[144:146; 150:152; 156:158; 321:323; 327:329;...
    231:233; 237:239; 243:245; 249:251; 255:257],...
    [147:149; 153:155; 159:161; 324:326; 330:332;...
    234:236; 240:242; 246:248; 252:254; 258:260]};  % 162:164;
param.ctrlIndx = {[189:191; 219:221; 225:227; 303:305; 309:311; 315:317;...
    261:263; 267:269; 273:275; 279:281; 285:287; 291:293; 297:299],...
    [192:194; 222:224; 228:230; 306:308; 312:314; 318:320;...
    264:266; 270:272; 276:277,NaN; 282:284; 288:290; 294:296; 300:302]};
param.pbase = 'G:\Data\Michael_mice_behavior_videos\results\adult and elderly';

% param.pbase = 'G:\Data\Michael_mice_behavior_videos\results\adult';

% param.pbase = 'G:\Data\Michael_mice_behavior_videos\results\elderly';

param.spath.seg = [param.pbase '\seg\'];
param.spath.finfo = [param.pbase '\file_info\'];
param.spath.stats = [param.pbase '\stats\'];
param.spath.fig = [param.pbase '\fig\'];

% object info
param.num_obj = 2;

% analysis parameters
param.p = 0.05;
param.obj_time_thresh = 30; % in seconds, object exploration time
param.expt_thresh = 10*60; % in seconds, length of experiment
param.obj_expt_thresh = 10*60; % in seconds, cut off time by first x min
param.r = 1.2;
param.plot_traj = 0;

%% check if all directories exist
% for n = 1:length(param.dpath)
%     if exist(param.dpath{n},'dir')~=7
%         error('Incorrect data path')
%     end
% end

if exist(param.spath.seg,'dir')~=7
    mkdir(param.spath.seg);
    fprintf('created directory: %s\n',param.spath.seg);
end

if exist(param.spath.finfo,'dir')~=7
    mkdir(param.spath.finfo);
    fprintf('created directory: %s\n',param.spath.finfo);
end

if exist(param.spath.fig,'dir')~=7
    mkdir(param.spath.fig);
    fprintf('created directory: %s\n',param.spath.fig);
end

if exist(param.spath.stats,'dir')~=7
    mkdir(param.spath.stats);
    fprintf('created directory: %s\n',param.spath.stats);
end

%% analyze experiments
% manually select objects
getObjExptInfo(param);

% segment mouse regions
runMouseSegmentation(param);

% analyze trajectory information
analyzeOFtraj(param);

% results
analyzeOFstats(param);

% open field only
analyzeOFonly(param);
analyzeOFstats_OFonly(param);