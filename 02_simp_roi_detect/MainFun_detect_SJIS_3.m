function MainFun_detect_SJIS_3(options)
    in_path = options.procs.path{1};
    out_path = options.procs.path{2};
    mkdir(out_path);
    addpath(in_path);

    file_list = dir(fullfile(in_path, '*.h5')); 
    for FNum = 1:length(file_list)
        
        close all
        fprintf(1,'\tFile Number %d\n',FNum);
        
        %% データの読み込み
        LoadFileName = fullfile(in_path, sprintf('IMG_V%02d.h5', FNum));
        
        ImageData = h5read(LoadFileName, '/mov');
        [Height, Width, T] = size(ImageData);

        %tic;
        lumi_max_img_2d = std((double(ImageData)-mean(ImageData,3))./mean(ImageData,3),[],3);
        lumi_max_img_2d = imgaussfilt(lumi_max_img_2d,options.sigma);
        %lumi_max_img_2d = imgaussfilt(lumi_max_img_2d,0.5);
        se = strel('disk',options.rollingball);
        lumi_max_img_2d = imtophat(lumi_max_img_2d,se);
        

        %% 規格化
        max_int = max(max(lumi_max_img_2d,[],1),[],2);
        min_int = min(min(lumi_max_img_2d,[],1),[],2);
        lumi_max_img = (lumi_max_img_2d-min_int)./(max_int-min_int);
        
        %figure;
        %imagesc(lumi_max_img);
            
        %% adathisteqでコントラスト強調
        mask = adapthisteq(lumi_max_img);
        %figure;
        %imagesc(mask);      
        mx = max(max(mask,[],1),[],2);
        mn = min(min(mask,[],1),[],2);
        %maskを0~1で規格（コントラスト強調を行った後、0~1で規格化）
        mask = (mask - mn)./(mx-mn);
        imwrite(double(mask), fullfile(out_path, sprintf('Image_std_%02d.tif',FNum)));

        %{
        level = graythresh(mask); % 閾値を決定
        BW = im2bw(mask,level); % しきい値に基づき、イメージをバイナリ イメージに変換
        BW2 = kubire_delete(BW); %１ピクセルで括れて連結している閉領域を２つに分ける(1 pixel重なっている場合、2つに分離)
        if options.useGPU
	        label_MAT = bwlabel(gpuArray(BW2),8); %ROIにラベル付け
	    else
	        label_MAT = bwlabel(BW2,8); %ROIにラベル付け
        end
        
        RROI = ROI_delete1(label_MAT,options.pixels_range(1),options.pixels_range(2)); % pixel数で選別
        %}
        
        level = graythresh(mask); % 閾値を決定
        BW = im2bw(mask,level); % しきい値に基づき、イメージをバイナリ イメージに変換
        BW2 = kubire_delete(BW); %１ピクセルで括れて連結している閉領域を２つに分ける(1 pixel重なっている場合、2つに分離)
        % Watershed
        BW3 = imfill(BW2, 'holes');
        %se = strel('disk',2);
        %BW4 = imclose(BW3, se);
        D = -bwdist(~BW3);
        Ld = watershed(D);
        BW5 = BW3;
        BW5(Ld == 0) = 0;
        
        %Remove non-neuon ROI by pixel size
        BW6 = bwareafilt(BW5,[options.pixels_range(1) options.pixels_range(2)]);
        RROI = bwlabel(BW6, 8);
        roi_num = max(RROI(:));
        [Height2,Width2]=size(RROI);
        
         %% imageの端を0で埋める(境界値条件のようなもの)
        %{ 
        sss = floor(sfl_size./2);
        E_ROI = [zeros(sss,sss), zeros(sss,Width2), zeros(sss,sss);...
            zeros(Height2,sss),RROI,zeros(Height2,sss);...
            zeros(sss,sss), zeros(sss,Width2), zeros(sss,sss)];
        %}
         
        disp(roi_num);
        
        %% 楕円フィルタで選別
        eccen_th = options.eccen_th; %0.99; 
        err_th = options.err_th;     %1.8;
        [soma_ROI,dend_ROI,roi_num_asso1,roi_num_asso2,out_num] =...
            ellipse_filter(RROI,eccen_th,err_th);
        %[soma_ROI,dend_ROI,roi_num_asso1,roi_num_asso2,out_num] =...
        %    ellipse_filter(E_ROI,eccen_th,err_th);       
        
        %figure_plot
        %roi_color_plot(soma_ROI,avIMG);
        SaveFileName = fullfile(out_path, sprintf('roi%02d.mat',FNum));
        save(SaveFileName,'soma_ROI');
        
    end

end
