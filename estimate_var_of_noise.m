function var = estimate_var_of_noise(x)
% estimate variance of noise from observation vec(x).
N = numel(x);
var = 1/(N-1)*sum((x-mean(x)).^2,'all')-0.5;
end