function demo_normCorre_tifFiles(options)
%clear
%gcp;
addpath(genpath('./NoRMCorre-master'));
in_path = options.raw_path;
out_path = options.procs.path{1};
pnam = in_path; 
mkdir(out_path);

if  options.concat == 1
        
    folderPath = in_path;
    subfolders = dir(folderPath);
    subfolderNames = {subfolders([subfolders.isdir]).name};
    subfolderNames = subfolderNames(~ismember(subfolderNames, {'.', '..'}));
    file_list = {};
    % 各フォルダ内の.tiffファイルを処理
    for folderIndex = 1:length(subfolderNames)
        currentFolder = fullfile(folderPath, subfolderNames{folderIndex});
        
        % .tiffファイルを含むフォルダ内のファイルを取得
        tiffFiles = dir(fullfile(currentFolder, '*.tiff'));
        
        % .tiffファイルが存在する場合、パスとフォルダ名をセル配列に追加
        if ~isempty(tiffFiles)
            for fileIndex = 1:length(tiffFiles)
                tiffFilePath = fullfile(currentFolder, tiffFiles(fileIndex).name);
                file_list{1, end + 1} = tiffFilePath;  % パス
            end
        end
    end
    options = NoRMCorreSetParms(options.opt_noRMCorre);
    for ix=1:length(file_list)

        options.h5_filename = fullfile(out_path, sprintf('IMG_V%02d.h5',ix));
        Y = loadtiff(file_list{ix});
    
	    %Y = single(Y);
        
        %% perform motion correction
        if ndims(Y)==3
            if exist('template1', 'var')
               tic; [~,shifts1,~] = normcorre_batch(Y,options,template1); toc
               shifts1a = vertcat(shifts1a, shifts1);
            else
              % template1 = Y(:,:,1);
               tic; [~,shifts1,template1] = normcorre_batch(Y,options); toc     
               shifts1a = shifts1;
            end
        end
        
    end
    save(fullfile(out_path,'info.mat'), 'shifts1a', 'template1');   

else
    options = NoRMCorreSetParms(options.opt_noRMCorre);
    file_list = dir(fullfile(in_path, '*.tiff'));
    file_list = {file_list.name};
    for ix=1:length(file_list)
        %% set parameters 
        options.h5_filename = fullfile(out_path, sprintf('IMG_V%02d.h5',ix));
        %fnam = fullfile(pnam, file_list(ix));
        Y = loadtiff(fullfile(pnam, file_list{ix}));
    
	    %Y = single(Y);
        
        %% perform motion correction
        if ndims(Y)==3
            if exist('template1', 'var')
               tic; [~,shifts1,~] = normcorre_batch(Y,options,template1); toc
               shifts1a = vertcat(shifts1a, shifts1);
            else
              % template1 = Y(:,:,1);
               tic; [~,shifts1,template1] = normcorre_batch(Y,options); toc     
               shifts1a = shifts1;
            end
        end
        
    end
    save(fullfile(out_path,'info.mat'), 'shifts1a', 'template1');
end