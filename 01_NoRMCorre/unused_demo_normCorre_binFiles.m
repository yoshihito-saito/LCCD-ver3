function demo_normCorre_binFiles(in_path, out_path, options)
	%clear
	%gcp;
	addpath(genpath('./NoRMCorre-master'));

	im_siz = [options.d1, options.d2];
	frames_h5 = 500;

	fbas = 'Falcon%d.bin';

	im_enum = prod(im_siz);
	M1_a = zeros(im_siz);
    
    mkdir(out_path);
    
    file_list = dir(fullfile(in_path, 'h5'));
    file_list = {file_list.name};
	for ix=0:length(file_list)-1

	    %% set parameters
        options.h5_filename = fullfile(out_path, sprintf('IMG_V%d.h5',ix+1));
% 	    options_rigid = NoRMCorreSetParms(...
% 	                       'd1',im_siz(1),'d2',im_siz(2),...
% 	                       'bin_width',50,'max_shift',15,...
% 	                       'output_type','hdf5', ...
% 	                       'h5_filename', fullfile(out_path, sprintf('IMG_V%d.h5',ix+1)), ...
% 	                       'mem_batch_size', 250,...
% 	                       'us_fac',50);

	    y = zeros(im_enum, frames_h5, 'uint16');
	    for ix_f=1:frames_h5
	        fnam = fullfile(in_path, sprintf(fbas, ix*frames_h5+ix_f))
	        fid = fopen(fnam, 'rb');
	        y(:,ix_f) = fread(fid, im_enum, '*uint16');
	        fclose(fid);
	    end

		Y = single(reshape(y, im_siz(1), im_siz(2), []));
		T = size(Y,ndims(Y));

	    %% perform motion correction
	    if exist('template1', 'var')
	       tic; [M1,shifts1,template1] = normcorre(Y,options_rigid,template1); toc
	       shifts1a = vertcat(shifts1a, shifts1);
	    else
	       tic; [M1,shifts1,template1] = normcorre(Y,options_rigid); toc     
	       shifts1a = shifts1;
	    end
	    
	    %M1_a = cat(3, M1_a, M1);
	end
	%M1_a(:,:,1) = [];
	save(fullfile(out_path,'info.mat'), 'shifts1a', 'template1');
	
end