function [F] = Sub_ExtractSave_Neuropil(Image, LoadFileName, SaveFileName)

    
    % Load Surround ROI Coordinate
    load(LoadFileName, 'Index');
    
    % Numbers
    [nPixelY, nPixelX, nFrame]  = size(Image);
    nPixelXY = nPixelX * nPixelY;
    
    % Reshape Image date for extracting fluorescence
    ReshapeData = reshape(Image,[nPixelXY, nFrame]);

    % Extract fluorescence
    F=cellfun(@(x) mean(ReshapeData(x,:)), Index, 'UniformOutput', false);
    %F=reshape(cell2mat(F), nFrame, [])';
    F = cell2mat(F');
    
    save(SaveFileName,'F');
    
    % MemoryInfo = memory;
    % fprintf(1,'\t\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));
    fprintf(1,'\t\t\tElapsed time %4.2f min\n\n', toc/60);
end


