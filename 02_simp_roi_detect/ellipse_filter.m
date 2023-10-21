function [filtered_MAT1,filtered_MAT2,roi_num_asso1,roi_num_asso2,out_num] = ...
    ellipse_filter(label_MAT,eccen_th,err_th)

org_num = max(max(label_MAT,[],1),[],2);
filtered_MAT1 = label_MAT;
filtered_MAT2 = label_MAT;

roi_num_asso1 = [];
roi_num_asso2 = [];

t_soma = 1;
t_dend = 1;
for k=1:org_num
    lk=label_MAT==k;
    ind = find(lk);
    area = size(ind,1);
    s1 = regionprops(lk,'MajorAxisLength','MinorAxisLength','Eccentricity');
    ep_area = s1.MajorAxisLength .*s1.MinorAxisLength .*pi./4;
    eccen = s1.Eccentricity;
    error = ep_area/area;
    
    if (error > err_th)||(eccen > eccen_th)
        filtered_MAT2(ind) = t_dend;
        filtered_MAT1(ind) = 0;
        roi_num_asso2 = cat(1,roi_num_asso2,[t_dend,k]);
        t_dend = t_dend + 1;
    else
        filtered_MAT1(ind) = t_soma;
        filtered_MAT2(ind) = 0;
        roi_num_asso1 = cat(1,roi_num_asso1,[t_soma,k]);
        t_soma = t_soma + 1;
    end;
end;
out_num = t_soma-1;

end

