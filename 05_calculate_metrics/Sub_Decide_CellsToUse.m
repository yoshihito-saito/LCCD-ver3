function CellUse = Sub_Decide_CellsToUse(dF_F, SNR, Threshold, nearby_CellUse, noise_variance)

global SplitFreq


% df/f
dFF_flag1 = logical(max(dF_F, [], 2) <= Threshold.dff_ceiling);
dFF_flag2 = logical(min(dF_F, [], 2) >= Threshold.dff_floor);

% Signal Noise Ratio
%SN_flag = zeros([size(SNR)], 'logical');
SN_flag = false([size(SNR)]);
for i=1:length(SNR)
    SN_flag(i) = SNR(i).Ratio >= Threshold.SN;
end
% Noise Variance
noisevar_flag = logical(noise_variance <= Threshold.noisevar);

CellUse = dFF_flag1 & dFF_flag2 & SN_flag' & noisevar_flag & nearby_CellUse;

fprintf(1,'\t\tPercentage of cells to use %f (%%)\n',sum(CellUse)/length(CellUse)*100);
fprintf(1,'\t\tThe number of cells to use %d neurons\n',sum(CellUse));
fprintf(1,'\t\t\tThe number of cells to meet the following constions\n');
fprintf(1,'\t\t\t%4.2f less df/f, %f (%%)\n',Threshold.dff_ceiling,sum(dFF_flag1)/length(CellUse)*100);
fprintf(1,'\t\t\t%4.2f more df/f, %f (%%)\n',Threshold.dff_floor,sum(dFF_flag1)/length(CellUse)*100);
fprintf(1,'\t\t\t%4.2f more SN ratio, %f (%%)\n',Threshold.SN, sum(SN_flag)/length(CellUse)*100);
fprintf(1,'\t\t\t%4.2f less Noise variance, %f (%%)\n',Threshold.noisevar, sum(noisevar_flag)/length(CellUse)*100);



%% Save
%FileName   = fullfile(FolderName, sprintf('CellUse_SplitFreq%4.2f.mat',SplitFreq));
%save(FileName, 'CellUse', '-v7.3');

end

