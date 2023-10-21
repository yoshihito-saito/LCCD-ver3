function Sub_Histogram_SNR(SNR, FolderName)

close all

global SplitFreq

%% Substitute
for i=1:length(SNR)
    Ratio(i)  = SNR(i).Ratio;
end

%% Histogram
Edges = min(Ratio):0.2:max(Ratio);
Hist.x = (Edges(1:end-1)+Edges(2:end))/2;
Hist.y =  histcounts(Ratio, Edges);

%% Plot
plot(Hist.x, Hist.y, 'LineWidth', 1);
set(gca,'FontSize',12);
set(gca,'FontName','Times New Roman');
xlabel('Signal Noise Ratio');
ylabel('Frequency');
title( sprintf('SplitFreq%4.2f',SplitFreq));
grid on

%% Save
FileName   = fullfile(FolderName, sprintf('Histogram_SplitFreq%4.2f',SplitFreq));
saveas(gcf, strcat(FileName,'.png'),'png');
saveas(gcf, strcat(FileName,'.fig'), 'fig');

%% Cumulative distribution
[f, x] = ecdf(Ratio);

%% Plot
plot(x, f*length(SNR), 'LineWidth', 1);
ylim([1 length(SNR)]);
set(gca,'FontSize',12);
set(gca,'FontName','Times New Roman');
xlabel('Signal Noise Ratio');
ylabel('Cumulative number');
title( sprintf('SplitFreq%4.2f',SplitFreq));
grid on

%% Save
FileName   = fullfile(FolderName, sprintf('Cumulative_SplitFreq%4.2f',SplitFreq));
saveas(gcf, strcat(FileName,'.png'),'png');
saveas(gcf, strcat(FileName,'.fig'), 'fig');
end

