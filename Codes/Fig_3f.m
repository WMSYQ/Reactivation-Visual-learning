% =========================================================================
% Figure 3f: Decoding Latency (ms) across EVC and IPS
% Layout: 1x2 Panel Plot
% =========================================================================

% Load the latency data and standard errors
load('Fig_3f.mat');

% --- 1. Data Preparation ---
% Package data into cell arrays for batch processing in the loop
data_Latency = {Latency_EVC, Latency_IPS};
data_SE      = {SE_EVC, SE_IPS};
roi_titles   = {'EVC', 'IPS'};

% --- 2. Significance Bracket Configuration ---
% Custom Y-axis heights for nested significance brackets for each ROI
% (Adjust these values if the data range for IPS changes in the future)
bracket_EVC = struct('y1', 185, 'y2', 202, 'y3', 140, 'text_y', 208, 'star', '**');
bracket_IPS = struct('y1', 185, 'y2', 202, 'y3', 140, 'text_y', 208, 'star', '*'); 
brackets_all = {bracket_EVC, bracket_IPS};
line_width_bracket = 2.5;

% --- 3. Color Palette Definition ---
c_pre   = [0.55, 0.55, 0.55]; % Gray (Pre)
c_post1 = [0.35, 0.55, 0.75]; % Blue (Post1)
c_post2 = [0.93, 0.46, 0.13]; % Orange (Post2)

x = [1, 2, 3];

% --- 4. Initialize Figure ---
% Create a widened figure to accommodate the two side-by-side panels
figure('Name', 'Figure 3f', 'Position', [100, 100, 700, 400], 'Color', 'w');

% --- 5. Main Plotting Loop ---
for i = 1:2
    subplot(1, 2, i);
    hold on;
    
    % Extract data and bracket parameters for the current ROI
    y   = data_Latency{i};
    err = data_SE{i};
    brk = brackets_all{i};
    
    % --- Plot Scatter Points with Error Bars ---
    % Using errorbar to simultaneously plot the marker and the lines
    errorbar(x(1), y(1), err(1), 'o', 'Color', c_pre,   'MarkerFaceColor', c_pre,   'MarkerSize', 15, 'LineWidth', 4, 'CapSize', 6);
    errorbar(x(2), y(2), err(2), 'o', 'Color', c_post1, 'MarkerFaceColor', c_post1, 'MarkerSize', 15, 'LineWidth', 4, 'CapSize', 6);
    errorbar(x(3), y(3), err(3), 'o', 'Color', c_post2, 'MarkerFaceColor', c_post2, 'MarkerSize', 15, 'LineWidth', 4, 'CapSize', 6);
    
    % --- Axes Formatting and Aesthetics ---
    title(roi_titles{i}, 'FontSize', 20, 'FontName', 'Arial', 'FontWeight', 'normal');
    
    % Only display Y-axis label on the left panel (EVC)
    if i == 1
        ylabel('Decoding latency (ms)', 'FontSize', 20, 'FontName', 'Arial');
    end
    
    % Set X and Y axis limits and ticks
    xlim([0.3 3.7]);
    xticks([1 2 3]);
    xticklabels({'Pre', 'Post1', 'Post2'});
    ylim([50 225]);
    yticks(60:40:220);
    
    % Clean up axes (Box off, outward ticks)
    box off;
    set(gca, 'LineWidth', 2.5, 'TickDir', 'out', 'TickLength', [0.025 0.025], 'FontSize', 18, 'FontName', 'Arial');
    
    % Hide Y-axis tick labels for the right panel (IPS) for a cleaner layout
    if i == 2
        set(gca, 'YTickLabel', []);
    end
    
    hold off;
end