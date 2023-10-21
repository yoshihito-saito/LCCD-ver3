function [ ] = roi_color_plot_rev1(RROI,avIMG)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

%このパラメータを画像ごとに調整してください。
brightness_para = 200;
[Height,Width] = size(RROI);

max_int = max(max(avIMG,[],1),[],2);
min_int = min(min(avIMG,[],1),[],2);
AVI = uint16((avIMG-min_int)./(max_int-min_int).*brightness_para);

AV_IMAGE = ind2rgb(AVI,colormap(gray));

roi_img = uint16(round(RROI.*0.005));
%ROI_IMAGE = ind2rgb(roi_img,colormap(winter));
ROI_IMAGE = ind2rgb(roi_img,colormap(prism));

Idx=RROI>0;
for i=1:size(AV_IMAGE,3)
    tmpA=AV_IMAGE(:,:,i);
    tmpR=ROI_IMAGE(:,:,i);
    %tmpA(RROI>0)=tmpR(RROI>0);
    tmpA(Idx)=tmpR(Idx);
    %tmpIdx=find(RROI>0);
    %tmpA(tmpIdx)=tmpR(tmpIdx);
    AV_IMAGE(:,:,i)=tmpA;
end

%figure;
%image(AV_IMAGE);
%set(gcf,'PaperPositionMode','Auto')
%set(gca,'Units','normalized','Position',[0 0 1 1])
%image(AV_IMAGE);
%imwrite(AV_IMAGE,'soma_ROItmp.tif');

end

