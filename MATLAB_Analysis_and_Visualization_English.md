Analysis objective: Describe the lifetime distributions of the old and new components and compare their mean lifetimes.
Unit of observation: Each value represents the lifetime of one component, measured in hours. The old and new components form two groups analyzed as independent samples. Values in the same row do not represent paired observations.

0. Clear the environment
clc clears the Command Window; clear removes workspace variables; clf clears the contents of the current figure.
Reference sources: [WM9QE] Seminar - MATLAB Programming-c

1. Import the data
Create raw_old and raw_new to preserve the original lifetime data, then assign them to old and new. Use double(...) to explicitly specify the numeric data type.
Reference sources: [WM9QE] Seminar - MATLAB Programming-c

2. Data quality checks
2.0 Use table to organize the two groups, set variable descriptions and the unit h, and extract the numeric matrix data for checks by column.
Reference sources: [WM9QE] Seminar - MATLAB Programming-c
2.1 Use isnan and sum to count missing values. Both groups have 0 missing values.
Reference sources: [WM9QE] Seminar - MATLAB Programming-c
2.2 Use isinf to detect Inf and -Inf. Both groups have 0 infinite values.
2.3 Use nested loops and isequaln to compare entire columns and identify duplicate columns, making the data checks more complete. The number of duplicate columns is 0.
2.4 Use issorted to check whether the observations are in ascending order. Both groups are already sorted in ascending order.

3. Data processing
3.1 Create a new table with duplicate columns removed according to the duplicate-column flags.
3.2 Stop the analysis if an entire column is missing. Use mean imputation for partially missing columns and create T_clean.
Reference sources: [WM9QE] Seminar - MATLAB Programming-c; WM9QE Descriptive Statistics
3.3 Use error to stop the analysis if Inf is detected and check the data source.
3.4 Use sort to arrange the observations in ascending order, allowing lifetimes at corresponding sorted ranks to be compared.

4. Descriptive statistics
4.1 Use numel to determine nOld and nNew, and count nonmissing observations. There are 20 observations in the old group and 20 in the new group, giving 40 observations in total.
Reference sources: [WM9QE] Seminar - MATLAB Programming-c
4.2 Use mean, median, and mode to summarize the average level, central position, and most frequently occurring values.
Reference sources: WM9QE Descriptive Statistics; [WM9QE] Seminar - MATLAB Programming-c
4.3 Use std(...,0) and var to calculate the sample standard deviation and sample variance, measuring dispersion around the mean. Use iqr and range to measure the spread of the middle 50% of the data and the full sample span. Calculate the coefficient of variation, CV, to compare relative variability.
Reference sources: WM9QE Descriptive Statistics
4.4 Use min, max, and prctile to calculate the minimum, maximum, Q1, and Q3. These describe the sample endpoints and quartile positions and provide the basis for the boxplot and five-number summary.
Reference sources: WM9QE Descriptive Statistics; [WM9QE] Seminar - MATLAB Programming-c

5. Outlier detection

5.1 Interquartile range method
Use the quartiles method in isoutlier to identify observations outside the interquartile-range bounds.
The old group has a lower bound of 3 and an upper bound of 63. Its 20th observation, 64, is flagged. The new group has bounds of 8.25 and 74.25, with no observations flagged.
The old-group value of 64 exceeds the upper bound by 1 and the second-largest value, 49, by 15, making it a relatively isolated observation in the upper tail.
Reference sources: WM9QE Descriptive Statistics; WM9QE Week2 Normality Hypothesis Parametric Tests; Supplementary material

5.2 Z-score method
Flag observations with an absolute Z-score greater than 3 to assess their distance from the mean.
The corresponding lifetime bounds are approximately -3.82 to 70.72 hours for the old group and 4.13 to 76.87 hours for the new group. Neither group has any flagged observations.
The old-group value of 64 has a Z-score of approximately 2.46. The largest absolute Z-score in the new group is approximately 2.02. Neither exceeds 3.
Reference sources: WM9QE Descriptive Statistics

5.3 Median absolute deviation method
Use the median method in isoutlier, with the median and 3 times the scaled median absolute deviation (MAD) defining the bounds. This reduces the influence of extreme observations on estimates of center and scale.
The old group has a raw MAD of 7.5 and a scaled MAD of approximately 11.12, giving bounds of approximately 0.64 to 67.36 hours. The new group has a raw MAD of 8 and a scaled MAD of approximately 11.86, giving bounds of approximately 6.42 to 77.58 hours. Neither group has any flagged observations.
The value 64 is flagged only by the interquartile range method and remains within the Z-score and MAD bounds. Its outlier classification therefore depends on the detection rule.
Reference sources: [WM9QE] Seminar - MATLAB Programming-c; Supplementary material

6. Visualizations and interpretation

6.1 Sorted-value comparison plot
Compare the two groups directly at corresponding ascending ranks.
The mean lifetime is 33.45 hours for the old group and 40.50 hours for the new group, an increase of 7.05 hours, or approximately 21.1%. The median increases from 34 to 42 hours, a difference of 8 hours, indicating a higher central position in the new sample.
The new group is higher at the first 19 sorted ranks, with differences ranging from 5 to 10 hours. The largest difference, 10 hours, occurs at ranks 13, 14, and 15. At rank 20, the old-group value is 64 and the new-group value is 61, making the new group lower by 3 hours.
The new group has higher values at most ranks, with higher lifetimes across the lower, middle, and most of the upper positions.
Reference sources: [WM9QE] Seminar - MATLAB Programming-c

6.2 Histograms
Use common bin edges and a bin width of 5 hours to compare the lifetime distributions.
The most frequent old-group interval is [35, 40), containing 5 observations, or 25%. The most frequent new-group interval is [40, 45), containing 4 observations, or 20%. The modal interval shifts toward a higher lifetime.
The interval [40, 55) contains 4 old-group observations, or 20%, and 10 new-group observations, or 50%. The new group's sample proportion in this higher-lifetime interval is 30 percentage points greater.
There are 7 old-group observations below 30 hours, or 35%, compared with 4 new-group observations, or 20%. The new group has a smaller proportion of shorter lifetimes and a larger proportion of higher lifetimes.
Reference sources: [WM9QE] Seminar - MATLAB Programming-c; WM9QE Week2 Normality Hypothesis Parametric Tests

6.3 Boxplots
The box extends from Q1 to Q3 and represents the middle 50% of the data. Outlier bounds are determined using 1.5 times the interquartile range. Observations below the lower bound or above the upper bound are flagged as potential outliers.
The old-group box extends from 25.5 to 40.5 hours, with a median of 34 hours. The new-group box extends from 33 to 49.5 hours, with a median of 42 hours. The new median is 8 hours higher and the entire box is positioned higher. The interquartile range increases from 15 to 16.5 hours, widening the middle 50% by 1.5 hours.
The old-group outlier bounds are 3 and 63. The 20th observation, 64, exceeds the upper bound by 1 and is the only upper-tail potential outlier shown. The upper whisker is 49, leaving a gap of 15 hours to the value 64 and separating this long-lifetime observation from the other high values.
The other 19 old-group observations have a mean of 31.84, a standard deviation of 10.41, and a range of 38 hours. When 64 is included, these become 33.45, 12.42, and 53 hours. This observation raises the old-group mean and increases its standard deviation and range.
The new-group bounds are 8.25 and 74.25. All observations, from 16 to 61 hours, fall within these bounds, so no potential outliers are shown.
Reference sources: [WM9QE] Seminar - MATLAB Programming-c; WM9QE Descriptive Statistics

6.4 Bar chart of descriptive statistics
Compare the mean, median, standard deviation, interquartile range, and range side by side.
The mean increases from 33.45 to 40.50 hours and the median from 34 to 42 hours, indicating a higher average level and central position in the new group.
The standard deviation decreases from 12.4244 to 12.1244 hours, a reduction of approximately 0.30 hours, or 2.41%. Absolute dispersion is similar in the two groups.
The interquartile range increases from 15 to 16.5 hours, or 10%, indicating slightly greater dispersion within the middle 50% of the new group. The range decreases from 53 to 45 hours, a reduction of 8 hours, indicating a smaller overall span between the sample endpoints.
Reference sources: [WM9QE] Seminar - MATLAB Programming-c

6.5 Percentage-change bar chart
Use the old group as the baseline to compare relative changes in the new group's statistics. Display positive and negative changes in different colors.
The mean increases by 21.08%, the median by 23.53%, and the interquartile range by 10.00%. The standard deviation decreases by 2.41% and the range by 15.09%.
The central position increases substantially, while the absolute standard deviation changes little. The middle 50% becomes more spread out, whereas the full sample span becomes smaller.
Reference sources: [WM9QE] Seminar - MATLAB Programming-c; Supplementary material

6.6 Five-number summary comparison plot
Compare the minimum, Q1, median, Q3, and maximum.
The minimum increases from 11 to 16, a difference of 5 hours; Q1 increases from 25.5 to 33, a difference of 7.5 hours; the median increases from 34 to 42, a difference of 8 hours; and Q3 increases from 40.5 to 49.5, a difference of 9 hours. The new group has higher lower-end and central positions.
The maximum decreases from 64 to 61 hours, a difference of 3 hours. The old group has a higher single extreme observation, but the new group is higher at the other four summary positions. Its lifetime advantage is mainly reflected in the lower and middle parts of the sample distribution.
Reference sources: WM9QE Descriptive Statistics; [WM9QE] Seminar - MATLAB Programming-c

6.7 Coefficient-of-variation bar chart
Use a percentage axis to compare the standard deviation relative to the mean.
The coefficient of variation is 37.14% for the old group and 29.94% for the new group, a reduction of approximately 7.21 percentage points, or 19.4% relative to the old group.
The new mean is approximately 21.1% higher, while the standard deviation is only approximately 2.41% lower. The reduction in CV therefore also reflects the higher mean lifetime. The new group has less variability relative to its own mean lifetime.
Reference sources: WM9QE Descriptive Statistics; [WM9QE] Seminar - MATLAB Programming-c

6.8 Empirical cumulative distribution plot
Use ecdf and stairs to display the sample proportion with lifetimes at or below a given time.
At or below 30 hours, the proportions are 40% for the old group and 20% for the new group. At or below 40 hours, they are 75% and 45%; at or below 50 hours, they are 95% and 80%.
At 39 hours, the cumulative proportions are 75% and 40%, a difference of 35 percentage points. The new-group curve is lower over most intervals, indicating a smaller proportion of shorter-lifetime observations.
At 61 hours, the new-group cumulative proportion reaches 100%, while the old group remains at 95%. The old group reaches 100% only at 64 hours, reflecting its higher extreme observation.
Reference sources: Supplementary material

6.9 Normal Q-Q plots
Use qqplot to compare sample quantiles with normal quantiles and assess how closely the points follow the reference line.
Most old-group observations lie close to the reference line. The maximum, 64 hours, lies at the upper-right end and clearly above the reference line, indicating an upper-tail departure.
The middle observations in the new group lie relatively close to the reference line. The values 16 and 61 hours lie at the lower and upper ends, respectively, with the higher observations slightly below the extended reference line.
Reference sources: WM9QE Week2 Normality Hypothesis Parametric Tests; Supplementary material

7. Hypothesis tests and confidence intervals

The significance level is 0.05. μ denotes population mean lifetime, and σ² denotes population variance.

7.1 Normality tests
Use the Lilliefors test to assess whether the lifetimes in each group deviate significantly from a normal distribution.
H0: The lifetimes in the group being tested follow a normal distribution.
H1: The lifetimes in the group being tested do not follow a normal distribution.
The old group has p = 0.9840, and the new group has p = 0.8298. Both values exceed 0.05; do not reject H0 for either group.
Interpretation: No statistically significant departure from normality is detected, but this does not prove that the population follows a normal distribution.
Reference sources: WM9QE Week2 Normality Hypothesis Parametric Tests; Supplementary material

7.2 95% confidence intervals for the means
Use the sample standard deviation, standard error, and t-distribution quantiles to estimate an interval for each group's population mean lifetime.
The old group has a mean lifetime of 33.45 hours and a 95% confidence interval of 27.64 to 39.26 hours.
The new group has a mean lifetime of 40.50 hours and a 95% confidence interval of 34.83 to 46.17 hours.
Interpretation: The new group has a higher point estimate of the mean. Each interval reflects the uncertainty in estimating the corresponding population mean.
Reference sources: WM9QE Week2 Normality Hypothesis Parametric Tests

7.3 Plot of means and confidence intervals
The circles represent the means, and the horizontal line segments represent the corresponding 95% confidence intervals.
The new group's circle lies to the right of the old group's circle, with a mean that is 7.05 hours higher. The intervals overlap from approximately 34.83 to 39.26 hours.
Interpretation: The plot shows a higher central location for the new group, together with estimation uncertainty. The difference between the group means should be assessed using the test and confidence interval for the mean difference.
Reference sources: WM9QE Week2 Normality Hypothesis Parametric Tests; [WM9QE] Seminar - MATLAB Programming-c; Supplementary material

7.4 Two-sided pooled t-test
Test whether the population mean lifetimes of the two groups differ, assuming equal population variances.
H0: The two groups have equal population mean lifetimes, μ_new = μ_old.
H1: The two groups have different population mean lifetimes, μ_new ≠ μ_old.
The mean difference, new group minus old group, is 7.05 hours, with t = 1.8162, 38 degrees of freedom, and a two-sided p-value of 0.0772.
The 95% confidence interval for the mean difference is -0.8083 to 14.9083 hours.
Because p exceeds 0.05 and the confidence interval for the difference includes 0, do not reject H0.
Interpretation: The available data are insufficient to conclude at the 5% significance level that the two population mean lifetimes differ.
Reference sources: WM9QE Week2 Normality Hypothesis Parametric Tests; Supplementary material

7.5 Two-sided pooled t-test plot
The shaded areas represent the tail probabilities to the left of -1.8162 and to the right of 1.8162. Together, they give the two-sided p-value of 0.0772.
The critical values for the 5% two-sided test are approximately -2.0244 and 2.0244. The observed t = 1.8162 lies between them.
Interpretation: The observed statistic does not enter the rejection region, consistent with the decision not to reject H0 in the two-sided test.
Reference sources: WM9QE Week2 Normality Hypothesis Parametric Tests; [WM9QE] Seminar - MATLAB Programming-c; Supplementary material

7.6 Right-tailed pooled t-test
Test whether the new group has a higher population mean lifetime than the old group.
H0: The new group's population mean lifetime is no higher than the old group's, μ_new ≤ μ_old.
H1: The new group's population mean lifetime is higher than the old group's, μ_new > μ_old.
The observed t = 1.8162, and the right-tailed p-value is 0.0386. Because this is below 0.05, reject H0.
Interpretation: If this one-sided hypothesis was specified in advance, the result supports a higher population mean lifetime for the new group.
Reference sources: WM9QE Week2 Normality Hypothesis Parametric Tests; Supplementary material

7.7 Right-tailed pooled t-test plot
The shaded area to the right of the observed t = 1.8162 represents the right-tailed p-value, approximately 0.0386.
The critical value for the 5% right-tailed test is approximately 1.6860. The observed t = 1.8162 exceeds this value and falls in the right-tail rejection region.
Interpretation: The plot is consistent with the right-tailed test's rejection of H0 and support for a higher population mean lifetime for the new group.
Reference sources: WM9QE Week2 Normality Hypothesis Parametric Tests; [WM9QE] Seminar - MATLAB Programming-c; Supplementary material

7.8 Two-sample F-test for variances
Test whether the population variances of the new and old groups differ.
H0: The two groups have equal population variances, σ²_new = σ²_old.
H1: The two groups have different population variances, σ²_new ≠ σ²_old.
The old group's sample variance is 154.3658, and the new group's is 147.0000. The new-to-old variance ratio is F = 0.9523, with a two-sided p-value of 0.9162.
Because p exceeds 0.05, do not reject H0.
Interpretation: There is insufficient evidence that the population variances differ, but this does not prove that they are exactly equal.
Reference sources: WM9QE Week2 Normality Hypothesis Parametric Tests; Supplementary material

7.9 F-test plot for variances
The shaded areas at both ends represent the rejection regions for the 5% two-sided test. The lower critical value is approximately 0.3958, and the upper critical value is approximately 2.5265.
The observed F = 0.9523 lies between these critical values and does not enter either rejection region.
Interpretation: The plot is consistent with the variance test's decision not to reject H0. Here, the shaded areas represent rejection regions; in 7.5 and 7.7, they represent the tail probabilities corresponding to the p-values.
Reference sources: WM9QE Week2 Normality Hypothesis Parametric Tests; [WM9QE] Seminar - MATLAB Programming-c; Supplementary material

7.10 Variance ratio confidence interval plot
The plot shows the point estimate of the new-to-old population variance ratio, 0.9523, and its 95% confidence interval, 0.3769 to 2.4059. The reference line at 1 represents equal population variances.
Interpretation: The interval includes 1, consistent with the F-test's decision not to reject H0. The relatively wide interval indicates substantial uncertainty in estimating the population variance ratio.
Reference sources: WM9QE Week2 Normality Hypothesis Parametric Tests; [WM9QE] Seminar - MATLAB Programming-c; Supplementary material

Relationships between the test results

The normality tests concern distribution shape, the variance tests concern dispersion, and the mean tests concern mean lifetime. The normality and variance tests do not reject H0, but this does not imply equal population mean lifetimes.

The two-sided and right-tailed pooled t-tests have different alternative hypotheses and critical values. The observed t = 1.8162 exceeds the right-tailed critical value of 1.6860 but does not exceed the positive two-sided critical value of 2.0244. Therefore, the right-tailed test rejects H0, while the two-sided test does not reject H0. The test direction should be specified in advance and should not be changed to one-sided based on the two-sided result.

The new group's sample mean lifetime is 7.05 hours higher, an increase of approximately 21.1%. Under the prespecified right-tailed hypothesis, the result reaches the 5% significance level; the two-sided comparison does not reach this level.

8. Threshold proportions and the binomial distribution

8.1 Threshold proportions and Fisher's exact test
Use 40 hours as an example threshold, define a lifetime of at least 40 hours as a success, and count successes and failures in each group.
The old group has 5 successes and 15 failures, with a success proportion of 25%; the new group has 12 successes and 8 failures, with a success proportion of 60%. The new group's proportion is 35 percentage points higher and 2.4 times the old group's proportion.
The right-tailed Fisher's exact test compares the success proportions, yielding p = 0.0268, which is below 0.05. Under this example threshold and the one-sided hypothesis, the result supports a higher success proportion in the new group.
Reference sources: WM9QE_Discrete Distribution; Supplementary material

8.2 Binomial distribution plot
Use the 20 observations in each group and the sample success proportions to fit binomial distributions with success probabilities of 0.25 for the old group and 0.60 for the new group, showing the model probabilities of different numbers of successes among 20 components.
The old group's expected number of successes is 5 components, and its probability peaks at 5 components, with a peak probability of approximately 20.23%; the new group's expected number is 12 components, and its probability peaks at 12 components, with a peak probability of approximately 17.97%.
The new group's distribution peaks at a larger number of successes, reflecting a higher probability of meeting the threshold under the estimated model.
Reference sources: WM9QE_Discrete Distribution; [WM9QE] Seminar - MATLAB Programming-c

8.3 95% confidence intervals for success probabilities
Use the Clopper-Pearson method in binofit to estimate the population proportion with a lifetime of at least 40 hours.
The old group's point estimate is 25%, with a 95% confidence interval of 8.66% to 49.10%; the new group's point estimate is 60%, with an interval of 36.05% to 80.88%.
The new group's point estimate is 35 percentage points higher. Both intervals are relatively wide, reflecting the uncertainty in proportion estimates based on 20 observations per group.
Reference sources: WM9QE_Discrete Distribution; Supplementary material

8.4 Success probability confidence interval plot
The bars show 25% for the old group and 60% for the new group, with asymmetric error bars spanning 8.66% to 49.10% and 36.05% to 80.88%, respectively.
The new group's bar is higher, and the two intervals overlap from approximately 36.05% to 49.10%. The plot shows both the difference in success proportions and the estimated intervals.
Reference sources: WM9QE_Discrete Distribution; [WM9QE] Seminar - MATLAB Programming-c; Supplementary material

9. Homogeneity of variance and supplementary comparisons

9.1 Brown-Forsythe test
Compare between-group differences in absolute deviations from each group's median, providing relative robustness to skewness and extreme observations.
F = 0.0225 and p = 0.8816, which is above 0.05. There is insufficient evidence that the two population variances differ.
Reference sources: Supplementary material

9.2 Levene's test
Compare absolute deviations from each group's mean to test homogeneity of variance.
F = 0.0304 and p = 0.8625, which is above 0.05. No significant difference in variances is detected, consistent with the preceding variance comparisons.
Reference sources: WM9QE ANOVA; Supplementary material

9.3 One-way ANOVA
Use old versus new group membership as the single factor to compare the two groups' mean lifetimes.
The between-group sum of squares is 497.025, and the within-group sum of squares is 5725.95; F = 3.2985, with degrees of freedom of 1 and 38, and p = 0.0772.
At the 0.05 significance level, no significant difference between the two population mean lifetimes is detected, consistent with the conclusion from the two-sided mean comparison.
Reference sources: WM9QE ANOVA

9.4 Rank-sum test
Use the two-sided approximate method in ranksum to pool and rank the observations from both groups, comparing the two distributions through their ranks.
The new group's rank sum is 479.5. After adjustment for tied ranks and continuity correction, z = 1.8669 and p = 0.0619.
p is above 0.05, so the difference in ranks between the groups does not reach statistical significance.
Reference sources: Supplementary material

10. Sensitivity analysis
Retain the full-data analysis results and create an additional scenario that temporarily omits the old group's 64-hour observation, comparing the mean difference, confidence interval, and two-sided pooled test results.
With all observations retained, the old group has 20 observations, the mean difference is 7.05 hours, the 95% confidence interval is -0.8083 to 14.9083 hours, and p = 0.0772.
After temporarily omitting 64, the old group has 19 observations, with a mean of 31.8421 hours and a standard deviation of 10.4097 hours; the new-minus-old mean difference is 8.6579 hours, the 95% confidence interval is 1.3082 to 16.0076 hours, and p = 0.0222.
The two-sided test changes from not reaching the 0.05 significance level to reaching it, indicating that the conclusion is sensitive to the old group's observation of 64. This observation raises the old group's mean and dispersion, reducing the ability to detect a difference between the group means.
Reference sources: [WM9QE] Seminar - MATLAB Programming-c; WM9QE Week2 Normality Hypothesis Parametric Tests; Supplementary material
