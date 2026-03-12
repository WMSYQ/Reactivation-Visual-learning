% =========================================================================
% Figure 2c: Decoding Accuracy Improvements (Post1 - Pre & Post2 - Pre)
% Layout: 1x2 Panel Plot comparing EVC and IPS
% =========================================================================

% Load the dataset for Figure 2c
load('Fig_2c.mat');

% --- 1. Data Preparation ---
% Package difference and standard error variables into cell arrays for batch processing
data_EVC = {Diff_EVC_Post1, Diff_EVC_Post2};
data_IPS = {Diff_IPS_Post1, Diff_IPS_Post2};
se_EVC   = {SE_EVC_Post1, SE_EVC_Post2};
se_IPS   = {SE_IPS_Post1, SE_IPS_Post2};

titles   = {'Post1 - Pre', 'Post2 - Pre'};

% Define X-axis positions 
% (Skipping position 4 creates a visual gap between the EVC and IPS groups)
x_blue  = [1, 2, 3];
x_green = [5, 6, 7];

% --- 2. Color Palette Definition ---
c_blue_dark   = [80, 137, 188] / 255;  % Dark Blue (0°)
c_blue_light  = [151, 185, 224] / 255; % Light Blue (90°)
c_green_dark  = [98, 153, 62] / 255;   % Dark Green (0°)
c_green_light = [161, 196, 144] / 255; % Light Green (90°)
c_gray        = [0.4, 0.4, 0.4];       % Gray for error bars

% --- 3. Initialize Figure and Layout ---
% Create a widened figure to accommodate the two panels
figure('Name', 'Figure 2c', 'Position', [100, 100, 1100, 450], 'Color', 'w');

% Create a compact 1x2 tiled layout
tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% --- 4. Main Plotting Loop ---
for i = 1:2
    nexttile;
    hold on;
    
    % Draw horizontal baseline at y = 0
    yline(0, 'k-', 'LineWidth', 1.5);
    
    % --- Plot Grouped Bar Charts ---
    % EVC Group (Blue palette)
    b1 = bar(x_blue, data_EVC{i}, 'grouped', 'BarWidth', 0.8);
    b1(1).FaceColor = c_blue_dark;  b1(1).EdgeColor = 'none';
    b1(2).FaceColor = c_blue_light; b1(2).EdgeColor = 'none';
    
    % IPS Group (Green palette)
    b2 = bar(x_green, data_IPS{i}, 'grouped', 'BarWidth', 0.8);
    b2(1).FaceColor = c_green_dark;  b2(1).EdgeColor = 'none';
    b2(2).FaceColor = c_green_light; b2(2).EdgeColor = 'none';
    
    % --- Plot Error Bars ---
    % Error bars for EVC
    errorbar(b1(1).XEndPoints, data_EVC{i}(:,1), se_EVC{i}(:,1), 'Color', c_gray, 'LineStyle', 'none', 'LineWidth', 1.5, 'CapSize', 3);
    errorbar(b1(2).XEndPoints, data_EVC{i}(:,2), se_EVC{i}(:,2), 'Color', c_gray, 'LineStyle', 'none', 'LineWidth', 1.5, 'CapSize', 3);
    
    % Error bars for IPS
    errorbar(b2(1).XEndPoints, data_IPS{i}(:,1), se_IPS{i}(:,1), 'Color', c_gray, 'LineStyle', 'none', 'LineWidth', 1.5, 'CapSize', 3);
    errorbar(b2(2).XEndPoints, data_IPS{i}(:,2), se_IPS{i}(:,2), 'Color', c_gray, 'LineStyle', 'none', 'LineWidth', 1.5, 'CapSize', 3);
    
    % --- Custom Legend ---
    % Render custom legend elements only in the first panel to maintain a clean layout
    if i == 1
        % 0° Legend Row
        scatter(0.5, 18, 180, 's', 'filled', 'MarkerFaceColor', c_blue_dark);
        text(0.85, 18, '/', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
        scatter(1.2, 18, 180, 's', 'filled', 'MarkerFaceColor', c_green_dark);
        text(1.6, 18, '0°', 'FontSize', 18, 'FontName', 'Arial');
        
        % 90° Legend Row
        scatter(0.5, 15, 180, 's', 'filled', 'MarkerFaceColor', c_blue_light);
        text(0.85, 15, '/', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
        scatter(1.2, 15, 180, 's', 'filled', 'MarkerFaceColor', c_green_light);
        text(1.6, 15, '90°', 'FontSize', 18, 'FontName', 'Arial');
        
        % Y-axis label (only required for the left panel)
        ylabel({'Improvement in';'decoding accuracy (%)'}, 'FontSize', 20, 'FontName', 'Arial');
    end
    
    % --- Axes Formatting and Aesthetics ---
    title(titles{i}, 'FontSize', 22, 'FontWeight', 'normal', 'FontName', 'Arial');
    
    % Set Y-axis limits and ticks
    ylim([-8 20]);
    yticks(-8:4:20);
    
    % Set X-axis limits, ticks, and ROI labels
    xlim([0 8]);
    xticks([1 2 3 5 6 7]);
    xticklabels({'V1', 'V2', 'V3', 'IPS1', 'IPS2', 'IPS3'});
    
    % Clean up axes lines and format tick marks
    box off;
    set(gca, 'FontSize', 18, 'FontName', 'Arial', 'LineWidth', 1.5, 'TickDir', 'out', 'TickLength', [0.015 0.015]);
    
    % Remove X-axis tick marks for a cleaner baseline
    ax = gca;
    ax.XAxis.TickLength = [0 0]; 
    
    % Hide Y-axis tick labels for the second panel to create a seamless visual flow
    if i == 2
        set(gca, 'YTickLabel', []);
    end
    
    hold off;
end