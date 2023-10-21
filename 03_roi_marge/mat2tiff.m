close all

ROI = n_roi;

% Color map
LoadColorMap = colormap('jet');
close();

% Define New Colormap (Linear interpolation)
x1 = linspace(0,1,size(LoadColorMap,1));
x2 = linspace(0,1,max(ROI(:)));
NewColorMap = interp1(x1,LoadColorMap,x2);
NewColorMap = NewColorMap(randperm(max(ROI(:))),:);

Map_Reshape = zeros([numel(ROI), 3], 'uint8'); % Black
% Map_Reshape = ones([numel(ROI), 3], 'uint8') * 255; % White
for RNum = 1:max(ROI(:))
    Index = find(ROI == RNum);
    Map_Reshape(Index, :) = repmat(NewColorMap(RNum,:)*255, [numel(Index) 1]);
end
Map = reshape(Map_Reshape, [size(ROI), 3]);

imwrite(Map, 'ROI_Map.tiff', 'tiff');


