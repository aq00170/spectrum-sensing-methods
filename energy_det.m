function H=energy_det(M,L,y,threshold,NoSpTs)
%% H=energy_det(M,L,y,threshold)
% is energy detection with adaptive threshold
% M is Number of symbol intervals that sensed
% L is number of symbols that we want to be sence
% y is signal that recieved at SU
% threshold is variancce of noise
% H is present-absent vector, 1-> SU is present
%                           , 0-> SU is absent
x = []; % observation vector that each symbol interval is updated
H = zeros(1,M);
% threshold = 0.010;
for i = 1 : M
    % x is observation signal that is sampeled by L sampels in Ts
    x=[x,y(NoSpTs*(i-1)+1:NoSpTs*i)]; % update x
    E_of_x = sum(x.^2); %compute energy of x
    % Test Statistic for the energy detection
    TS_of_x = E_of_x/(L*NoSpTs);
    % decision making
    if TS_of_x > threshold
        H(i)=1;
    else
        H(i)=0;
    end
end