function predicted_outlier_index = Sub_detectOutlier(art_sig_ratio, SNR_use, out_threshold)
    predicted_outlier_index = zeros(length(art_sig_ratio),1);
    x_train = [art_sig_ratio, SNR_use];
    
    [~,~,outlier_score] = iforest(x_train,ContaminationFraction=0.01);
    predicted_outlier_index(outlier_score > out_threshold) = 1;
    predicted_outlier_index(SNR_use > 10) = 0;

end

