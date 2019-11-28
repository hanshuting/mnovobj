% scripts to write file info for anesthesia behavior experiments

%% get dir names
fdirbase = 'G:\Data\Michael_mice_behavior_videos\Isoflurane\1month_old_anesthesia';
fdirnames = dir(fdirbase);
fdirnames = fdirnames(3:end);
if isempty(fdirnames)
    fprintf('Empty directory!\n');
end

% keep only directories
fisdir = struct2cell(fdirnames);
fisdir = cell2mat(fisdir(4,:));
fdirnames = fdirnames(fisdir);

% index number starts from this
findx_start = 1;

%% loop through dirs and write info
fid = fopen([fdirbase '\fileinfo.txt'],'w');

fendn = findx_start;
for n = 1:length(fdirnames)
    
    fprintf('Processing directory %s...\n',fdirnames(n).name);
    fstartn = fendn;
    % fprintf('starting index %u\n',fstartn);
    
    % get the list of video files
    filenames = dir([fdirbase '\' fdirnames(n).name '\*.avi']);
    if length(filenames)~=6
        fprintf('Missing files\n');
    end

    % sort them based on experiment conditions
    search_flag = true(size(filenames));
    sort_indx = zeros(size(filenames));
    for ii = 1:length(filenames)
        if (~isempty(strfind(filenames(ii).name,'hab_again')) ||...
            ~isempty(strfind(filenames(ii).name,'habagain')) ||...
            ~isempty(strfind(filenames(ii).name,'habi_again')) || ...
            ~isempty(strfind(filenames(ii).name,'habiagain'))) &&  search_flag(ii)==1
            search_flag(ii) = 0;
            sort_indx(ii) = 4;
            continue;
        end
        if (~isempty(strfind(filenames(ii).name,'fam_again')) ||...
            ~isempty(strfind(filenames(ii).name,'famagain'))) &&  search_flag(ii)==1
            search_flag(ii) = 0;
            sort_indx(ii) = 5;
            continue;
        end
        if (~isempty(strfind(filenames(ii).name,'nor_again')) ||...
            ~isempty(strfind(filenames(ii).name,'noragain'))) && search_flag(ii)==1
            search_flag(ii) = 0;
            sort_indx(ii) = 6;
            continue;
        end
        if ~isempty(strfind(filenames(ii).name,'hab')) && search_flag(ii)==1
            search_flag(ii) = 0;
            sort_indx(ii) = 1;
            continue;
        end
        if ~isempty(strfind(filenames(ii).name,'fam')) && search_flag(ii)==1
            search_flag(ii) = 0;
            sort_indx(ii) = 2;
            continue;
        end
        if ~isempty(strfind(filenames(ii).name,'nor')) && search_flag(ii)==1
            search_flag(ii) = 0;
            sort_indx(ii) = 3;
            continue;
        end
    end
    
    % write to file
    [sorted,indx] = sort(sort_indx,'ascend');
    for ii = 1:length(filenames)
        if sorted(ii)~=0
            fprintf(fid,'\tcase %u\n',fstartn+sorted(ii)-1);
            fprintf(fid,'\t\tfpath = ''%s'';\n',[fdirbase '\' fdirnames(n).name]);
            fprintf(fid,'\t\tfname = ''%s'';\n',filenames(indx(ii)).name(1:end-4));
        end
    end

    % check if all experiments were found
    if any(search_flag==1)
        fprintf('Not all conditions were found... Please check file names\n');
    end

    fendn = fstartn+6;

end

fclose(fid);

