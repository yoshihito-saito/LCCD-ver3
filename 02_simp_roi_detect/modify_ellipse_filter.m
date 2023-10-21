function [filtered_MAT1,filtered_MAT2,filtered_MAT3,out_num] = modify_ellipse_filter(label_MAT,eccen_th,err_th)
%UNTITLED2 この関数の概要をここに記述
%   詳細説明をここに記述

org_num = max(max(label_MAT,[],1),[],2);
filtered_MAT1 = label_MAT;
filtered_MAT2 = label_MAT;
filtered_MAT3 = label_MAT;

roi_num_asso1 = [];
roi_num_asso2 = [];
roi_num_asso3 = [];

t_soma = 1;
t_dend = 1;
divid = 1;

for k=2:org_num
    ind = find(label_MAT==k);
    area = size(ind,1);
    s1 = regionprops(label_MAT==k,'MajorAxisLength');
    s2 = regionprops(label_MAT==k,'MinorAxisLength');
    s3 = regionprops(label_MAT==k,'Eccentricity');
       if numel(s1)>1 || numel(s2)>1 || numel(s3)>1
          filtered_MAT3(ind) = divid;
          filtered_MAT2(ind) = 0;
          filtered_MAT1(ind) = 0;
          roi_num_asso3 = cat(1,roi_num_asso3,[divid,k]);
          divid = divid+1;
       else  
          ep_area = s1.MajorAxisLength.*s2.MinorAxisLength.*pi./4;
          eccen = s3.Eccentricity;
          error = ep_area/area;   
          if (error > err_th)||(eccen > eccen_th)
             filtered_MAT3(ind) = 0;
             filtered_MAT2(ind) = t_dend;
             filtered_MAT1(ind) = 0;
             roi_num_asso2 = cat(1,roi_num_asso2,[t_dend,k]);
             t_dend = t_dend + 1;
          else
             filtered_MAT3(ind) = 0; 
             filtered_MAT1(ind) = t_soma;
             filtered_MAT2(ind) = 0;
             roi_num_asso1 = cat(1,roi_num_asso1,[t_soma,k]);
             t_soma = t_soma + 1;
          end
       end
end;
out_num = t_soma-1;

end