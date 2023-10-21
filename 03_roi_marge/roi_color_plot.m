function [ ] = roi_color_plot(RROI,avIMG)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

%このパラメータを画像ごとに調整してください。
brightness_para = 200;
[Height,Width] = size(RROI);

max_int = max(max(avIMG,[],1),[],2);
min_int = min(min(avIMG,[],1),[],2);
AVI = uint16((avIMG-min_int)./(max_int-min_int).*brightness_para);

AV_IMAGE = ind2rgb(AVI,colormap(gray));
image(AV_IMAGE);

roi_img = uint16(round(RROI.*0.001));
ROI_IMAGE = ind2rgb(roi_img,colormap(prism));
%ROI_IMAGE = ind2rgb(roi_img,colormap(winter));

for x = 1:Height
    for y = 1:Width
       if RROI(x,y) > 0
        AV_IMAGE(x,y,:) = ROI_IMAGE(x,y,:);
       end;
    end;
end;

figure;
plot(1:10)
set(gca,'Units','normalized','Position',[0 0 1 1])
%set(AV_IMAGE,'PaperPosition',rect)
%サイズ変換
%AV_IMAGE = imresize(AV_IMAGE,[2048 2048]);
image(AV_IMAGE);
%save(AV_IMAGE,'tiff');
imwrite(AV_IMAGE,'roi_marge.tiff');

end

