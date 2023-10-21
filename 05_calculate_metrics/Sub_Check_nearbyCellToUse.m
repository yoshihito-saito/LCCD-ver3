function [nearby_CellUse, grps] = Sub_Check_nearbyCellToUse(rdF, dPerDia, SNR, Threshold)
    l=(rdF>=Threshold.corr)&(dPerDia<=Threshold.nearby);
    [rows,cols]=find(l);pairs=[rows,cols];
    grps = {};
    for ix=1:size(pairs,1)
        tmp=all(ismember(pairs, pairs(ix,[2,1]))');
        if sum(tmp)>1
            tmp=find(tmp);
            pairs(tmp(2:end),:)=0;
        end
    end
    pairs(sum(pairs,2)==0,:)=[];

    p_roi=unique(pairs);pnroi=size(p_roi,1);
    c_p_roi=zeros(size(p_roi));
    for ix=1:pnroi
        c_p_roi(ix)=sum(sum(pairs==p_roi(ix)));
    end

    [~, sortIx]=sort(c_p_roi, 'descend');
    p_roi=p_roi(sortIx);
    ix=1;pairs0=pairs';cnt=1;
    nearby_CellUse=true(length(SNR),1);
    while pairs0
        tmp=any(pairs0==p_roi(ix));
        if any(tmp)
        grp=unique(pairs0(:,tmp));
        snr=[SNR(grp).Ratio];
        
        grps{cnt}=grp;
        nearby_CellUse(grp(snr~=max(snr)))=false;
        
        pairs0(:,tmp)=[];
        cnt=cnt+1;
        end
        ix=ix+1;
        if ix>pnroi
            fprintf(1, 'over');
            break;
        end
    end

end