function  Data2 = SubSub_Cut_Frequency_noGraph(FileName, Data1, SplitFreq, SNum)

global SampRate

%% Time interval, total time, sampling rate, frequency
Nt        = length(Data1);
TotalTime = Nt/SampRate;
dw        = 1/TotalTime;

fq = (0:dw:SampRate/2);   % Powerを求める場合は正確にはこちらを使う
%fq = (0:dw:SampRate-dw); % Positive, Negativeの両方を出力する場合
Nq = length(fq);

%% Fourier transform, Power spectrum
Ns  = length(Data1);
FFT.All   = fft(Data1,Ns);
Pxx.All   = FFT.All .* conj(FFT.All) / Ns;
Power.All = Pxx.All(1:Nq);

%% Cut frequency, cut power spectrum
% Lower frequeny (less than "SplitFreq")
FFT.Low = FFT.All;
FFT.Low(round(SplitFreq/dw)+2:length(Pxx.All)-round(SplitFreq/dw)) = 0.0;   % 整数にしか:を使えないためroundを使用している　ただ、正しいかどうかわからない

% Higher frequency (higher than "SplitFreq")
FFT.High = FFT.All;
FFT.High(1:round(SplitFreq/dw)+1) = 0.0;                               % 整数にしか:を使えないためroundを使用している　ただ、正しいかどうかわからない
FFT.High(length(Pxx.All)-round(SplitFreq/dw)+1:length(Pxx.All)) = 0.0; % 整数にしか:を使えないためroundを使用している　ただ、正しいかどうかわからない

%% Inverse fourier transform
% Lower frequeny (less than "SplitFreq")
Pxx.Low   = FFT.Low .* conj(FFT.Low) / Ns;
Power.Low = Pxx.Low(1:Nq);

% Higher frequency (higher than "SplitFreq")
Pxx.High   = FFT.High .* conj(FFT.High) / Ns;
Power.High = Pxx.High(1:Nq);

%% Inverse fourier transform
Data2.Signal = ifft(FFT.Low,Ns);
Data2.Noise  = ifft(FFT.High,Ns);

%{
%% Png file
if mod(SNum,1000)==1
    close
    % semilogy(fq,Power.Low, 'LineWidth',1,'Color', [1 0 0]); hold on;
    % semilogy(fq,Power.High,'LineWidth',1,'Color', [0 1 0]); hold off;
    loglog(fq,Power.Low, 'LineWidth',1,'Color', [1 0 0]); hold on;
    loglog(fq,Power.High,'LineWidth',1,'Color', [0 1 0]); hold off;
    legend('Power Low','Power High');
    xlim([fq(1) fq(length(fq))])
    grid on
    % ylim([min(Power) max(Power)])
    FileNamePng = strcat(FileName,'.png');
    print('-dpng', FileNamePng);
end
%}

end
