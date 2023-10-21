function [OUT_ROI,roi_num_asso,out_num] = ROI_delete1(ROI,mini_roi_size,max_roi_size)
%UNTITLED3 この関数の概要をここに記述
%   詳細説明をここに記述

org_num = max(max(ROI,[],1),[],2);
OUT_ROI = ROI;

roi_num_asso = [];
t = 1;
for k=1:org_num
    ind = find(ROI==k);
    if isempty(ind)==1
        t = t + 0;
    else if (size(ind,1) < mini_roi_size)||(size(ind,1) > max_roi_size)
            OUT_ROI(ind) = 0;
        else
            OUT_ROI(ind) = t;
            roi_num_asso = cat(1,roi_num_asso,[t,k]);
            t = t + 1;
        end;
    end;
end;

out_num = t-1;
    
end

