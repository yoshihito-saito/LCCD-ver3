function Sub_PlotSignal(Time, dF_F_use, predicted_outlier_index, out_path)
    s = RandStream('mlfg6331_64', 'Seed', 1);
    if length(find(predicted_outlier_index)) > 20
        noncell_id = randsample(s, find(predicted_outlier_index), 20);
    else
        noncell_id = find(predicted_outlier_index);
    end
    
    cell_id = randsample(s, find(predicted_outlier_index==0), 20);
    
    figure('Position', [500 500 1000 400])
    for i = noncell_id
        ii = find(noncell_id==i);
        plot(Time, dF_F_use(i,:)+5*ii, ...
            'LineWidth',1, ...
            'Color',[0.7,0,0])
    end
    xlim([0 max(Time)]);
    ylim([0 max(ii*5+5)]);
    xlabel('Time (sec)');
    yticks([])
    box off
    title('Artifact signal')
    exportgraphics(gcf, fullfile(out_path,'Artifact_signal.pdf'), 'Resolution',300)

    figure('Position', [500 500 1000 400])
    for i = cell_id
        ii = find(cell_id==i);
        plot(Time, dF_F_use(i,:)+5*ii, ...
            'LineWidth',1, ...
            'Color',[0.2,0.2,0.2])
    end
    xlim([0 max(Time)]);
    ylim([0 max(ii*5+5)]);
    xlabel('Time (sec)');
    yticks([])
    box off
    title('Cell signal')
    exportgraphics(gcf, fullfile(out_path,'Cell_signal.pdf'), 'Resolution',300)

    close all
end
