

%% Functions
function reject_h0 = h0_test_nonparametric(test_stat, null_dist, percentile)
% H0_TEST_NONPARAMETRIC Performs a nonparametric hypothesis test to determine whether to reject the null hypothesis.
%
% This function tests if a given test statistic significantly exceeds a specified percentile 
% of a null distribution. It is used for hypothesis testing in cases where standard parametric 
% tests are not suitable. The function sorts the combined array of the test statistic and the 
% null distribution, then determines if the test statistic is beyond the specified percentile 
% threshold of the null distribution.
%
% Usage:
%   reject_h0 = h0_test(test_stat, null_dist, percentile, simIter)
%
% Inputs:
%   test_stat - The test statistic to be compared against the null distribution.
%   null_dist - An array representing the null distribution against which the test statistic is compared.
%   percentile - The percentile (expressed as a value between 0 and 1) against which the test 
%                statistic is compared (e.g., 0.95 for the 95th percentile).
%
% Output:
%   reject_h0 - A logical value (true or false) indicating whether to reject the null hypothesis.
%               True indicates rejection of the null hypothesis. In case of an error (e.g., 
%               test_stat not found in the sorted array), NaN is returned.
%
% Example:
%   testStat = 2.5;
%   nullDistribution = normrnd(0, 1, [1000, 1]);
%   percentile = 0.95;
%   simIter = 1;
%   shouldReject = h0_test(testStat, nullDistribution, percentile, simIter);

% Sort the combined array of test statistic and null distribution in ascending order
sorted = sort([test_stat, null_dist'], 'ascend');

% Get the number of elements in the null distribution
size_null = numel(null_dist);

% Check if the test statistic exceeds the specified percentile of the null distribution

% Determine if the position of the test statistic is greater than the Nth percentile
try
    reject_h0 = find(sorted == test_stat, 1) > ceil(size_null * percentile);
    if isempty(reject_h0)
        reject_h0 = NaN;
    end
catch
    % In case of an error (e.g., test_stat not found in sorted array), return NaN
    reject_h0 = NaN;
end

end
    
