function [F] = Sub_ExtractSave_ROI_rev3(ROI, Image, FileNum, c, out_path)

SaveFileName = fullfile(out_path, sprintf('ROI_Signal_File%d.mat',FileNum));
Image=single(Image);

[nPixelY, nPixelX, nFrame]  = size(Image);
nPixelXY = nPixelX * nPixelY;
nROI     = max(max((ROI)));
%%%%%%%%%%%%%

% Reshape Image date for extracting fluorescence
ReshapeData = reshape(Image,[nPixelXY, nFrame]);
parfor RNum = 1:nROI
    Index{RNum} = uint32(find(ROI==RNum));
end
% Extract fluorescence
F=cellfun(@(x) mean(ReshapeData(x,:)), Index, 'UniformOutput', false);
F = cell2mat(F');
save(SaveFileName,'F');
fprintf(1,'\t\t\tElapsed time %4.2f min\n\n', toc/60);

end


