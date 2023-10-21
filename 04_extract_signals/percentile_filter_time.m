function output = percentile_filter_time(input, percentile, windowSize)
    % This function applies the percentile filter across the time axis of a 2D matrix.
    
    [num_neurons, num_times] = size(input);
    output = NaN(num_neurons, num_times);

    parfor i = 1:num_neurons  % parfor for parallel loop
        for j = 1:num_times
            idxStart = max(1, j-floor(windowSize/2));
            idxEnd = min(num_times, j+floor(windowSize/2));
            output(i, j) = prctile(input(i, idxStart:idxEnd), percentile);
        end
    end
end