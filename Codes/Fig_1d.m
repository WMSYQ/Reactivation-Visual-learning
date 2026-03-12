% =========================================================================
% Figure 1d: Learning Curve over Learning Days
% ==========================================

% Load learning performance data (Dimensions: Subjects x Learning Days)
load('Fig_1d.mat', 'Learning_Performance');

% --- 1. Parameter Setup ---
training_day = 1:8;
n_subj = size(Learning_Performance, 1); % Number of subjects
SE1 = std(Learning_Performance, 0, 1) / sqrt(n_subj); % Standard error of the mean (SEM)
mean_color = [0.00, 0.45, 0.74]; % Default blue for group mean

% Initialize figure
figure('Name', 'Figure 1d', 'Position', [100, 100, 350, 420], 'Color', 'w');
hold on;

% --- 2. Plot Individual Subject Data ---
% Plot individual scatter points
for subj = 1:n_subj
    scatter(training_day, Learning_Performance(subj,:), 7, 'filled');
end

% Reset color order index to ensure dashed lines match the scatter point colors
set(gca, 'ColorOrderIndex', 1);

% Plot individual learning trajectories
for subj = 1:n_subj
    plot(training_day, Learning_Performance(subj,:), '--', 'LineWidth', 0.8);
end

% --- 3. Plot Group Mean Trend ---
% Calculate group mean performance across training days
mean_Learning_Performance = mean(Learning_Performance, 1);

% Plot the group mean scatter points and linear fit using custom function
Plot_scatter_with_correlation(training_day', mean_Learning_Performance', mean_color);

% --- 4. Figure Formatting ---
xlim([0.1 8.9]);
ylim([0 10]);
xticks(1:8);
xlabel('Training day', 'Fontsize', 18);
ylabel('\Delta\theta (°)', 'Fontsize', 18); 

set(gca, 'tickdir', 'out', 'box', 'off', 'LineWidth', 1.5, ...
    'FontName', 'Arial', 'Fontsize', 16);

% --- 5. Statistical Analysis ---
% Calculate and output Spearman correlation for group mean trend
[r, p] = corr(training_day', mean_Learning_Performance', 'Type', 'Spearman');
fprintf('\n=== Figure 1d Statistics ===\n');
fprintf('Spearman correlation (Days vs Mean Learning Performance):\n');
fprintf('r = %.3f, p-value = %.4f\n', r, p);

hold off;


% =========================================================================
% Custom Function: Plot_scatter_with_correlation
% =========================================================================
function [r, p] = Plot_scatter_with_correlation(X, Y, Color)
    % PLOT_SCATTER_WITH_CORRELATION Plots a scatter plot with a linear trendline.
    %
    % Inputs:
    %   X     - Independent variable (column vector)
    %   Y     - Dependent variable (column vector)
    %   Color - RGB triplet for the marker and line color
    %
    % Outputs:
    %   r     - Pearson correlation coefficient
    %   p     - p-value of the correlation
    
    % Perform first-degree linear regression (y = ax + b)
    fitresult = polyfit(X, Y, 1);
    a = fitresult(1); % Slope
    b = fitresult(2); % Intercept
    
    % Generate X range for the trendline (extending slightly beyond data limits)
    x_range = (min(X) - 0.25) : 0.1 : (max(X) + 0.25);
    y_fit = a * x_range + b;
    
    % Plot the fitted linear trendline
    plot(x_range, y_fit, 'Color', Color, 'LineWidth', 4);
    
    % Plot the mean scatter points on top of the trendline 
    % (White edge color is applied for visual separation)
    scatter(X, Y, 80, 'filled', 'MarkerFaceColor', Color, ...
        'MarkerEdgeColor', 'w', 'LineWidth', 1.5);
    
    % Calculate Pearson correlation for the provided data
    [r, p] = corr(X, Y);
end