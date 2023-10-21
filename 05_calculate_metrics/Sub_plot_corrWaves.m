function Sub_plot_corrWaves(dF_F, dPerDia, out_path)
    rdF=corr(dF_F');
    l=(rdF>.8)&(dPerDia>1);
    [ri,ci]=find(l);xi=[ri,ci];
    xi_n=size(xi,1);
    %xi_r=xi(:,[2,1]);dub_i=false(xi_n,1);

    mkdir(fullfile(out_path, 'WavCorr'));
    pn=ceil(xi_n*.02)*10;
    spn=4;
    fstr=strcat(repmat('%d-',1,4));
    fstr=['Wav-', fstr(1:end-1), '.fig'];
    xx=unique(xi(:));xx_n=length(xx);
    xi2=randperm(xx_n)';
    xi2=sort(xx(xi2(1:pn)));
    figure(1);

    for ix=1:pn
        p=rem(ix,spn);
        if p==0
            p=spn;
        end
        subplot(spn,1,p);
        tmpxi=xi(xi(:,1)==xi2(ix),:);
        tmpxi=[xi2(ix);tmpxi(:,2)];
        plot(dF_F(tmpxi,:)');
        str=strrep(num2str(tmpxi','%d-'),' ','');
        legend(strsplit(num2str(tmpxi'),' '));

        if p==spn
            saveas(1, fullfile(out_path, 'WavCorr',...
                sprintf(fstr, xx(ix-(spn-1:-1:0)))));
        end
    end

end