function Sub_Graph_Split_CaResponse_SignalNoise_Ratio(dF_F, SNR, Time, out_path)

close all

global SplitFreq

FolderName = fullfile('Result',sprintf('CaResponse_SplitFreq%4.2f',SplitFreq));
mkdir(FolderName);

for i = 1:length(SNR)
    
    if mod(i,100)==1
        
        fprintf(1,'\t\t%d\n',i);
        clf('reset')
        
        %% Substitute
        y1     = dF_F(i,:);
        y2     = SNR(i).Signal;
        y3     = SNR(i).Noise;
        Ratio  = SNR(i).Ratio;
        
        %% dF_F, Signal
        subplot(4,1,1:3)
        hold on
        plot(Time, y1);
        plot(Time, y2);
        hold off
        xlim([Time(1) Time(end)]);
        set(gca,'FontSize',12);
        set(gca,'FontName','Times New Roman');
        ylabel('df/f');
        set(gca,'TickDir','out');
        grid on
        title(sprintf('Signal Noise Ratio %f', Ratio), 'Interpreter', 'none');
        legend('dF/F', 'Signal', 'Location', 'best');
        
        %% Signal
        subplot(4,1,4)
        plot(Time, y3)
        xlim([Time(1) Time(end)]);
        set(gca,'FontSize',12);
        set(gca,'FontName','Times New Roman');
        ylabel('df/f');
        set(gca,'TickDir','out');
        grid on
        legend('Noise', 'Location', 'best');

        xlabel('Time (s)');
        
        %% Save
        FileName   = fullfile(FolderName, sprintf('SignalNoiseRatio_%d',i));
        saveas(gcf, strcat(FileName,'png'),'png');
        saveas(gcf, strcat(FileName,'fig'), 'fig');
    end
end

end

