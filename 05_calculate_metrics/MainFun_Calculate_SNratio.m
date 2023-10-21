function MainFun_Calculate_SNratio(path_6B, path_9B, out_path, options)

    close all
    warning('off','MATLAB:MKDIR:DirectoryExists'); % Turn off the waring showing "the directory already exists"
    warning('off','MATLAB:legend:IgnoringExtraEntries'); % Turn off the waring showing "the extra legneds are ignored"
    tic;

    global SampRate
    global SplitFreq

    %% Date, file number
    %ReadFileNum = options.ReadFileNum; %[3];
    SampRate    = options.Samprate; %7.65;     % fps

    %% Split frequency used for SNR calculation
    SplitFreq = options.SplitFreq; %1.0;   % 0.5;(Hz)

    %% Threshold for decision of cells to use
    %% Threshold for nearby-correlation
    Threshold = options.Threshold;

    %% Make Save Folder
    mkdir(out_path);

    %% Load Calcium Signal
    fprintf(1,'\tLoad Calcium Signal\n');
    [dF_F, ~] = Sub_Load_CalciumSignal(path_9B);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% load ROI center position
    load(fullfile(path_6B, 'centerpos.mat'), 'c');

    %% Calculate time
    fprintf(1,'\tCalculate time\n');
    Time = (1:size(dF_F,2))/SampRate;
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Plot Correlated Waves
    d=pdist2(c(:,2:3),c(:,2:3));
    dPerDia=bsxfun(@rdivide,d, c(:,1)*2);
    rdF=corr(dF_F');
    rdF(logical(eye(size(c,1))))=0;
    %Sub_plot_corrWaves(dF_F, dPerDia, out_path);

    %% Split Ca response into signal and noise
    fprintf(1,'\tSplit Ca response into signal and noise\n');
    SNR = Sub_Split_CaResponse_SignalNoise(dF_F, out_path);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Calculate Signal Noise Ratio
    fprintf(1,'\tCalculate Signal Noise Ratio\n');
    SNR = Sub_Calculate_SignalNoiseRatio(SNR);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

%{
    %% Historgram SNR
    fprintf(1,'\tHistorgram SNR\n');
    Sub_Histogram_SNR(SNR, out_path);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Graph Split Ca response and SN ratio
    fprintf(1,'\tGraph Split Ca response and SN ratio\n');
    Sub_Graph_Split_CaResponse_SignalNoise_Ratio(dF_F, SNR, Time, out_path);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);
%}

    %% Check overdivided ROIs 
    [nearby_CellUse, grps] = Sub_Check_nearbyCellToUse(rdF, dPerDia, SNR, Threshold);


    %% Decide Cells to Use
    fprintf(1,'\tDecide Cells to Use ID\n');
    Sub_Decide_CellsToUse(dF_F, SNR, Threshold, nearby_CellUse, out_path);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Save Signal Noise Ratio
    fprintf(1,'\tSave Signal Noise Ratio\n');
    Sub_Save_SignalNoiseRatio(out_path, SNR);
    fprintf(1,'\t\tElapsed time %4.2f min\n', toc/60);

end