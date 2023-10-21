clear all

mkdir('Result');

WW = 2048^2;
T = 500;

for FNum = 1:16
    
    close all
    fprintf(1,'\tFile Number %d\n',FNum);
    
    %% �f�[�^�̓ǂݍ���
    LoadFileName = sprintf('./../1_make_data/result/IMG_V%d.mat',FNum);
    load(LoadFileName);
    % ImageData = eval(sprintf('IMG_V%d',FNum));
    ImageData = IMG_V;  
    TD_V = reshape(ImageData,[WW,T]);
    [FF,NN]=size(TD_V);
    Height = sqrt(FF);
    Width = Height;
    
    aveFrame=mean(TD_V,2); % ���ԕ���
    avIMG = reshape(aveFrame,Height,Width);
    
    %% ���L�V�J���X�t�B���^�̒���
    sfl_size = 7; % ��ԃt�B���^��+-�����킹���傫�� 2.5�͓�����+����
    SP_fil = fspecial('gaussian',sfl_size,1.25) - fspecial('average',sfl_size);
    % SP_fil = fspecial('gaussian',sfl_size,1.5) - fspecial('average',sfl_size);
    % SP_fil = fspecial('gaussian',sfl_size,2.5) - fspecial('average',sfl_size);
    
    %% �ړ����σt�B���^�̒���
    filter_size_1 = 100; % (Frame) �x�������̍폜�t�B���^
    moving_ave_fil_1 = ones(1,filter_size_1)./filter_size_1;
    filter_size_2 = 4; % (Frame) ���������̍폜�t�B���^
    moving_ave_fil_2 = ones(1,filter_size_2)./filter_size_2;
    
    filtered_V = max(conv2(TD_V,moving_ave_fil_2,'same')-conv2(TD_V,moving_ave_fil_1,'same'),0);
    lumi_max_img_2d = max(conv2(reshape(max(filtered_V,[],2),Height,Width),SP_fil,'valid'),0);
    % lumi_max_img_2d = max(conv2(reshape(max(filtered_V,[],2),Height,Width),SP_fil,'valid'),0);
    
    %% �K�i��
    max_int = max(max(lumi_max_img_2d,[],1),[],2);
    min_int = min(min(lumi_max_img_2d,[],1),[],2);
    lumi_max_img = (lumi_max_img_2d-min_int)./(max_int-min_int);
    
    figure;
    imagesc(lumi_max_img);
    
    %% adathisteq�ŃR���g���X�g����
    mask = adapthisteq(lumi_max_img);
    figure;
    imagesc(mask);
    
    mx = max(max(mask,[],1),[],2);
    mn = min(min(mask,[],1),[],2);
    %mask��0~1�ŋK�i�i�R���g���X�g�������s������A0~1�ŋK�i���j
    mask = (mask - mn)./(mx-mn);
    
    level = graythresh(mask);% 臒l������
    BW = im2bw(mask,level); % �������l�Ɋ�Â��A�C���[�W���o�C�i�� �C���[�W�ɕϊ�
    BW2 = kubire_delete(BW); %�P�s�N�Z���Ŋ���ĘA�����Ă���̈���Q�ɕ�����(1 pixel�d�Ȃ��Ă���ꍇ�A2�ɕ���)
    label_MAT = bwlabel(BW2,8);%ROI�Ƀ��x���t��
    RROI = ROI_delete1(label_MAT,20,50);% pixel���őI��(20�`10000 pixel�݂̂����)
    roi_num = max(max(RROI,[],1),[],2);
    [Height2,Width2]=size(RROI);
    
    %% image�̒[��0�Ŗ��߂�(���E�l�����̂悤�Ȃ���)
    sss = floor(sfl_size./2);
    E_ROI = [zeros(sss,sss), zeros(sss,Width2), zeros(sss,sss);...
        zeros(Height2,sss),RROI,zeros(Height2,sss);...
        zeros(sss,sss), zeros(sss,Width2), zeros(sss,sss)];
    
    disp(roi_num);
    
    
    %% �ȉ~�t�B���^�őI��
    eccen_th = 0.99; 
    err_th = 1.8;
    [soma_ROI,dend_ROI,roi_num_asso1,roi_num_asso2,out_num] =...
    ellipse_filter(E_ROI,eccen_th,err_th);
    
    %figure_plot
    roi_color_plot(soma_ROI,avIMG);
    SaveFileName = sprintf('Result/roi%d.mat',FNum);
    save(SaveFileName,'soma_ROI');
    
end
