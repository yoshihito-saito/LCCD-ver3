function dF_F = Sub_Calc_dFF(F, F_neuropils, opsions)
 
    % neuro pil subtraction
    Fcorr = F - opsions.correction_constant.* F_neuropils;

    % calculate baseline
    winSize = round(opsions.remove_slow.window * opsions.Samprate);
    Fbase = percentile_filter_time(Fcorr,opsions.remove_slow.percentile,winSize);

    % calculate dF/F
    dF_F = (Fcorr - Fbase) ./ Fbase;
end
