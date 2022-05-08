function [threshold, H]=energy_det_with_adaptive_th(M,L,y, NoSpTs)
%% [threshold, H]=energy_det_with_adaptive_th(M,L,y)
% is energy detection with adaptive threshold
% M is Number of symbol intervals that sensed
% L is number of symbols that we want to be sence
% y is signal that recieved at SU
% H is present-absent vector, 1-> SU is present
%                           , 0-> SU is absent
% threshold is variancce of noise
x = []; % observation vector that each symbol interval is updated
threshold=[];
H = zeros(1,M);
% threshold = 0.010;
for i = 1 : M
    % x is observation signal that is sampeled by L sampels in Ts
    x=[x,y(NoSpTs*(i-1)+1:NoSpTs*i)]; % update x
    E_of_x = sum(x.^2); %compute energy of x
    % Test Statistic for the energy detection
    TS_of_x = E_of_x/(L*NoSpTs);
    threshold(i)=estimate_var_of_noise(x);
    % decision making
    if TS_of_x > threshold(i)
        H(i)=1;
    else
        H(i)=0;
    end
end