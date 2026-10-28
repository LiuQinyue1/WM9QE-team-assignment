% 0:clear environment
clc; clear; clf;


% 1: import data
raw_old = double([11; 15; 19; 22; 24; 27; 28; 30; 31; 33; 35; 36; 37; 38; 39; 42; 43; 46; 49; 64]);
raw_new = double([16; 21; 25; 27; 32; 34; 35; 36; 40; 41; 43; 44; 47; 48; 49; 50; 52; 54; 55; 61]);
old = raw_old;
new = raw_new;


% 2:transform array into table and check the value 
T = table(old, new)
T.Properties.VariableDescriptions = ...
    {'old lasts', 'new lasts'};
T.Properties.VariableUnits = {'h', 'h'};

data = T{:, {'old', 'new'}};

% 2.1 missing check
nanCounts = sum(isnan(data), 1);
fprintf('NaN counts: Old=%d, New=%d\n', nanCounts);

% 2.2 invalid check
infCounts = sum(isinf(data), 1);
fprintf('Inf counts: Old=%d, New=%d\n', infCounts);

% 2.3 check repeated rows
varNames = T.Properties.VariableNames;
numVars = width(T);

repeatedCols = false(1, numVars);

% the algorithm transform from bubble sorting
for j = 2:numVars
    for i = 1:j-1
        % Comparison instead of exchange
        if ~repeatedCols(i) && isequaln(T.(varNames{i}), T.(varNames{j}))
            repeatedCols(j) = true;
            fprintf('repeated column: %s (same as %s)\n', varNames{j}, varNames{i});
            break;
        end
    end
end

numRepeateds = sum(repeatedCols);  % Count repeated columns

fprintf('Total repeated columns: %d\n', numRepeateds);

% 2.4 check sorted
oldSorted = issorted(T.old);
newSorted = issorted(T.new);

fprintf('Old sorted ascending: %d\n', oldSorted);
fprintf('New sorted ascending: %d\n', newSorted);


% 3: process with values
% 3.1 repeated processing
if any(repeatedCols)
    T_no_repeated_columns = T(:, ~repeatedCols);

    fprintf('Removed %d repeated columns.\n', ...
        sum(repeatedCols));
else
    T_no_repeated_columns = T;

    fprintf('No repeated columns removed.\n');
end

% 3.2 missing processing
if any(nanCounts > 0)

    % extreme condition, entirely missing
    if any(nanCounts == height(T))
        error('entirely missing, cannot imputation.');
    end

    % use mean to fill the NAN
    T_clean = fillmissing(T, 'mean');
    fprintf('Filled %d missing values.\n', sum(missingCounts));

else
    T_clean = T;
    fprintf('No missing values found.\n');
end

% 3.3 inf processing
if any(isinf(data), 'all')
    error('Inf values detected. Please check the source data.');
end

% 3.4 sorting
if ~oldSorted
    T.old = sort(T.old, 'ascend');
    fprintf('Old has been sorted.\n');
end

if ~newSorted
    T.new = sort(T.new, 'ascend');
    fprintf('New has been sorted.\n');
end


% 4: data features
% 4.1 sample features
nOld = numel(T_clean.old);
nNew = numel(T_clean.new);
total_number = nOld + nNew  % total sample size
valid_old = sum(~ismissing(T_clean.old))  % valid sample size
valid_new = sum(~ismissing(T_clean.new))

% 4.2 basic feature
mean_old = mean(T_clean.old)  % mean
mean_new = mean(T_clean.new)

median_old = median(T_clean.old)  % median
median_new = median(T_clean.new)

mo_old = mode(T_clean.old)  % mode
mo_new = mode(T_clean.new)

% 4.3 discrete features
std_old = std(T_clean.old, 0)  % standard deviation, use n-1 because it's a sample data
std_new = std(T_clean.new, 0)

var_old = var(T_clean.old)  % variance
var_new = var(T_clean.new)

iqr_old = iqr(T_clean.old)  % IQR
iqr_new = iqr(T_clean.new)

range_old = range(T_clean.old)  % range
range_new = range(T_clean.new)

cv_old = std(T_clean.old) / mean(T_clean.old) * 100   % coefficient of variation, in percentage
cv_new = std(T_clean.new) / mean(T_clean.new) * 100

% 4.4 range features
min_old = min(T_clean.old)  % min
min_new = min(T_clean.new)

max_old = max(T_clean.old)  % max
max_new = max(T_clean.new)

Q1_old = prctile(T_clean.old, 25)  % Q1
Q1_new = prctile(T_clean.new, 25)

Q3_old = prctile(T_clean.old, 75)  % Q3
Q3_new = prctile(T_clean.new, 75)


% 5: outlier checking 
% 5.1 outlier checking with IQR
[flagIQROld, lowIQROld, highIQROld] = isoutlier(T_clean.old, 'quartiles');
[flagIQRNew, lowIQRNew, highIQRNew] = isoutlier(T_clean.new, 'quartiles');

disp(T_clean.old(flagIQROld));
disp(T_clean.new(flagIQRNew));  % null

% 5.2 outlier checking with Z-score
zOld = (T_clean.old - mean_old) / std_old
zNew = (T_clean.new - mean_new) / std_new

flagZOld = abs(zOld) > 3;
flagZNew = abs(zNew) > 3;

disp(T_clean.old(flagZOld));  % null, item valued in 64 is equal to 2.45
disp(T_clean.new(flagZNew));  % null

% 5.3 outlier checking with MAD
[flagMADOld, lowMADOld, highMADOld] = isoutlier(T_clean.old, 'median');
[flagMADNew, lowMADNew, highMADNew] = isoutlier(T_clean.new, 'median');

disp(T_clean.old(flagMADOld));  % null
disp(T_clean.new(flagMADNew));  % null


% 6: visualization of separate figures
% 6.1 values comparison
figure('Name', 'Values by Row', 'NumberTitle', 'off');
idx = (1:size(T_clean, 1))';

hold on;
plot(idx, T_clean.old, '-o', 'LineWidth', 1.5, 'MarkerSize', 5);
plot(idx, T_clean.new, '-s', 'LineWidth', 1.5, 'MarkerSize', 5);
hold off;

xlabel('Row Index');
ylabel('Value');
title('Old and New: Values by Row');
legend('Old', 'New', 'Location', 'best');
grid on;
box on;

% 6.2 histogram comparison
figure('Name', 'Distribution Comparison', 'NumberTitle', 'off');
[~, binEdges] = histcounts([T_clean.old; T_clean.new], 'BinWidth', 5);

hold on;
histogram(T_clean.old, binEdges, 'FaceAlpha', 0.5);
histogram(T_clean.new, binEdges, 'FaceAlpha', 0.5);
hold off;

xlabel('Value');
ylabel('Frequency');
title('Distribution Comparison');
legend('Old', 'New', 'Location', 'best');
grid on;
box on;

% 6.3 boxplot comparison
figure('Name', 'Boxplot Comparison', 'NumberTitle', 'off');
boxplot(T_clean{:, :}, 'Labels', {'Old', 'New'});

ylabel('Value');
title('Median, Quartiles and Spread');
grid on;
box on;

% 6.4 summary statistics in the original units
figure('Name', 'Summary Statistics', 'NumberTitle', 'off');

summaryStats = [
    mean_old, mean_new;
    median_old, median_new;
    std_old, std_new;
    iqr_old, iqr_new;
    range_old, range_new
    ];

bar(summaryStats, 'grouped');

xticks(1:5);
xticklabels({'Mean', 'Median', 'Std', 'IQR', 'Range'});
ylabel('Value (original units)');
title('Summary Statistics: Old vs New');
legend('Old', 'New', 'Location', 'best');
grid on;
box on;

% 6.5 percentage change comparison
figure('Name', 'Percentage Change', 'NumberTitle', 'off');

statsOld = [mean_old, median_old, std_old, iqr_old, range_old];
statsNew = [mean_new, median_new, std_new, iqr_new, range_new];

assert(all(statsOld ~= 0), 'Old statistics contain zero values.'); % Avoid division by zero

pctChange = (statsNew - statsOld) ./ statsOld * 100;

b = bar(pctChange, 'FaceColor', 'flat');

colors = zeros(numel(pctChange), 3);
colors(pctChange >= 0, :) = repmat([0 0.4470 0.7410], sum(pctChange >= 0), 1);
colors(pctChange < 0, :) = repmat([0.8500 0.3250 0.0980], sum(pctChange < 0), 1);
b.CData = colors;

xticks(1:5);
xticklabels({'Mean', 'Median', 'Std', 'IQR', 'Range'});
ylabel('Relative Change (%)');
title('Percentage Change: New vs Old');

yline(0, 'k--', 'LineWidth', 1);
ylim([min([pctChange, 0]) - 6, max([pctChange, 0]) + 6]);

for i = 1:numel(pctChange)
    label = sprintf('%+.2f%%', pctChange(i));

    if pctChange(i) >= 0
        text(i, pctChange(i) + 1, label, ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom');
    else
        text(i, pctChange(i) - 1, label, ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'top');
    end
end

grid on;
box on;

% 6.6 summary comparison
figure('Name', 'Summary', 'NumberTitle', 'off');

sum_old = [min_old, Q1_old, median_old, Q3_old, max_old];
sum_new = [min_new, Q1_new, median_new, Q3_new, max_new];

x = 1:5;

hold on;
plot(x, sum_old, '-o', 'LineWidth', 2, 'MarkerSize', 8);
plot(x, sum_new, '-s', 'LineWidth', 2, 'MarkerSize', 8);
hold off;

xticks(1:5);
xticklabels({'Min', 'Q1', 'Median', 'Q3', 'Max'});
xlim([0.8, 5.2]);
ylabel('Value');
title('Summary Comparison');
legend('Old', 'New', 'Location', 'best');
grid on;
box on;

% 6.7 coefficient of variation — separate percentage scale
if all([mean_old, mean_new] > 0)
    cvValues = [std_old, std_new] ./ [mean_old, mean_new] * 100;
    figure('Name', 'Coefficient of Variation', 'NumberTitle', 'off');

    bar(cvValues);
    xticks([1 2]);
    xticklabels({'Old', 'New'});
    ylabel('CV (%)');
    title('Relative Variability');
    grid on;
    box on;

    text(1, cvValues(1), sprintf('%.2f%%', cvValues(1)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom');
    text(2, cvValues(2), sprintf('%.2f%%', cvValues(2)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom');
    ylim([0, max([cvValues, 1]) * 1.2]);

else
    warning('CV plot skipped because a group mean is not positive.');
end

% 6.8 empirical cumulative distribution comparison 
% (非PPT上内容）

[F_old, x_old] = ecdf(T_clean.old);
[F_new, x_new] = ecdf(T_clean.new);

figure('Name', 'ECDF Comparison', 'NumberTitle', 'off');

hold on;
stairs(x_old, F_old, '-',  'LineWidth', 1.8);
stairs(x_new, F_new, '--', 'LineWidth', 1.8);
hold off;

xlabel('h');
ylabel('Cumulative proportion: lifetime <= t');
title('Empirical Cumulative Distribution');
legend('Old', 'New', 'Location', 'best');

ylim([0 1]);
grid on;
box on;

% 6.9 Q-Q plot
figure('Name', 'Normal Q-Q Plots', 'NumberTitle', 'off');

subplot(1,2,1);
qqplot(T_clean.old);
title('Old: Normal Q-Q Plot');
xlabel('Standard Normal Quantiles');
ylabel('Sample Quantiles');
grid on;

subplot(1,2,2);
qqplot(T_clean.new);
title('New: Normal Q-Q Plot');
xlabel('Standard Normal Quantiles');
ylabel('Sample Quantiles');
grid on;

% 7: hypothesis testing
% 7.1 Pearson χ² Normality Test
alpha = 0.05;

% it's not appropriate to use missing-processed data, checking raw data
assert(all(isfinite(T_clean.old(:))) && ...
    all(isfinite(T_clean.new(:))), ...
    'T_clean must contain finite, non-missing observations.');

assert(numel(T_clean.old) >= 20 && numel(T_clean.new) >= 20, ...
    'Each group needs at least 20 observations for this four-bin test.');

assert(std(T_clean.old) > 0 && std(T_clean.new) > 0, ...
    'Each group must have a positive standard deviation.');

% Four equal-probability bins
edgesOld = [-Inf, norminv([0.25 0.50 0.75], mean(T_clean.old), std(T_clean.old)), Inf];
edgesNew = [-Inf, norminv([0.25 0.50 0.75], mean(T_clean.new), std(T_clean.new)), Inf];

[hNormOld, pNormOld, statsOld] = chi2gof(T_clean.old, ...
    'CDF', {@normcdf, mean(T_clean.old), std(T_clean.old)}, ...
    'Edges', edgesOld, ...
    'NParams', 2, ...
    'EMin', 0, ...
    'Alpha', alpha);

[hNormNew, pNormNew, statsNew] = chi2gof(T_clean.new, ...
    'CDF', {@normcdf, mean(T_clean.new), std(T_clean.new)}, ...
    'Edges', edgesNew, ...
    'NParams', 2, ...
    'EMin', 0, ...
    'Alpha', alpha);

fprintf('Old: Chi2 = %.4f, df = %d, h = %d, p = %.4f\n', statsOld.chi2stat, statsOld.df, hNormOld, pNormOld);
fprintf('New: Chi2 = %.4f, df = %d, h = %d, p = %.4f\n', statsNew.chi2stat, statsNew.df, hNormNew, pNormNew);

% 7.2 Confidence interval for the population mean
seOld = std(T_clean.old) / sqrt(numel(T_clean.old));
seNew = std(T_clean.new) / sqrt(numel(T_clean.new));

ciOld = mean(T_clean.old) + [-1 1] * tinv(1-alpha/2, numel(T_clean.old)-1) * seOld;
ciNew = mean(T_clean.new) + [-1 1] * tinv(1-alpha/2, numel(T_clean.new)-1) * seNew;

fprintf('\nOld mean 95%% CI: [%.4f, %.4f]\n', ciOld(1), ciOld(2));
fprintf('New mean 95%% CI: [%.4f, %.4f]\n', ciNew(1), ciNew(2));

% 7.3 Visualization for confidence intervals
figure('Name','Mean and 95% CI','NumberTitle','off');
hold on;

yOld = 2;
yNew = 1;

line(ciOld, [yOld yOld], 'LineWidth', 8);
line(ciNew, [yNew yNew], 'LineWidth', 8);

plot(mean(T_clean.old), yOld, 'o', 'MarkerSize', 18, 'MarkerFaceColor', 'auto');
plot(mean(T_clean.new), yNew, 'o', 'MarkerSize', 18, 'MarkerFaceColor', 'auto');

yticks([yNew yOld]);
yticklabels({'New', 'Old'});

xlabel('Mean lifetime');
title('Group Means with 95% Confidence Intervals');

grid on;
box on;
ylim([0.5 2.5]);
hold off;

% 7.4 Pooled two-sample t-test (equal population variances)
% Assumptions: independent samples, approximately normal populations,
% and equal population variances. Difference direction: New - Old.
% 烛火添加：统一使用 pooled t test 的结果
[hTwo, pTwo, ciTwo, statsTwo] = ttest2( ...
    raw_new, raw_old, ...
    'Vartype', 'equal', 'Tail', 'both', 'Alpha', alpha);

meanDiff = mean(raw_new) - mean(raw_old);
fprintf('Pooled test: mean difference New-Old = %.4f\n', meanDiff);
fprintf('95%% CI = [%.4f, %.4f]\n', ciTwo(1), ciTwo(2));
fprintf('t = %.4f, df = %d, pooled SD = %.4f, p = %.5f, h = %d\n', ...
    statsTwo.tstat, statsTwo.df, statsTwo.sd, pTwo, hTwo);
if hTwo
    fprintf('Evidence of different population means.\n');
else
    fprintf('Insufficient evidence of different population means.\n');
end

% 7.5 Visualization of Two-Sided Pooled t-Test
tObs = statsTwo.tstat;
df = statsTwo.df;

tValues = linspace(-4.5, 4.5, 2000);
pdfValues = tpdf(tValues, df);

tCritBoth = tinv(1-alpha/2, df);

figure('Name', 'Two-Sided Pooled t-Test', 'NumberTitle', 'off');

hold on;

leftIdx = tValues <= -abs(tObs);
rightIdx = tValues >= abs(tObs);

patch([tValues(leftIdx), fliplr(tValues(leftIdx))], ...
    [pdfValues(leftIdx), zeros(1,sum(leftIdx))], ...
    [0.8500 0.3250 0.0980], ...
    'FaceAlpha', 0.4, 'EdgeColor', 'none');

patch([tValues(rightIdx), fliplr(tValues(rightIdx))], ...
    [pdfValues(rightIdx), zeros(1,sum(rightIdx))], ...
    [0.8500 0.3250 0.0980], ...
    'FaceAlpha', 0.4, 'EdgeColor', 'none');

plot(tValues, pdfValues, 'LineWidth', 2, 'Color', [0 0.4470 0.7410]);

xline(-abs(tObs), 'k--');
xline(abs(tObs), 'k--');

xline(-tCritBoth, 'r:');
xline(tCritBoth, 'r:');

xlabel('t Statistic');
ylabel('Probability Density');

title(sprintf('Two-Sided Pooled t-Test (p = %.4f)', pTwo));

grid on;
box on;
hold off;

% 7.6 Right-tailed Pooled two-sample t-test
[hRight, pRight, ciRight, statsRight] = ttest2( ...
    raw_new, raw_old, 'Vartype', 'equal', ...
    'Tail', 'right', 'Alpha', alpha);
fprintf('Right-tailed pooled test: t = %.4f, df = %d, p = %.5f, h = %d\n', ...
    statsRight.tstat, statsRight.df, pRight, hRight);

% 7.7 Visualization of Right-Tailed Pooled t-Test
tCritRight = tinv(1-alpha, df);

figure('Name', 'Right-Tailed Pooled t-Test', 'NumberTitle', 'off');
hold on;

rightIdx = tValues >= tObs;

patch([tValues(rightIdx), fliplr(tValues(rightIdx))], ...
    [pdfValues(rightIdx), zeros(1,sum(rightIdx))], ...
    [0.8500 0.3250 0.0980], ...
    'FaceAlpha', 0.4, 'EdgeColor', 'none');

plot(tValues, pdfValues, ...
    'LineWidth', 2, 'Color', [0 0.4470 0.7410]);

xline(tObs, 'k--', 'Observed t');
xline(tCritRight, 'r:', 'Critical t');

xlabel('t Statistic');
ylabel('Probability Density');

title(sprintf('Right-Tailed Pooled t-Test (p = %.4f)', pRight));

grid on;
box on;
hold off;

% 7.8 Two-sample F-test for variances
[hVar, pVar, ciVarRatio, stVar] = vartest2( ...
    T_clean.new, T_clean.old, ...
    'Tail', 'both', 'Alpha', alpha);

fprintf('Variance ratio New/Old = %.4f\n', var(T_clean.new,0) / var(T_clean.old,0));
fprintf('F = %.4f, p = %.4f\n', stVar.fstat, pVar);
fprintf('95%% CI for variance ratio = [%.4f, %.4f]\n', ciVarRatio(1), ciVarRatio(2));

if hVar
    fprintf('Evidence of different population variances.\n');
else
    fprintf('Insufficient evidence of different population variances.\n');
end

% 7.9 visualization of Two-Sample F-Test
% Calculate critical F values
fCritLower = finv(alpha/2, stVar.df1, stVar.df2);
fCritUpper = finv(1-alpha/2, stVar.df1, stVar.df2);

fMax = max([finv(0.999, stVar.df1, stVar.df2), ...  % Generate F-distribution curve
    1.2*stVar.fstat, 1.1*fCritUpper]);

fValues = linspace(0, fMax, 3000);
pdfValues = fpdf(fValues, stVar.df1, stVar.df2);

figure('Name', 'Two-Sample F-Test', ...
    'NumberTitle', 'off');

hold on;

% Left rejection region
leftIdx = fValues <= fCritLower;

hLeft = patch( ...
    [fValues(leftIdx), fliplr(fValues(leftIdx))], ...
    [pdfValues(leftIdx), zeros(1, sum(leftIdx))], ...
    [0.8500 0.3250 0.0980], ...
    'FaceAlpha', 0.4, ...
    'EdgeColor', 'none');

% Right rejection region
rightIdx = fValues >= fCritUpper;

patch( ...
    [fValues(rightIdx), fliplr(fValues(rightIdx))], ...
    [pdfValues(rightIdx), zeros(1, sum(rightIdx))], ...
    [0.8500 0.3250 0.0980], ...
    'FaceAlpha', 0.4, ...
    'EdgeColor', 'none');

% F probability density
hPDF = plot(fValues, pdfValues, ...
    'LineWidth', 2, ...
    'Color', [0 0.4470 0.7410]);

% Observed F statistic
xline(stVar.fstat, 'k--', 'Observed F', 'LineWidth', 1.5);

% Critical F values
xline(fCritLower, 'r:', 'Lower Critical');
xline(fCritUpper, 'r:', 'Upper Critical');

xlabel('F Statistic (New Variance / Old Variance)');
ylabel('Probability Density');

title(sprintf('Two-Sided F-Test (p = %.4f)', pVar));

legend([hPDF, hLeft], ...
    {'F Distribution', 'Rejection Regions'}, ...
    'Location', 'northeast');

xlim([0 fMax]);

grid on;
box on;
hold off;

% 7.10 Visualization for Variance Ratio 95% CI

figure('Name', 'Variance Ratio Confidence Interval', ...
    'NumberTitle', 'off');

hold on;

% Confidence interval
plot([ciVarRatio(1), ciVarRatio(2)], [1, 1], ...
    '-', 'LineWidth', 5, 'Color', [0 0.4470 0.7410]);

% CI endpoints
plot(ciVarRatio, [1, 1], '|', 'MarkerSize', 16, ...
    'LineWidth', 2, 'Color', [0 0.4470 0.7410]);

% Observed variance ratio
plot(stVar.fstat, 1, 'o', 'MarkerSize', 12, ...
    'MarkerFaceColor', [0 0.4470 0.7410], ...
    'MarkerEdgeColor', [0 0.4470 0.7410]);

hold off;

% Equal variance reference
xline(1, 'r--', 'Equal Variances (Ratio = 1)');
yticks(1);
yticklabels({'New / Old'});
ylim([0.75, 1.25]);

xlim([0, max([ciVarRatio(:); 1; stVar.fstat]) * 1.15]);

xlabel('Population Variance Ratio');
title(sprintf('Variance Ratio: %.3f (95%% CI: %.3f to %.3f)', ...
    stVar.fstat, ciVarRatio(1), ciVarRatio(2)));

grid on;
box on;


% 8: binomial distribution
% 8.1 binomial distribution
threshold = 40;  % just an example
successOld = sum(T_clean.old >= threshold);
successNew = sum(T_clean.new >= threshold);

pOld = successOld / nOld;
pNew = successNew / nNew;

fprintf('Old: %d/%d = %.2f%%\n', successOld, nOld, pOld * 100);
fprintf('New: %d/%d = %.2f%%\n', successNew, nNew, pNew * 100);

contingencyTable = [
    successNew, nNew - successNew;
    successOld, nOld - successOld
    ];

[hFisher, pFisher] = fishertest( ...
    contingencyTable, ...
    'Tail', 'right', ...
    'Alpha', alpha);

fprintf('Fisher exact test: h = %d, p = %.4f\n', hFisher, pFisher);

% 8.2 visualization for binomial distribution
k = 0:20;
probOld = binopdf(k, nOld, pOld);
probNew = binopdf(k, nNew, pNew);

figure('Name', 'Binomial Distribution', ...
    'NumberTitle', 'off');

bar(k, [probOld(:), probNew(:)], 'grouped');

xlabel('Number of Successful Resistors (k)');
ylabel('Probability P(K = k)');
title('Estimated Binomial Distributions');

legend('Old', 'New', 'Location', 'best');
xticks(0:2:20);

grid on;
box on;

% 8.3 ci for binomial distribution
[pBinOld, ciBinOld] = binofit(successOld, nOld, alpha);
[pBinNew, ciBinNew] = binofit(successNew, nNew, alpha);

fprintf('Old survival: %.2f%%, 95%% CI [%.2f%%, %.2f%%]\n', ...
    pBinOld*100, ciBinOld(1)*100, ciBinOld(2)*100);
fprintf('New survival: %.2f%%, 95%% CI [%.2f%%, %.2f%%]\n', ...
    pBinNew*100, ciBinNew(1)*100, ciBinNew(2)*100);

% 8.4 visualization for ci of binomial distribution
figure('Name', 'Survival Probability 95% CI', 'NumberTitle', 'off');

pBinValues = [pBinOld; pBinNew] * 100;
ciBinValues = [ciBinOld; ciBinNew] * 100;

lowerError = pBinValues - ciBinValues(:,1);  % Error lengths
upperError = ciBinValues(:,2) - pBinValues;

% Draw bars
hold on;

b = bar(1:2, pBinValues, 0.55, 'FaceColor', 'flat');
b.CData = [
    0    0.4470 0.7410;
    0.8500 0.3250 0.0980
    ];

% Draw asymmetric 95% confidence intervals
errorbar(1:2, pBinValues, lowerError, upperError, ...
    'k.', 'LineWidth', 1.8, 'CapSize', 12);

hold off;

xticks(1:2);
xticklabels({'Old', 'New'});

ylabel('Survival Probability (%)');
title('Survival Probability with 95% CI');

ylim([0 100]);
grid on;
box on;


% 9: normality and homogeneity
% 9.1 Brown–Forsythe test (课件上没有）
[pBF, stBF] = vartestn( ...
    T_clean{:, {'old','new'}}, ...
    'TestType', 'BrownForsythe', ...
    'Display', 'off');

fprintf('Brown-Forsythe: F = %.4f, p = %.4f\n', ...
    stBF.fstat, pBF);

if pBF < alpha
    fprintf('Evidence of unequal variances.\n');
else
    fprintf('Insufficient evidence of unequal variances.\n');
end

% 9.2 Levene test
[pLevene, stLevene] = vartestn( ...
    T_clean{:, {'old','new'}}, ...
    'TestType', 'LeveneAbsolute', ...
    'Display', 'off');

fprintf('Levene: F = %.4f, p = %.4f\n', ...
    stLevene.fstat, pLevene);

% 9.3 One-way ANOVA
[pAnova, anovaTable, stAnova] = anova1( ...
    T_clean{:, {'old','new'}}, ...
    {'Old','New'}, 'off');

disp(anovaTable);

fprintf('One-way ANOVA: F = %.4f, p = %.4f\n', anovaTable{2,5}, pAnova);

if pAnova < alpha
    fprintf('Evidence of different population means.\n');
else
    fprintf('Insufficient evidence of different population means.\n');
end

% 9.4    (rank-sum, 课件上没有)
[pRank, hRank, stRank] = ranksum( ...
    T_clean.new, T_clean.old, ...
    'Tail', 'both', 'Alpha', alpha, ...
    'Method', 'approximate');

fprintf('Rank-sum: z = %.4f, p = %.4f\n', stRank.zval, pRank);


% 10: sensitivity analysis using the pooled two-sample t-test
[~, pFull, ciFull] = ttest2( ...
    raw_new, raw_old, ...
    'Vartype', 'equal', ...
    'Tail', 'both', ...
    'Alpha', alpha);

idx64 = find(raw_old == 64, 1);

if ~isempty(idx64)
    oldSensitivity = raw_old;
    oldSensitivity(idx64) = [];

    [~, pSensitivity, ciSensitivity] = ttest2( ...
        raw_new, oldSensitivity, ...
        'Vartype', 'equal', ...
        'Tail', 'both', ...
        'Alpha', alpha);

    sensitivityTable = table( ...
        {'All observations'; 'Temporarily omit old 64'}, ...
        [numel(raw_old); numel(oldSensitivity)], ...
        [mean(raw_new)-mean(raw_old); ...
        mean(raw_new)-mean(oldSensitivity)], ...
        [ciFull(1); ciSensitivity(1)], ...
        [ciFull(2); ciSensitivity(2)], ...
        [pFull; pSensitivity], ...
        'VariableNames', ...
        {'Analysis','OldN','MeanDifference', ...
        'CILower','CIUpper','PValue'});

    disp(sensitivityTable);

else
    fprintf('Old value 64 was not found; sensitivity analysis skipped.\n');
end
