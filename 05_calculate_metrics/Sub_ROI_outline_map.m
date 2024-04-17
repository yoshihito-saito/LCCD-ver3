function ROI_outline_color=Sub_ROI_outline_map(ROI)

    % ユニークなインデックスの取得
    uniqueIndices = unique(ROI(:));
    uniqueIndices(uniqueIndices == 0) = []; % 背景（0）を除外
    
    % 結果行列の初期化
    resultMatrix = zeros(size(ROI));
    
    % 各ユニークなインデックスに対して輪郭を検出
    for i = 1:length(uniqueIndices)
        % 現在のインデックスに対応するバイナリマスクを作成
        binaryMask = ROI == uniqueIndices(i);
    
        % 輪郭の検出
        contour = bwperim(binaryMask);
    
        % 輪郭にインデックス値を設定
        resultMatrix(contour) = uniqueIndices(i);
    end
    
    ROI_outline_color = label2rgb(resultMatrix,'hsv','k','shuffle');
    %alphaChannel = resultMatrix ~= 0;
%    rgbaImage = cat(3, ROI_outline_color, alphaChannel);

    close all
end