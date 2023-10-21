function Sub_Save_SignalNoiseRatio(FolderName, SNR_Struct)

global SplitFreq

SNR  = zeros(1,length(SNR_Struct), 'double');
for i=1: length(SNR_Struct)
    SNR(i)  = SNR_Struct(i).Ratio;
end

FileName = fullfile(FolderName, sprintf('SNR_SplitFreq%4.2f.mat',SplitFreq));
save(FileName, 'SNR', '-v7.3');

end
