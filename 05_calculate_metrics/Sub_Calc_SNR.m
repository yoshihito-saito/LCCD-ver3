function SNR = Sub_Calc_SNR(dF_F, options)
    % Parameters
    epoch = 10; % sec
    winSize = round(epoch*options.Samprate);
    
    parfor i = 1:size(dF_F, 1)
        % Welch のPSDを計算
        [psd, f] = pwelch(dF_F(i, 1:size(dF_F,2)-1), hann(winSize), winSize/2, winSize, options.Samprate);
        
        % 信号周波数帯のPSD和
        signal_freq_pw = sum(psd(f < options.SplitFreq)); 
        
        % ノイズ周波数帯のPSD和
        noise_freq_pw = sum(psd(f >= options.SplitFreq)); 
        
        % SNRの計算（対数を取ってdBでのSNRを求める）
        SNR(i) = 10 * log10(signal_freq_pw / noise_freq_pw);
        %SNR(i) = (signal_freq_pw / noise_freq_pw);
    end
end