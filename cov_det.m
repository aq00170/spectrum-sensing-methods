function H=cov_det(M,y,NoSpTs)
%% H=cov_det(M,y)
% is Covariance Matrix Based Detection
% M is Number of symbol intervals that we want to be sensed
% y is signal that recieved at SU
% H is present-absent vector, 1-> SU is present
%                           , 0-> SU is absent
x = []; % observation vector that in each symbol interval is updated
H = zeros(1,M);
for i = 1 : M
    % x is observation signal that is sampeled by L sampels in Ts
    x = y(NoSpTs*(i-1)+1:NoSpTs*i); % update x
%     Mean = mean(x);
%     Q = 1/numel(x)*(x-Mean)'*(x-Mean);
    Q = cov(x');
    % decision making
    if isdiag(Q)==1
        H(i)=0;
    else
        H(i)=1;
    end
end