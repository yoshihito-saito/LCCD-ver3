function Sub_PlotLowSNR(Time, dF_F, SNR, options)
    SN_th = options.Threshold.SN;
    Ratio = [SNR.Ratio];
    plot_noise_idx = find(Ratio>SN_th-0.5&Ratio<SN_th)'; %noisy signals for plotting
    plot_signal_idx = find(Ratio<SN_th+0.5&Ratio>SN_th)'; %noisy signals for plotting
    s = RandStream('mlfg6331_64', 'Seed', 1);
    if length(plot_noise_idx) > 50
        noncell_id = randsample(s, plot_noise_idx, 50);
    else
        noncell_id = plot_noise_idx;
    end
    
    figure('Position', [500 500 1000 400])
    for i = noncell_id
        ii = find(noncell_id==i);
        plot(Time, dF_F(i,:)+5*ii, ...
            'LineWidth',1, ...
            'Color',[0.85,0,0])
    end
    xlim([0 max(Time)]);
    ylim([0 max(ii*5+5)]);
    xlabel('Time (sec)');
    yticks([])
    box off
    title('Under SNR treshold signal')
    exportgraphics(gcf, fullfile(options.procs.path{5},'Under_SNR_signal.pdf'), 'Resolution',300);

    if length(plot_signal_idx) > 50
        cell_id = randsample(s, plot_signal_idx, 50);
    else
        cell_id = plot_signal_idx;
    end

    figure('Position', [500 500 1000 400])
    for i = cell_id
        ii = find(cell_id==i);
        plot(Time, dF_F(i,:)+5*ii, ...
            'LineWidth',1, ...
            'Color',[0.2,0.2,0.2])
    end
    xlim([0 max(Time)]);
    ylim([0 max(ii*5+5)]);
    xlabel('Time (sec)');
    yticks([])
    box off
    title('Above SNR treshold signal')
    exportgraphics(gcf, fullfile(options.procs.path{5},'Above_SNR_signal.pdf'), 'Resolution',300);

    close all
end
