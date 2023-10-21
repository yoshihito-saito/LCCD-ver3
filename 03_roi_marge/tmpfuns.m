function [varargout] = tmpfuns(ftype, varargin)

switch ftype
case 'check_dup0'        
    roi1 = varargin{1};
    roi2 = varargin{2};
    
    roi1n=max(roi1(:));
    roi2n=max(roi2(:));
    
    rb1=roi1>0;
    rb2=roi2>0;
    
    roi1b=roi1 .* rb2;
    roi2b=roi2 .* rb1;

    x=zeros(roi1n,1);
    for ix=1:roi1n
        x(ix)=sum(sum(roi1b==ix))/sum(sum(roi1==ix));
    end

    x2=zeros(roi2n,1);
    for ix=1:roi2n
        x2(ix)=sum(sum(roi2b==ix))/sum(sum(roi2==ix));
    end
    toc
    
    varargout{1}=x;
    varargout{2}=x2;
    
case 'check_dup1'        
    roi1 = varargin{1};
    roi2 = varargin{2};
    
    roi1n=max(roi1(:));
    roi2n=max(roi2(:));
    
    x=zeros(roi1n,roi2n);
    for ix=1:roi1n
        roi1b=roi1==ix;
        roi2b=roi1b .* roi2;
        a=sum(roi1b(:));
        tmpIx=unique(roi2b(:));tmpIx(tmpIx==0)=[];
        if ~isempty(tmpIx)
        for ix2=tmpIx';%1:length(tmpIx)
            x(ix,ix2)=sum(sum(roi2b==ix2))/a;
        end
        end
    end
    
    varargout{1}=x;    
    
case 'get_pos'
    roi1 = varargin{1};
    
    nroi = max(roi1(:));
    c = zeros(nroi,3);
    for ci=1:nroi        
        bw = full(roi1==ci);
        p1=regionprops(bw, 'centroid', 'majoraxislength', 'area');
        [~,ix] = max([p1.Area]);%display(ix);
        c(ci, :) = [p1(ix).MajorAxisLength, p1(ix).Centroid];
    end
    
    varargout{1} = c;

case 'get_pos_area'
    roi1 = varargin{1};
    
    nroi = max(roi1(:));
    c = zeros(nroi,3);
    for ci=1:nroi        
        bw = full(roi1==ci);
        p1=regionprops(bw, 'centroid', 'area'); %'MajorAxisLength'
        [~,ix] = max([p1.Area]);%display(ix);
        c(ci, :) = [sum(bw(:)), p1(ix).Centroid];
    end
    
    varargout{1} = c;

end

