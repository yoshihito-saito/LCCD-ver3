function MainFun_detect_SJIS(in_path, out_path, options)
    mkdir(out_path);
    addpath(in_path);

    file_list = dir(fullfile(in_path, '*.h5')); 
    for FNum = 1:length(file_list)
        
        close all
        fprintf(1,'\tFile Number %d\n',FNum);
        
        %% データの読み込み
        LoadFileName = fullfile(in_path, sprintf('IMG_V%02d.h5', FNum))
        
        ImageData = h5read(LoadFileName, '/mov');
        [Height, Width, T] = size(ImageData);
        TD_V = reshape(ImageData(:,:,1:T),[Height*Width,T]);
        
        aveFrame=mean(TD_V,2); 
        avIMG = reshape(aveFrame,Height,Width);
        
        %% メキシカン帽フィルタの調整
        sfl_size = options.sfl_size; %7; % 空間フィルタの+-を合わせた大きさ 2.5は内部の+部分
        SP_fil = fspecial('gaussian',sfl_size, options.gauss_sigma) - fspecial('average',sfl_size);
        % SP_fil = fspecial('gaussian',sfl_size,1.5) - fspecial('average',sfl_size);
        % SP_fil = fspecial('gaussian',sfl_size,2.5) - fspecial('average',sfl_size);
        
        %% 移動平均フィルタの調整
        filter_size_1 = options.filter_size_1; %100; % (Frame) 遅い成分の削除フィルタ
        moving_ave_fil_1 = ones(1,filter_size_1)./filter_size_1;
        filter_size_2 = options.filter_size_2; %4; % (Frame) 早い成分の削除フィルタ
        moving_ave_fil_2 = ones(1,filter_size_2)./filter_size_2;
        
        tic;
        filtered_V = max(conv2(TD_V,moving_ave_fil_2,'same')-conv2(TD_V,moving_ave_fil_1,'same'),0);
        lumi_max_img_2d = max(conv2(reshape(max(filtered_V,[],2),Height,Width),SP_fil,'valid'),0);
        
        %% 規格化
        max_int = max(max(lumi_max_img_2d,[],1),[],2);
        min_int = min(min(lumi_max_img_2d,[],1),[],2);
        lumi_max_img = (lumi_max_img_2d-min_int)./(max_int-min_int);
        
        figure;
        imagesc(lumi_max_img);
            
        %% adathisteqでコントラスト強調
        mask = adapthisteq(lumi_max_img);
        figure;
        imagesc(mask);
        
        mx = max(max(mask,[],1),[],2);
        mn = min(min(mask,[],1),[],2);
        %maskを0~1で規格（コントラスト強調を行った後、0~1で規格化）
        mask = (mask - mn)./(mx-mn);
        
        level = graythresh(mask); % 閾値を決定
        BW = im2bw(mask,level); % しきい値に基づき、イメージをバイナリ イメージに変換
        BW2 = kubire_delete(BW); %１ピクセルで括れて連結している閉領域を２つに分ける(1 pixel重なっている場合、2つに分離)
        if options.useGPU
	        label_MAT = bwlabel(gpuArray(BW2),8); %ROIにラベル付け
	    else
	        label_MAT = bwlabel(BW2,8); %ROIにラベル付け
	    end
        RROI = ROI_delete1(label_MAT,options.pixels_range(1),options.pixels_range(2)); % pixel数で選別
        roi_num = max(RROI(:));
        [Height2,Width2]=size(RROI);
        
         %% imageの端を0で埋める(境界値条件のようなもの)
        sss = floor(sfl_size./2);
        E_ROI = [zeros(sss,sss), zeros(sss,Width2), zeros(sss,sss);...
            zeros(Height2,sss),RROI,zeros(Height2,sss);...
            zeros(sss,sss), zeros(sss,Width2), zeros(sss,sss)];
        
        disp(roi_num);
        
        %% 楕円フィルタで選別
        eccen_th = options.eccen_th; %0.99; 
        err_th = options.err_th;     %1.8;
        [soma_ROI,dend_ROI,roi_num_asso1,roi_num_asso2,out_num] =...
            ellipse_filter(E_ROI,eccen_th,err_th);
        
        %figure_plot
        roi_color_plot(soma_ROI,avIMG);
        SaveFileName = fullfile(out_path, sprintf('roi%d.mat',FNum));
        save(SaveFileName,'soma_ROI');
        
    end

end