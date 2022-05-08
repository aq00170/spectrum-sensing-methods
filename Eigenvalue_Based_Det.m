function H=Eigenvalue_Based_Det(M,y,L,threshold,Mode,NoSpTs)
%% H=Eigenvalue_Based_Det(M,y,threshold,Mode)
% is Eigenvalue Based Detection
% M is Number of symbol intervals that we want to be sensed
% y is signal that recieved at SU
% L is number of symbols that we want to be sence
% threshold is an scalar
%
% Mode is mode of operation variable
% (1)   Max-Min eigenvalue detection in which the test statistic is defined
%       as ratio of Max and Min eigenvalue of covariance matrix
% (2)   Energy with min eigenvalue in which the test statistics is defined
%       as ratio of average power of received signal to min eigenvalue.
% (3)   Max eigenvalue detection in which test statistics is given by the
%       maximum eigenvalue.
%
% H is present-absent vector, 1-> SU is present
%                           , 0-> SU is absent
% code is written by Alireza Qazavi
% Email: a.qazavi@ec.iut.ac.ir
x = []; % observation vector that in each symbol interval is updated
H = zeros(1,M);
    for i = 1 : M
        % x is observation signal that is sampeled by L sampels in Ts
        x=y(NoSpTs*(i-1)+1:NoSpTs*i); % update x
    %     Mean = mean(x);
    %     Q = 1/numel(x)*(x-Mean)'*(x-Mean);
        Q = cov(x);
        eigen_values=eig(Q);
        % decision making
        switch Mode
            case 1  %Max-Min eigenvalue detection
                if max(eigen_values)/min(eigen_values) > threshold
                    H(i)=1;else; H(i)=0;end
            case 2  %Energy with min eigenvalue 
                E_of_x = sum(x.^2); %compute energy of x
                % average power of received signal
                AP_of_x = E_of_x/(L*NoSpTs);
                if AP_of_x/min(eigen_values) > threshold
                    H(i)=1;else; H(i)=0;end
            case 3  %Max eigenvalue detection
                if max(eigen_values) > threshold
                    H(i)=1;else; H(i)=0;end
            otherwise
            error('ErrorTests:convertTest',...
                'Error using Mode\nlast Input argument of Eigenvalue_Based_Det must be 1 or 2 or 3.');
        end
    end
end