function Sub_PlotNoisySignal(Time, dF_F, noise_variance, options)
    noise_th = options.Threshold.noisevar;
    plot_noise_idx = find(noise_variance<noise_th+0.05&noise_variance>noise_th); %noisy signals for plotting
    plot_signal_idx = find(noise_variance>noise_th-0.05&noise_variance<noise_th); %noisy signals for plotting
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
    title('Above noise var. threshold signal')
    exportgraphics(gcf, fullfile(options.procs.path{5},'Above_noisevar_signal.pdf'), 'Resolution',300);

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
    title('Under noise var. threshold signal')
    exportgraphics(gcf, fullfile(options.procs.path{5},'Under_noisevar_signal.pdf'), 'Resolution',300);

    close all
end
