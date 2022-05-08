function y = addnoise(desired_snr,Pr_sig,NoSpTs)
%% y = addnoise(desired_snr,Pr_sig,NoSpTs) gets desired_snr (in db) and NoSpTs 
% (number of sampels per symbol) as 2 scalrs and gets PR_sig(primary signal)
%  as a row vector of same dimension
%  y is signal plus noise
%%
y = zeros(numel(Pr_sig),1);
%% block2
% measure energy of primary signal
%  fft of Pr_sig
F = fft(Pr_sig,100);
% Energy of received signal over 100*L samples
E_of_Pr_sig = sum(F.*conj(F),'all');
E_of_Pr_sig = sum(Pr_sig.^2);
% Test Statistic for the energy detection
TS_of_Pr_sig = E_of_Pr_sig/(NoSpTs);
% calculate power of Noise that reach us to desired SNR
% desired_snr = 28;     %for test
sigma2= E_of_Pr_sig/db2pow(desired_snr)/(NoSpTs);
% construst noise with required sigma2
noise = wgn(1,numel(Pr_sig),pow2db(sigma2));
% %%calculate SNR for test%%
% Energy of noise over 100*L samples
% E_of_noise = sum(noise.^2);
% SNR = E_of_Pr_sig/E_of_noise;
% SNR = pow2db(SNR);
y = Pr_sig + noise;
end