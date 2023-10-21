function [dF_F, F] = Sub_Load_CalciumSignal(in_path, varargin)

if nargin > 1
    correction_constant = varargin{1};
    dilate_pixel = varargin{2};

    FolderName = fullfile(in_path,...
        sprintf('Constant%4.2f_Pixel-in%d-out%d', correction_constant, dilate_pixel.in, dilate_pixel.out));

    % Filename = fullfile(FolderName, 'Before_NeuropilCorrection.mat');
    % load(Filename,'F', 'dF_F');

    Filename = fullfile(FolderName, 'After_NeuropilCorrection.mat');
    load(Filename,'F', 'dF_F');
    
else % for 10_calcurate_SNratio
    Filename = fullfile(in_path, 'After_SlowComponentCorrection.mat');
    load(Filename, 'dF_F');
    F = [];
    
end

end
