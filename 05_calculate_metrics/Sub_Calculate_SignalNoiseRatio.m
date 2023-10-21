function SNR = Sub_Calculate_SignalNoiseRatio(SNR)

for i = 1:length(SNR)
    SNR_temp = SNR(i).Signal - mean(SNR(i).Signal);
    SNR(i).Ratio = snr(SNR_temp, SNR(i).Noise);    
end

end
