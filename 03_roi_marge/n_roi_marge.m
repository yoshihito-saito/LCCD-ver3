function [seq_ROI,seq_ROI2,seq_ROI3,roi_num] = n_roi_marge(roi1,roi2,options)
E_ROI1 = roi1;
E_ROI2 = roi2;

tmp_ROI = sparse(E_ROI1);
tmp_ROI2 = sparse(E_ROI2);
[Width,Height] = size(E_ROI1);

if  max(tmp_ROI2(:)) > max(tmp_ROI(:)) 
    tmp = tmp_ROI;
    tmp_ROI = tmp_ROI2;
    tmp_ROI2 = tmp;
end

flag = 1;
while flag == 1
    
    n = max(tmp_ROI(:));
    n2 = max(tmp_ROI2(:));

    ele_t1 = spalloc(Width.*Height,n,nnz(tmp_ROI));
    tmp_ROIa=tmp_ROI(:);
    parfor ii=1:n;ele_t1(:,ii)=tmp_ROIa==ii;end

    ele_t2 = sparse(Width.*Height,n2);
    tmp_ROIa=tmp_ROI2(:);
    parfor ii=1:n2;ele_t2(:,ii)=tmp_ROIa==ii;end

    area=sum(ele_t1)';
    area2=sum(ele_t2)';

    SIM = ele_t1'*ele_t2; 

    [tt,ind] = max(SIM,[],2);
    ind(tt==0)=0;
    
    if nnz(tt)==0
        flag = 0;
    elseif nnz(tt)>0
       %ele_t1a = sparse(Width.*Height,n);
    b=unique(ind)';b(b==0)=[];bcnt=zeros(size(b));
    parfor i=1:length(b);bcnt(i)=sum(ind==b(i));end
    b=b(find(bcnt>1));

    indTmp=[(1:n)',ind];
    indTmp(tt==0,:)=[];
    indTmp_b=indTmp(ismember(indTmp(:,2),b),:);
    indTmp(ismember(indTmp(:,2),b),:)=[];    
    ele_t1a=ele_t1(:,indTmp(:,1));
    ele_t2a=ele_t2(:,indTmp(:,2));
    tt_a=tt(indTmp(:,1));
    SIM_ab=[tt_a./area(indTmp(:,1)), tt_a./area2(indTmp(:,2))];    
 
    %[~, SIM_maxIdx]=max(SIM_ab,[],2);
    res_flg = sum(SIM_ab>=options.a,2)>0; %options.a; ROIをマージさせる際の重なっている割合（例：0.3=30%）
    [~, area_maxIdx]=max([area(indTmp(:,1)), area2(indTmp(:,2))],[],2);
    
    ele_t2a(:, res_flg & area_maxIdx==1)=0;
    ele_t1a(:, res_flg & area_maxIdx==2)=0;
    and_tmp = ele_t1a & ele_t2a;
    ele_t1a(and_tmp)= 0;
    ele_t2a(and_tmp)= 0;
    
    for ii=1:length(b)
        bInd=indTmp_b(find(indTmp_b(:,2)==b(ii)));
        SIM_ab=[tt(bInd)./area(bInd), ...
                    tt(bInd)/area2(b(ii))];        
        res_flg = sum(SIM_ab>options.a,2)>0;
        [~, area_maxIdx]=max([area(bInd), ...
            ones(size(bInd))*area2(b(ii))], [], 2);
        
        for j=1:length(bInd)
            i=bInd(j);
            if tt(i)>0 && res_flg(j)
                if area_maxIdx(j)==1
                    ele_t2(:,b(ii))=0;
                else
                    ele_t1(:,i)=0;
                end
            elseif tt(i)>0 && ~res_flg(j)
                and_tmp = ele_t1(:,i)&ele_t2(:,b(ii));
                ele_t1(and_tmp,i)=0;
                ele_t2(and_tmp,b(ii))=0;
            elseif tt(i)==0
            end
        end     
    end    
    
    ele_t1(:,indTmp(:,1))=ele_t1a; 
    ele_t2(:,indTmp(:,2))=ele_t2a; 
       
    end
    tmp=bsxfun(@times, ele_t1, 1:n);
    tmp_ROI=reshape(sum(tmp,2),Height,[]);
    tmp=bsxfun(@times, ele_t2, 1:n2);
    tmp_ROI2=reshape(sum(tmp,2),Height,[]);

end


%seq_ROI = ROI_delete1(tmp_ROI,30,500);
%seq_ROI2 = ROI_delete1(tmp_ROI2,30,500); 

%seq_ROI = ROI_delete1(tmp_ROI,20,50); %ROIのサイズ pixels
%seq_ROI2 = ROI_delete1(tmp_ROI2,20,50); %ROIのサイズ pixels
seq_ROI = ROI_delete1(tmp_ROI,options.pixels_range(1),options.pixels_range(2)); %ROIのサイズ pixels
seq_ROI2 = ROI_delete1(tmp_ROI2,options.pixels_range(1),options.pixels_range(2)); %ROIのサイズ pixels

seq_ROI3 = seq_ROI;

n = max(seq_ROI(:));
seq_ROI3 = seq_ROI3 + (seq_ROI2 + n*(seq_ROI2>0));

roi_num = max(max(seq_ROI3));

end

