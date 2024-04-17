function Sub_Plot_QualityCheck(Time, dF_F, CellUse, options)
    plot_signal_idx = find(CellUse==1); %noisy signals for plotting
    
    for iter = 1:10
        s = RandStream('mlfg6331_64', 'Seed', iter);
        if length(plot_signal_idx) > 50
            cell_id = randsample(s, plot_signal_idx, 50);
        else
            cell_id = plot_signal_idx;
        end
        figure('Position', [500 500 1000 800])
        for i = cell_id
        ii = find(cell_id==i);
        plot(Time, dF_F(i,:)+10*ii, ...
            'LineWidth',1, ...
            'Color',[0.2,0.2,0.2])
        end
        xlim([0 max(Time)]);
        ylim([0 max(ii*5+5)]);
        xlabel('Time (sec)');
        yticks([])
        box off
        title(append('Cell Use signal iter ', string(iter)));
        exportgraphics(gcf, fullfile(options.procs.path{5}, append('Cell_Use_Signal_iter_', string(iter), '.pdf')), 'Resolution',300);
        hold on;
    
    end
    close all
end