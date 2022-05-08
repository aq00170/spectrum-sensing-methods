function [y, Chance] = simulate_SU_reciever(Pr_sig, snr, M, L, NoSpTs)
%% [y, Chance] = simulate_SU_reciever(Pr_sig, snr, M,L) sumulate signal that we recieve 
% in the input of SU's RX
% Pr_sig is signal that generated in output of Primary User's TX
% snr is signal-to-noise-ratio(SNR)
% M is Number of symbol intervals that sensed
% L is Number of symbols that PU is transmited
% y is signal the we recieve in the input of SU's RX
% Chance is vector of real present-absent PU
%%
Chance = randi([0, 1], [1, M]); % PU with prob. 0.5 send and with prob. 0.5 is not send
% snr = 18;
% M = L;    % M is Number of symbol intervals that sensed
y=[];   %signal that recieved at SU
% simulate cognitive environment
% simulate SU reciever
for i = 1 : M
   if Chance(i) == 1
    % g(t) is a pulse with 1 amplitude for Ts = Tb duration
    y1=Pr_sig(NoSpTs*(i-1)+1:NoSpTs*i);
    y2=addnoise(snr,y1,NoSpTs);
    y =[y y1 + y2];
   else
    y=[y, addnoise(snr,Pr_sig(NoSpTs*(i-1)+1:NoSpTs*i),NoSpTs)];
   end
end