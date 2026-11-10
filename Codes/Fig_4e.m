% =========================================================================
% Figure 4e: Brain-Behavior Correlation (Cloud & Core Scatter Plots)
% Layout: 2x2 Grid (EVC and IPS across Post1 and Post2)
% =========================================================================

% Load distance and behavioral data
load('Fig_4e.mat');

% --- 1. Parameter Setup & Color Definition ---
color2 = [91, 155, 213] / 255; % Blue (Post1)
color3 = [255, 102, 0] / 255;  % Orange (Post2)

% Package explicitly extracted variables into cell arrays for batch plotting
% Order: [1] EVC-Post1, [2] EVC-Post2, [3] IPS-Post1, [4] IPS-Post2
X_cloud_all = {All_Post1, All_Post2, All_Post1, All_Post2};
X_core_all  = {Mean_Post1, Mean_Post2, Mean_Post1, Mean_Post2};

Y_cloud_all = {EVC_Dis_Post1_All, EVC_Dis_Post2_All, IPS_Dis_Post1_All, IPS_Dis_Post2_All};
Y_core_all  = {EVC_Dis_Post1_Mean, EVC_Dis_Post2_Mean, IPS_Dis_Post1_Mean, IPS_Dis_Post2_Mean};

% Assign colors: Left column (Post1) is Blue, Right column (Post2) is Orange
panel_colors = {color2, color3, color2, color3};

% Define region and timepoint titles for each subplot
panel_names = {'EVC (Post1)', 'EVC (Post2)', 'IPS (Post1)', 'IPS (Post2)'};

% --- 2. Initialize Figure and Layout ---
figure('Name', 'Figure 4e', 'Color', 'w', 'Position', [100, 100, 900, 800]); 
tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% --- 3. Main Plotting Loop ---
for i = 1:4
    nexttile; 
    
    % Extract data for the current panel
    X_cloud = X_cloud_all{i};
    X_core  = X_core_all{i};
    Y_cloud = Y_cloud_all{i};
    Y_core  = Y_core_all{i};
    current_color = panel_colors{i};
    
    % Call the custom plotting function
    [r_val, p_val] = plot_cloud_and_core(X_cloud, Y_cloud, X_core, Y_core, current_color);
    
    % Determine Significance Stars
    if p_val < 0.001
        sig_str = '***';
    elseif p_val < 0.01
        sig_str = '**';
    elseif p_val < 0.05
        sig_str = '*';
    else
        sig_str = 'n.s.';
    end
    
    % Add Titles and Statistics
    title_str = sprintf('%s\nPearson r = %.3f, p = %.3f (%s)', ...
                        panel_names{i}, r_val, p_val, sig_str);
    title(title_str, 'Interpreter', 'none', 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Arial');
    
    % Axes Labels (Displayed only on the outer edges for a clean layout)
    if i == 3 || i == 4 % Bottom row
        xlabel('Behavioral Precision (\Delta 1/\theta^2)', 'Interpreter', 'tex', 'FontSize', 14, 'FontName', 'Arial');
    end
    if i == 1 || i == 3 % Left column
        ylabel('Distance to Centroid (\Delta R^2)', 'Interpreter', 'tex', 'FontSize', 14, 'FontName', 'Arial');
    end
end


% =========================================================================
% Custom Functions
% =========================================================================

function [r_val, p_val] = plot_cloud_and_core(X_cloud, Y_cloud, X_core, Y_core, main_color)
    % PLOT_CLOUD_AND_CORE Plots individual trial data (cloud) as background 
    % and subject mean data (core) in the foreground with a linear fit.
    
    hold on;
    
    % 1. Plot background cloud (e.g., N=52)
    % Small, dark gray, semi-transparent points placed at the bottom layer
    scatter(X_cloud, Y_cloud, 40, 'filled', ...
        'MarkerFaceColor', [0.4 0.4 0.4], ... 
        'MarkerFaceAlpha', 0.3, ...           
        'MarkerEdgeColor', 'none');
    
    % 2. Calculate statistics based strictly on Core data (e.g., N=13)
    [r_val, p_val] = corr(X_core, Y_core, 'Type', 'Pearson', 'Tail', 'right');
    
    % 3. Linear regression and confidence interval calculation
    [X_sorted, I] = sort(X_core);
    Y_sorted = Y_core(I);
    
    % Linear fit (Polynomial of degree 1)
    [p, S] = polyfit(X_sorted, Y_sorted, 1);
    
    % Generate smooth X coordinates for the trendline
    x_fit_range = linspace(min(X_sorted), max(X_sorted), 100);
    [y_fit_line, dy] = polyconf(p, x_fit_range, S, 'predopt', 'curve');
    
    % 4. Plot confidence interval patch
    x_conf = [x_fit_range, fliplr(x_fit_range)];
    y_conf = [y_fit_line - dy, fliplr(y_fit_line + dy)];
    
    % Render the confidence interval as a highly transparent patch
    patch(x_conf, y_conf, main_color, 'FaceAlpha', 0.15, 'EdgeColor', 'none');
    
    % 5. Plot the fitted trendline
    plot(x_fit_range, y_fit_line, 'Color', main_color, 'LineWidth', 2.5);
    
    % 6. Plot core points (e.g., N=13)
    % Large, vivid, solid points with white edges to pop out against the background
    scatter(X_core, Y_core, 100, 'filled', ...
        'MarkerFaceColor', main_color, ...
        'MarkerEdgeColor', 'w', ...  
        'LineWidth', 1.5);
    
    % 7. Axes formatting and aesthetics
    grid off;
    axis square; % Maintain square ratio standard for scientific correlation plots
    set(gca, 'LineWidth', 1.5, 'FontSize', 12, 'FontName', 'Arial', ...
        'TickDir', 'out', 'Box', 'off');
    
    % Add zero reference lines (dotted gray)
    xline(0, 'k:', 'HandleVisibility', 'off', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.2);
    yline(0, 'k:', 'HandleVisibility', 'off', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.2);
    
    hold off;
end