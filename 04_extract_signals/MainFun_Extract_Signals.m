function MainFun_Extract_Signals(options)
    close all
    
    raw_path=options.raw_path;
    in_path=options.procs.path{3};
    out_path=options.procs.path{4};
    h5_path=options.procs.path{1};


    %% Make Save Folder
    mkdir(out_path);

    %% Load marged ROI
    fprintf(1,'\tLoad marged ROI\n');
    dlis = dir(fullfile(in_path, 'marged*'));
    dlis_n = {dlis.name};
    [~, idx] = sort([dlis.datenum]);
    dlis_end = dlis_n{idx(end)}; 
    load(fullfile(in_path, dlis_end, [strrep(dlis_end, 'marged_ROI', 'para'), '.mat']), 'n_roi3');

    soma_ROI =  full(n_roi3);
    nROI = max(soma_ROI(:));
    fprintf(1,'\t\tNumber of ROIs, %d\n\n',nROI);

    %% Save Neuropil Map for Each ROI If Necessary
    fprintf(1,'\tSave Neuropil Map for Each ROI If Necessary\n');
    Sub_Save_NeuropilMap(soma_ROI, options, out_path);
    
    % MemoryInfo = memory;
    % fprintf(1,'\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);
    c=tmpfuns('get_pos_area', n_roi3);
    save(fullfile(out_path, 'centerpos.mat'), 'c');
    N_files = length(dir(fullfile(in_path, 'marged*')))+1;
    F_soma = cell(1, N_files);
    F_neuropil = cell(1, N_files);
    for FileNum = 1:N_files
        
        %% Load image data
        fprintf(1,'\t\tLoad image data (File No. %d)\n',FileNum);
        LoadFileName = fullfile(h5_path, sprintf('IMG_V%02d.h5',FileNum));
        Image = h5read(LoadFileName, '/mov'); %
        % MemoryInfo = memory;
        % fprintf(1,'\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));
        fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);
        
        %% Extract & Save ROI Signal
        fprintf(1,'\t\tExtract & Save ROI Signal (File No. %d)\n',FileNum);
   
        F_soma{FileNum} = Sub_ExtractSave_ROI_rev3(soma_ROI, Image, FileNum, c, out_path); % for GPU-PC

        fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);
        
        %% Extract and Save Signal Around ROI
        fprintf(1,'\t\tExtract and Save Signal Around ROI (File No. %d)\n',FileNum);
        in  = options.dilate_pixel_for4.in;
        out = options.dilate_pixel_for4.out;
            
        %% Extract Around ROI Signal
        fprintf(1,'\t\tExtract Around ROI Signal (File No. %d, %d-%d)\n',FileNum,in,out);
        LoadFileName = fullfile(out_path, sprintf('SurroundROI_Map_DilatePixel-in%d-out%d.mat',in,out));
        SaveFileName = fullfile(out_path, sprintf('SurroundROI_Signal_File%02d_DilatePixel-in%d-out%d.mat',FileNum,in,out));
        
        F_neuropil{FileNum}  = Sub_ExtractSave_Neuropil(Image, LoadFileName, SaveFileName);
       
    end

    % Remove neuropil signal and slow fluctuation, then calculate dF/F
    if  options.concat == 1
            
        subfolders = dir(raw_path);
        subfolderNames = {subfolders([subfolders.isdir]).name};
        subfolderNames = subfolderNames(~ismember(subfolderNames, {'.', '..'}));
        folderFileCounts = zeros(1, length(subfolderNames));

        % 各フォルダ内の .tiff ファイル数を取得
        for folderIdx = 1:length(subfolderNames)
            currentFolder = fullfile(raw_path, subfolderNames{folderIdx});
            tiffFiles = dir(fullfile(currentFolder, '*.tiff'));
            folderFileCounts(folderIdx) = length(tiffFiles);
        end
    
        F_soma_blocks = cell(1, length(subfolderNames));
        F_neuropil_blocks = cell(1, length(subfolderNames));
        currentIndex = 1;
        
        for folderIdx = 1:length(subfolderNames)
            numFiles = folderFileCounts(folderIdx);
            
            % 同じフォルダ内のシグナルを結合
            combined_soma_F = cat(2, F_soma{currentIndex:currentIndex + numFiles - 1});
            F_soma_blocks{folderIdx} = combined_soma_F;
            combined_neurpil_F = cat(2, F_neuropil{currentIndex:currentIndex + numFiles - 1});
            F_neuropil_blocks{folderIdx} = combined_neurpil_F;
            currentIndex = currentIndex + numFiles;
        end
        fprintf(1,'\t\tCalculate dF/F0\n');
        dF_F = cellfun(@(x,y) Sub_Calc_dFF(x,y,options), F_soma_blocks, F_neuropil_blocks, 'UniformOutput', false);
 
    else
        F_soma = cell2mat(F_soma);
        F_neuropil = cell2mat(F_neuropil);
        dF_F = Sub_Calc_dFF(F_soma, F_neuropil, options);
    end

    FileName = fullfile(out_path, 'dF_F.mat');
    save(FileName, 'dF_F', '-v7.3');

end    

    