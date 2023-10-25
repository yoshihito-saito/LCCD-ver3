function output = percentile_filter_time(input, percentile, windowSize)
    tStart=tic;
    % This function applies the percentile filter across the time axis of a 2D matrix.

    [num_neurons, num_times] = size(input);
    output = zeros(num_neurons, num_times, 'double');
    parfor i = 1:num_times
        idxStart = max(1, i-floor(windowSize/2));
        idxEnd = min(num_times, i+floor(windowSize/2));
        output(:,i) = prctile(input(:,idxStart:idxEnd), percentile, 2);
    end
  
   
    %{
    output  = zeros(size(input), 'double');
    parfor SP = 1:size(input,2)
        
        % ExtractSP = SP-WindowSP+1:SP+WindowSP;
        ExtractSP = SP-windowSize/2:SP+windowSize/2-1;
        if ExtractSP(1) <= 1 && size(input,2) >= ExtractSP(end)
            ExtractSP = 1:windowSize;
        elseif ExtractSP(1) >= 1 && size(input,2) <= ExtractSP(end)
            ExtractSP = SP-windowSize+1:size(input,2);
        end
        ExtractF  = input(:,ExtractSP);
        
        SortF = sort(ExtractF,2);
        PercentileSP   = ceil(size(ExtractF,2) * percentile /100);
        output(:,SP) = SortF(:,PercentileSP);
        
    end
    %}
    tEnd = toc(tStart);
    fprintf(1,'\n\tElapsed time %4.2f min\n\n', tEnd/60);
end