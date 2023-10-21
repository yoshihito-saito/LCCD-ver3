function art_sig_ratio = Sub_ArtifactFreqPower(dF_F, sf)
    art_sig_ratio = zeros(size(dF_F, 1), 1); % 初期化
    epoch = 10; % sec
    parfor i = 1:size(dF_F, 1)
        % Welch のPSDを計算
        [psd, f] = pwelch(dF_F(i, 1:size(dF_F,2)-1), hann(int32(epoch*sf)), int32(epoch*sf)/2, int32(epoch*sf), sf);
        signal_freq_pw = sum(psd(f < 0.3)); % 信号周波数帯のPSD和
        art_freq_pw = sum(psd((0.3 < f) & (f < 0.7))); % アーチファクト周波数帯のPSD和
        art_sig_ratio(i) = art_freq_pw / signal_freq_pw; % アーチファクト / 信号の割合
    end
    art_sig_ratio = art_sig_ratio;
end
