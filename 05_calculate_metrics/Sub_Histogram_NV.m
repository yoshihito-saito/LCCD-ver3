function Sub_Histogram_NV(noise_variance, options)

close all
%% Histogram
h = histogram(noise_variance);
c = h.BinWidth;
h.BinWidth = 0.0005;
set(gca,'FontSize',12);
set(gca,'FontName','Times New Roman');
xlabel('Noise variance');
ylabel('Count');

%% Save
FolderName=options.procs.path{5};
FileName   = fullfile(FolderName, sprintf('Histogram_NoiseVar'));
saveas(gcf, strcat(FileName,'.pdf'), 'pdf');

end

