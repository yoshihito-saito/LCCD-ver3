function SNR = Sub_Split_CaResponse_SignalNoise(Signal, FolderName)
    global SplitFreq

    FolderName = fullfile(FolderName, ...
        sprintf('Power_SplitFreq%4.2f',SplitFreq));

    mkdir(FolderName);

    for SNum = 1:size(Signal,1)
        SignalData = Signal(SNum,:);
        FileName   = fullfile(FolderName, sprintf('Power%05d',SNum));
        %SNR(SNum) = SubSub_Cut_Frequency(FileName, SignalData, SplitFreq, SNum);
        SNR(SNum) = SubSub_Cut_Frequency_noGraph(FileName, SignalData, SplitFreq, SNum);
    end

end

