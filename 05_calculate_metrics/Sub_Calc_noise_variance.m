function [filtered_dF_F, noise_variance] = Sub_Calc_noise_variance(dF_F, options)
    % calc_noise_variance Calculate noise variance after bandpass filtering
    %
    % Parameters:
    %   dF_F : data matrix
    %   low : bandpass low frequency
    %   high : bandpass high frequency
    %   fs : sampling frequency

    function filtered_data = bandpass(dF_F, low, high, fs)
    % apply_bandpass Apply a bandpass filter to the dF_F data
    %
    % Parameters:
    %   dF_F : Neuron x Time matrix
    %   low : bandpass low frequency
    %   high : bandpass high frequency
    %   fs : sampling frequency

    % Compute Nyquist frequency
    nyq = 0.5 * fs;

    % Normalize by Nyquist frequency
    low = low / nyq;
    high = high / nyq;

    % Design the bandpass filter
    [b, a] = butter(2, [low, high], 'bandpass');

    % Apply the filter to each neuron's time series
    filtered_data = filtfilt(b, a,  double(dF_F)')';  % Transpose because filtfilt operates on columns

    end

    filtered_dF_F = bandpass(dF_F, options.NoiseLowHigh(1), options.NoiseLowHigh(2), options.Samprate);
    noise_variance = var(filtered_dF_F, 0, 2);
end