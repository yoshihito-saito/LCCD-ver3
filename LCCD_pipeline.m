%% Settings
%LCCD_settings;

% make directory for output
mkdir(out_path);
    tic;
if isempty(gcp('nocreate'))
    parpool('local', 32); 
end
%% pipeline
logfname = fullfile(out_path, 'log.txt');
tStart=tic;

% addpath(genpath('.'));

% 01_NoRMCorre
if options.procs.exec(1)
    demo_normCorre_tifFiles(options);
end
%h5_path = '/home/ysaito/Synology/Collab/with_Kao/Two-photon/02_analysis/u059_m01/20200826_saline/01_ROI_detection/test_YS_ver2/01_NoRMCorre';
% 02_simp_roi_detect
if options.procs.exec(2)
    MainFun_detect_SJIS_3(options);
end

% 03_roi_marge
if options.procs.exec(3)
    MainFun_roi_marge_NoRMCorre_SJIS(options);
end

% 04_signal_extraction and neuropil and slow drift correction
% calculate dF/F0
if options.procs.exec(4)
    MainFun_Extract_Signals(options);
end

% 05_calculate_SNratio
if options.procs.exec(5)
    MainFun_QualityMetrics(options);
end

% 11_region_ mapping
if options.procs.exec(6)
    MainFun_RegionMapping(options);
end
tEnd = toc(tStart);
fprintf(1,'\n\tTotal Elapsed time %4.2f min\n\n', tEnd/60);
diary off;
delete(gcp('nocreate'));