function MainFun_RegionMapping(options)
    %% Optional
    % ROI region mapping
    
    atlas_path = options.atlas_path;
    in_path = options.procs.path{5};
    ou_path = options.procs.path{6};

    %% Load data
    atlas_dir = dir(fullfile(atlas_path, '/*.mat'));
    Atlas = load(fullfile(atlas_dir.folder, atlas_dir.name)).Atlas;
    region_info = load('NameColor.mat').NameColor;
    roi_centroid = load(fullfile(path_10, 'ROI_metrics.mat')).ROI_metrics.Centroid;
    region_idx = unique(Atlas);

    for i = 1:length(region_idx)
        region_tmp = zeros(size(Atlas));
        region_tmp(Atlas==region_idx(i))=1;
        roi_region_tmp = roi_centroid.*region_tmp;

    end
end
