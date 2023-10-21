function Sub_PlotOutliearDetection(SNR_use, art_sig_ratio_use, predicted_outlier_index, out_path)
    figure('Position', [500 500 600 400])
    scatter(SNR_use(predicted_outlier_index==0), art_sig_ratio_use(predicted_outlier_index==0), ...
        'MarkerFaceColor',[0.7,0.7,0.7], ...
        'MarkerEdgeColor',[0.2,0.2,0.2])
    hold on;
    scatter(SNR_use(predicted_outlier_index==1), art_sig_ratio_use(predicted_outlier_index==1), ...
        'MarkerFaceColor',[0.7,0,0], ...
        'MarkerEdgeColor',[0.2,0,0])

    xlabel('SNR')
    ylabel('Artifact/signal spectral power ratio')
    title('Artifact detection')
    exportgraphics(gcf, fullfile(out_path,'Artifact_detection.pdf'), 'Resolution',300)
    close all