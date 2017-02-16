function AutomaticPeakDetection(Y, X)
% X is feature vector N x D where D is the number of features
% Y is column vector
% Assume 1D
w = fitLine(Y, X);

Y_d = Y - X * w;

% figure
% plot(Y, 'b');
% hold on
% plot(Y_detrended, 'r');

N = numel(Y);
L = ceil(N / 2) - 1;
k = 1:L;
alpha = 1;
M = zeros(L, N);

%compute LMS
for w_k = 1:numel(k)
    for i = w_k + 2:1:N - w_k + 1
        if (Y_d(i - 1) > Y_d(i - w_k - 1) && Y_d(i - 1) > Y_d(i + w_k - 1))
            M(w_k, i) = 0;
        else
           M(w_k, i) = alpha + rand(1);
        end
    end
end

gamma = sum(M, 2); %row-wise summation of LMS
lambda = min(gamma); %global minimum corresponding to max

M_r = M(k' <= lambda, :);
avg_Mr =  (1 / lambda) * sum(M_r, 1);
M_r = sqrt((M_r - avg_Mr).^2);

sigma = (1 / (lambda - 1)) * sum(M_r, 1);

idx = 1:N;
peak_idx = idx(sigma == 0);
peak_amp = Y(peak_idx);
% window for ppg data
% window = 30;
% curr_idx = 1;
% for i = 2:numel(peak_idx)
%     if (peak_idx(i) - peak_idx(curr_idx) < window)
%         if (peak_amp(curr_idx) < peak_amp(i))
%             peak_idx(curr_idx) = 0;
%             curr_idx = i;
%         else
%             peak_idx(i) = 0;
%         end
%     else
%         curr_idx = i;
%     end
% end
    
% peak_idx = peak_idx(peak_idx > 0);    
% peak_amp = Y(peak_idx);


figure
plot(Y, 'r');
hold on
plot(peak_idx, peak_amp, '*b');








