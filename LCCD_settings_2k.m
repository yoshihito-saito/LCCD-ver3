code_path = '/your directory/LCCD-ver3-main';
data_Dir = 'your directory';
raw_path = uigetdir(data_Dir);
out_Dir = replace(raw_path, '01_data', '02_analysis');
out_path = append(out_Dir, '/01_ROI_detection');

addpath(genpath(code_path));

procs = {
    '01_NoRMCorre',         1;... %1
    '02_simp_roi_detect',   1;... %1
    '03_roi_marge',         1;... %1
    '04_signal_extraction', 1;...
    '05_calculate_metrics',1;
    '06_region_mapping',0;}; %Still need to modify the code
paths = cellfun(@(x) fullfile(out_path, x), procs(:,1), 'uni', 0);
options.procs = cell2table(cat(2, procs, paths), ...
    'variablenames',{'proc','exec','path'});

options.useGPU = true; %false;
% Default parameters are for 1K imaging
%% parameters 
options.code_patj = code_path;
options.atlas_path = append(raw_path, '/atlas.mat');
options.raw_path = raw_path;

options.Samprate = 7.65;
%% Concatinate multiple recording
options.concat = 0;

%% for 01_NoRMCorre
options.opt_noRMCorre.d1 = 2048;
options.opt_noRMCorre.d2 = 2048;
options.opt_noRMCorre.grid_size = [128,128];
options.opt_noRMCorre.overlap_pre = [32,32];
options.opt_noRMCorre.mot_uf = 4;
options.opt_noRMCorre.bin_width = 250;
options.opt_noRMCorre.max_shift = 20;
options.opt_noRMCorre.max_dev = [8,8];
options.opt_noRMCorre.output_type = 'hdf5';
options.opt_noRMCorre.mem_batch_size = 250;
options.opt_noRMCorre.us_fac = 50;
options.opt_noRMCorre.upd_template = 0;
%% for 02_simp_roi_detect
% Gaussian filter
options.sigma = 0.5; % 0.2 for 2k

% Background substruction rolling ball filter size
options.rollingball = 5; %pixels
% Threshold modulation: 
% 0 means no modulation after threhsolding by Otsu method.
% subtract defined value from the estimated threshold value.
options.threshold_mod = 0;
% pixel数
options.pixels_range = [30 100];%[30, 120];
% 偏心度
options.eccen_th = 0.75; %small value -> circule
options.err_th = 1.2;

%% for 03_roi_marge
options.a = 0.6; %0.4 %ROIをマージさせる際の重なっている割合（例：0.3=30%）
%options.pixels_range = [30, 80];

%% for 04 signal extraction
options.dilate_pixel_for4.in  = 2; %2
options.dilate_pixel_for4.out = 9; %9


% correction_constant for 04
options.correction_constant = 0.7;


% for 04
% Parameters for removing slow component
options.remove_slow.window     = 60; % (sec) 15sec for Ota et al, 60sec for Stringer et al,
options.remove_slow.percentile = 8; % (%)

% for 05
% SNR Split frequency
options.SplitFreq = 1;   % 0.5;(Hz)
options.Threshold.SN  = 3;  % More than
%
options.Threshold.dff_ceiling = 10; % Less than
options.Threshold.dff_floor  = -1; % More than
%
options.Threshold.corr = 0.8; % Threshold for nearby-ROIs correlation
options.Threshold.nearby = 1.5; % 近傍判定（ROI直径に対する比）

%Noise variance
options.NoiseLowHigh = [1,3.75];
options.Threshold.noisevar = 0.015;
