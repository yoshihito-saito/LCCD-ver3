function MainFun_QualityMetrics(options)
%%MAINFUN_QUALITYMETRICS Summary of this function goes here
    % Calculate SNR, Artifact power, ROI features
    global SampRate
    global SplitFreq
    %%
    close all
    warning('off','MATLAB:MKDIR:DirectoryExists'); % Turn off the waring showing "the directory already exists"
    warning('off','MATLAB:legend:IgnoringExtraEntries'); % Turn off the waring showing "the extra legneds are ignored"
    tic;
    mkdir(options.procs.path{5});
    %% Parameters
    SampRate  = options.Samprate;
    SplitFreq = options.SplitFreq; % Split frequency used for SNR calculation
    Threshold = options.Threshold; % Threshold for nearby-correlation
    
    %% Load data
    dF_F = load(fullfile(options.procs.path{4}, 'dF_F.mat')).dF_F;
    if options.concat==1
        dF_F=cell2mat(dF_F);
    end
    load(fullfile(options.procs.path{4}, 'centerpos.mat'), 'c');
    Time = (1:size(dF_F,2))/SampRate;
    %% Plot Correlated Waves
    d=pdist2(c(:,2:3),c(:,2:3));
    dPerDia=bsxfun(@rdivide,d, c(:,1)*2);
    rdF=corr(dF_F');
    rdF(logical(eye(size(c,1))))=0;
    %Sub_plot_corrWaves(dF_F, dPerDia, options.procs.path{5});

    %% Split Ca response into signal and noise
    fprintf(1,'\tSplit Ca response into signal and noise\n');
    SNR = Sub_Split_CaResponse_SignalNoise(dF_F, options.procs.path{5});
    %% Calculate Signal Noise Ratio
    fprintf(1,'\tCalculate Signal Noise Ratio\n');
    SNR = Sub_Calculate_SignalNoiseRatio(SNR);
    Sub_PlotLowSNR(Time, dF_F, SNR, options);
    Sub_Histogram_SNR(SNR, options)
    %SNR= Sub_Calc_SNR(dF_F, options);
   

%{
    %% Historgram SNR
    fprintf(1,'\tHistorgram SNR\n');
    Sub_Histogram_SNR(SNR, options.procs.path{5});
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Graph Split Ca response and SN ratio
    fprintf(1,'\tGraph Split Ca response and SN ratio\n');
    Sub_Graph_Split_CaResponse_SignalNoise_Ratio(dF_F, SNR, Time, options.procs.path{5});
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);
%}
    %% Check overdivided ROIs 
    [nearby_CellUse, ~] = Sub_Check_nearbyCellToUse(rdF, dPerDia, SNR, Threshold);
    
    [filtered_dF_F, noise_variance] = Sub_Calc_noise_variance(dF_F, options);
    Sub_Histogram_NV(noise_variance, options)
    % Plot noies and cell signal when you set the threshold
    Sub_PlotNoisySignal(Time, dF_F, noise_variance, options) 
    
    %% Decide Cells to Use
    CellUse = Sub_Decide_CellsToUse(dF_F, SNR, Threshold, nearby_CellUse, noise_variance);
    Sub_Plot_QualityCheck(Time, dF_F, CellUse, options)

    %% Save ROI Mask images and Metrics
    disp('Create ROI mask images');
    folder_list = dir(fullfile(options.procs.path{3}, 'marged*'));
    file_list = string({dir(append(options.procs.path{3}, '/*/*.mat')).name});
    roi_all = full(load(fullfile(options.procs.path{3}, folder_list(end).name ,file_list(end))).n_roi3);

    nonCell_ID = find(CellUse==0);
    Cell_ID = find(CellUse==1);
    
    nonCell_roi = roi_all.*ismember(roi_all, nonCell_ID);
    nonCell_roi_color = label2rgb(nonCell_roi,'hsv','k','shuffle');
    fname_1 = fullfile(options.procs.path{5}, 'ROI_nonCell_color.tiff');
    imwrite(nonCell_roi_color, fname_1);
       
    Cell_roi = roi_all.*ismember(roi_all, Cell_ID);
    Cell_roi_color = label2rgb(Cell_roi,'hsv','k','shuffle');
    fname_2 = fullfile(options.procs.path{5}, 'ROI_Cell_color.tiff');
    imwrite(Cell_roi_color, fname_2);
    
    nonCell_roi_outline = Sub_ROI_outline_map(nonCell_roi);
    fname_3 = fullfile(options.procs.path{5}, 'ROI_nonCell_outline.tiff');
    imwrite(nonCell_roi_outline, fname_3);
    Cell_roi_outline = Sub_ROI_outline_map(Cell_roi);
    fname_4 = fullfile(options.procs.path{5}, 'ROI_Cell_outline.tiff');
    imwrite(Cell_roi_outline, fname_4);
    % ROI metrics, SNR, Artifact Power Ratio, Area, Centroid, CellUse
    ROI_metrics = struct();
    ROI_metrics.SNR = single(vertcat(SNR.Ratio));
    %ROI_metrics.Artifact = single(art_sig_ratio);
    ROI_metrics.NoiseVAR = noise_variance;
    ROI_metrics.Area = single(c(:,1));
    ROI_metrics.Centroid = single(c(:,2:3));
    ROI_metrics.CellUse = logical(CellUse);
    save(fullfile(options.procs.path{5},'ROI_metrics.mat'), 'ROI_metrics', '-v7.3');
    
    fprintf(1,'\t\tPercentage of cells to use %f (%%)\n',sum(CellUse)/length(CellUse)*100);
    fprintf(1,'\t\tThe number of cells to use %d neurons\n',sum(CellUse));
end

