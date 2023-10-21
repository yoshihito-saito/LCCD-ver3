function MainFun_roi_marge_NoRMCorre_SJIS(options)

    %out_path = fullfile(varargin{2}, varargin{1});
    %in_path = Sub_get_resPath(out_path, 2);
    %out_path = fullfile(out_path, proc_path);
    %addpath(in_path);
    in_path=options.procs.path{2};
    out_path=options.procs.path{3};

    load(fullfile(in_path, 'roi01.mat')); % 簡易アルゴリズムのE_ROIのデータ
    %n_roi = n_roi3;
    %n_roi3 = E_ROI;
    n_roi3 = soma_ROI;
    [Height,Width] = size(n_roi3);
    E_ROI = zeros(Height,Width);

    file_list = dir(fullfile(in_path, '/*.mat'));
    file_list = {file_list.name};
   
    for i = 1:length(file_list)-1 % マージするファイル数だけループさせる
        
        l=i+1;
        roi1 = n_roi3;
        load_Name = fullfile(in_path, sprintf('roi%02d.mat',l));
        load(load_Name);
        roi2 = soma_ROI;
		
		if options.useGPU
            roi1 = gather(roi1);
            roi2 = gather(roi2);
        end
        E_ROI = zeros(Height,Width);
        
        %l = l+1;
        %a = options.a; %0.4; %ROIをマージさせる際の重なっている割合（例：0.3=30%）
        n_roi = zeros(Height,Width);
        n_roi2 = zeros(Height,Width);
        n_roi3 = zeros(Height,Width);
        [n_roi,n_roi2,n_roi3,roi_num] = n_roi_marge(roi1, roi2, options);% n_roi, n_roi2, n_roi3 iのROI, i+1のROI, iとi+1を重ねたROI
        
        roi1 = zeros(Height,Width);
        roi2 = zeros(Height,Width);
        
        disp(i);
        disp(roi_num)
        
        folderName = fullfile(out_path, sprintf('marged_ROI%02d',i));
        mkdir(folderName);
        addpath(out_path);
        para_Name = fullfile(folderName, sprintf('para%02d.mat',i));
        save(para_Name,'n_roi','n_roi2','n_roi3','roi_num'); % n_roi, n_roi2, n_roi3 iのROI, i+1のROI, iとi+1を重ねたROI
    end

end