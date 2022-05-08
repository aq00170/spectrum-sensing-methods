%% In the name of God
% HW_Comp1-SDR-Dr Omidi
% IUT
% Alireza Qazavi
% 9913904
%% block1
clc;clear all;close all;
% information sequence
L = input('How many Symbols you want send as PU(L)     :'); % However many numbers you want.
Tb=1;k=1;Ts=k*Tb;
NoSpTs = input('How many Sampels per Ts(NoSpTs)     :'); %Number of Sampels per Ts
t_symbol = linspace(0,Ts,NoSpTs); % Time vector for one bit information


data = randi([0, 1], [1, L]); %generate sequense of 0 and 1 Information sequence
r = 16;% number of bits that we want to show
figure(1)
subplot(2,1,1)
first_r_data=data(1:r);
stairs([first_r_data,first_r_data(end)], 'linewidth',3), grid on;
title(sprintf('first %dth Information before Transmiting',r));
ylim([0 1.5])
grid on

I=2*data-1; % Data Represented at NZR form

% PU TX
S=[];
for i=1:L
    % g(t) is a pulse with 1 amplitude for Ts = Tb duration
    y1=I(i) .* ones(1,NoSpTs);
    S=[S y1]; % modulated signal vector
end
Pr_sig=S; % transmitting signal after modulation
t=linspace(0,Ts*L,NoSpTs*L);

subplot(2,1,2);
plot(t(1:r*NoSpTs),Pr_sig(1:r*NoSpTs),'linewidth',3), grid on;
title(' signal of primary user ');
xlabel('time(sec)');
ylabel(' amplitude(volt)');
%% block2
% energy detection with adaptive threshold
% sumulate signal that we recieve in the input of SU's RX
M = L;
snr = 18; %db
[y, Chance] = simulate_SU_reciever(Pr_sig, snr, M,L, NoSpTs);
% threshold is a vec. that computes all of thresholds for different Num of 
% observations
[threshold, H]=energy_det_with_adaptive_th(M,L,y, NoSpTs);
figure
plot(threshold,'DisplayName',sprintf('threshold vs. time with M = %d symbol detected',M),...
    'LineWidth',2);
xlabel('time(sec)');ylabel('threshold(estimation of noise power)(watt)');
legend;grid on
[Pmiss,Pfa]=computeFAandMD_prob(Chance,H,M);
fprintf('\nPmiss for addaptive Energy Dection with SNR = %d, M=%d and L = %d is\n  ',snr,M,L)
disp (Pmiss)
fprintf('\nPfa for addaptive Energy Dection with SNR = %d, M=%d and L = %d is\n  ',snr,M,L)
disp (Pfa)
Pmiss_vec = zeros(M/10,1);
Pfa_vec = zeros(M/10,1);
for j = 10:10:M
   [Pmiss,Pfa]=computeFAandMD_prob(Chance,H,j);
   Pmiss_vec(j,1)=Pmiss;
   Pfa_vec(j,1)=Pfa;
end
figure
% we could use plot instead of bar
bar(Pmiss_vec',10,'DisplayName','Pmiss',...
    'LineWidth',2);
title ('Pfa and Pmiss vs. Num of symbol sensed(M)for ED with adaptive Th')
xlabel('Num of symbol sensed(M)');ylabel('Pmiss or Pfa');
legend;grid on;hold on;
bar(Pfa_vec',10,'DisplayName','Pfa',...
    'LineWidth',2);
%% block3
%% energy detection without adaptive threshold
% sumulate signal that we recieve in the input of SU's RX
M = L;
SNR = [-15 20 85]; %db
figure
i=1;
Pmiss_Matrix = zeros(14,3);
Pfa_Matrix = zeros(14,3);
for snr = SNR
    [y, Chance] = simulate_SU_reciever(Pr_sig, snr, M, L,NoSpTs);
    Pmiss_vctr=zeros(14,1);
    Pfa_vctr=zeros(14,1);
    for threshold = 0.2:0.1:1.5
        H=energy_det(M,L,y,threshold, NoSpTs);
        [Pmiss,Pfa]=computeFAandMD_prob(Chance,H,M);
        Pmiss_vctr(int32(10*threshold-1),1)=Pmiss;
        Pfa_vctr(int32(10*threshold-1),1)=Pfa;
    end
    Pmiss_Matrix(:,i) = Pmiss_vctr;
    Pfa_Matrix(:,i) = Pfa_vctr;
    i = i + 1;
end

    subplot(1,2,1)
    for i = 1:3
    plot(0.2:0.1:1.5,Pmiss_Matrix(:,i),'DisplayName',sprintf('SNR = %d dB',SNR(i)),...
        'LineWidth',2);hold on;
    end
    title (sprintf('Pmiss vs. threshold for\nED without adaptive threshold'))
    xlabel('threshold(watt)');ylabel('Pmiss');
    legend;grid on;
    
    subplot(1,2,2)
    for i = 1:3
    plot(0.2:0.1:1.5,Pfa_Matrix(:,i),'DisplayName',sprintf('SNR = %d dB',SNR(i)),...
        'LineWidth',2);hold on;
    end
    title (sprintf('Pfa vs. threshold for\nED without adaptive threshold'))
    xlabel('threshold(watt)');ylabel('Pfa');
    legend;grid on;
%% Covariance Matrix Based Detection
% % sumulate signal that we recieve in the input of SU's RX
M = L;
snr = 18; %db
[y, Chance] = simulate_SU_reciever(Pr_sig, snr, M,L,NoSpTs);
H=cov_det(M,y,NoSpTs);

Pmiss_vec = zeros(M/10,1);
Pfa_vec = zeros(M/10,1);
for j = 10:10:M
   [Pmiss,Pfa]=computeFAandMD_prob(Chance,H,j);
   Pmiss_vec(j,1)=Pmiss;
   Pfa_vec(j,1)=Pfa;
end
figure
bar(Pmiss_vec','DisplayName','Pmiss',...
    'LineWidth',2);
title (sprintf('Pfa and Pmiss vs. Num of symbol sensed(M)\n for Covariance Matrix Based Detection'))
xlabel('Num of symbol sensed(M)');ylabel('Pmiss or Pfa');
legend;grid on;hold on;
bar(Pfa_vec','DisplayName','Pfa',...
    'LineWidth',2);
Pmiss_vctr = zeros(52,1);
Pfa_vctr = zeros(52,1);
for snr = -18:2:84
    [y, Chance] = simulate_SU_reciever(Pr_sig, snr, M,L,NoSpTs);
    H=cov_det(M,y,NoSpTs);
    [Pmiss,Pfa]=computeFAandMD_prob(Chance,H,j);
    Pmiss_vctr(snr/2+10)=Pmiss;
    Pfa_vctr(snr/2+10)=Pfa;
end
    figure
    plot(-18:2:84,Pmiss_vctr,'DisplayName','miss detection prob.',...
        'LineWidth',2);hold on;
    title ('performance of Covariance Matrix Based Detection')
    xlabel('SNR(db)');ylabel('Pmiss or Pfa');
    legend;grid on;
    plot(-18:2:84,Pfa_vctr,'DisplayName','false alarm prob.',...
        'LineWidth',2);hold on;
%% Eigenvalue Based Detection
% sumulate signal that we recieve in the input of SU's RX
M = L;
SNR = [-15 20 85]; %db
for Mode = 1:3
    figure
    i=1;
    Pmiss_Matrix = zeros(14,3);
    Pfa_Matrix = zeros(14,3);
for snr = SNR
    [y, Chance] = simulate_SU_reciever(Pr_sig, snr, M, L,NoSpTs);
    Pmiss_vctr=zeros(14,1);
    Pfa_vctr=zeros(14,1);
    for threshold = 0.2:0.1:1.5
        H=Eigenvalue_Based_Det(M,y,L,threshold,Mode,NoSpTs);
%         H=energy_det(M,L,y,threshold);
        [Pmiss,Pfa]=computeFAandMD_prob(Chance,H,M);
        Pmiss_vctr(int32(10*threshold-1),1)=Pmiss;
        Pfa_vctr(int32(10*threshold-1),1)=Pfa;
    end
    Pmiss_Matrix(:,i) = Pmiss_vctr;
    Pfa_Matrix(:,i) = Pfa_vctr;
    i = i + 1;
end

    subplot(1,2,1)
    for i = 1:3
    plot(0.2:0.1:1.5,Pmiss_Matrix(:,i),'DisplayName',sprintf('SNR = %d dB',SNR(i)),...
        'LineWidth',2);hold on;
    end
    title (sprintf('Pmiss vs. threshold for\n Eigenvalue Based Det mode(%d)',Mode))
    xlabel('threshold(watt)');ylabel('Pmiss');
    legend;grid on;
    
    subplot(1,2,2)
    for i = 1:3
    plot(0.2:0.1:1.5,Pfa_Matrix(:,i),'DisplayName',sprintf('SNR = %d dB',SNR(i)),...
        'LineWidth',2);hold on;
    end
    title (sprintf('Pfa vs. threshold for\nEigenvalue Based Det mode(%d)',Mode))
    xlabel('threshold(watt)');ylabel('Pfa');
    legend;grid on;hold off;
end