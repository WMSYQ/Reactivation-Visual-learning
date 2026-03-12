% =========================================================================
% Figure 3c: MEG Thresholds across Orientations (Polar-style Plot)
% Layout: 1x2 Panel Plot (MEG 5 vs MEG 0)
% =========================================================================

% Load the threshold data 
load('Fig_3c.mat', 'Threshold_MEG_5', 'Threshold_MEG_0');

% --- 1. Data Preparation ---
% Package variables into a cell array for batch processing in the loop
data_all = {Threshold_MEG_5, Threshold_MEG_0};
panel_titles = {'Reactivation Group', 'Control Group'}; % Subplot titles

% Define angles for the quarter-circle (0, 30, 60, 90 degrees)
% Added 0 at both ends to create a closed path originating from the center
angles = [0, 30, 60, 90]; 
theta = deg2rad([0, angles, 0]);  

% Define group colors
color1 = [127, 127, 127] / 255; % Gray (Pre)
color2 = [91, 155, 213] / 255;  % Blue (Post1)
color3 = [255, 102, 0] / 255;   % Orange (Post2)

% Initialize widened figure window
figure('Name', 'Figure 3c', 'Position', [100, 100, 1000, 500], 'Color', 'w');
t = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% ==========================================
% Main Plotting Loop for Both Panels
% ==========================================
for i = 1:2
    nexttile;
    hold on;
    axis equal; % Maintain proper aspect ratio for the circular grid
    
    % Core logic: Subtract 1 to optimize the radial scaling near the origin
    Threshold = data_all{i} - 1;
    
    % --- 2. Draw Custom Polar Background Grid ---
    max_radius = 5;
    grid_angles = 0:30:90; 
    grid_radii = 0:ceil(max_radius); 
    
    % Plot radial angle grid lines (thick dotted gray lines)
    for angle = grid_angles
        rad_angle = deg2rad(angle);
        plot([0, max_radius * cos(rad_angle)], ...
             [0, max_radius * sin(rad_angle)], ...
             ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 2.5);
    end
    
    % Plot circular radius grid lines
    theta_grid = linspace(0, pi/2, 100); 
    for radius = grid_radii
        if radius > 0
            x_circle = radius * cos(theta_grid);
            y_circle = radius * sin(theta_grid);
            plot(x_circle, y_circle, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 2.5);
            
            % Shift the displayed text value by +1 to reverse the earlier offset
            % (e.g., radius 1 will be displayed as 2)
            text(-0.2, radius, num2str(radius + 1), ...
                 'VerticalAlignment', 'middle', ...
                 'HorizontalAlignment', 'right', ...
                 'FontName', 'Arial', 'FontSize', 20);
        end
    end
    
    % --- 3. Plot Data Lines and Markers ---
    % Lines and markers are plotted separately to avoid placing a marker at the origin
    
    % Pre Condition
    r_Pre = [0, Threshold(1,:), 0];     
    x_Pre = r_Pre .* cos(theta);        
    y_Pre = r_Pre .* sin(theta);
    plot(x_Pre, y_Pre, '-', 'Color', color1, 'LineWidth', 5);
    p1 = plot(x_Pre(2:end-1), y_Pre(2:end-1), 'o', 'Color', color1, ...
         'LineWidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', color1, 'MarkerEdgeColor', [1 1 1]);
         
    % Post1 Condition
    r_Post1 = [0, Threshold(2,:), 0];   
    x_Post1 = r_Post1 .* cos(theta);        
    y_Post1 = r_Post1 .* sin(theta);
    plot(x_Post1, y_Post1, '-', 'Color', color2, 'LineWidth', 5);
    p2 = plot(x_Post1(2:end-1), y_Post1(2:end-1), 'o', 'Color', color2, ...
         'LineWidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', color2, 'MarkerEdgeColor', [1 1 1]);
         
    % Post2 Condition
    r_Post2 = [0, Threshold(3,:), 0];   
    x_Post2 = r_Post2 .* cos(theta);        
    y_Post2 = r_Post2 .* sin(theta);
    plot(x_Post2, y_Post2, '-', 'Color', color3, 'LineWidth', 5);
    p3 = plot(x_Post2(2:end-1), y_Post2(2:end-1), 'o', 'Color', color3, ...
         'LineWidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', color3, 'MarkerEdgeColor', [1 1 1]);
         
    % --- 4. Peripheral Labels and Aesthetics ---
    % Add angle labels at the outer edge
    text(max_radius + 0.3, 0, '0°', 'FontSize', 20, 'FontName', 'Arial', 'VerticalAlignment', 'middle');
    text(max_radius * cos(deg2rad(30)) + 0.2, max_radius * sin(deg2rad(30)) + 0.2, '30°', 'FontSize', 20, 'FontName', 'Arial');
    text(max_radius * cos(deg2rad(60)) + 0.2, max_radius * sin(deg2rad(60)) + 0.2, '60°', 'FontSize', 20, 'FontName', 'Arial');
    text(0, max_radius + 0.4, '90°', 'FontSize', 20, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
    
    % Add panel titles
    title(panel_titles{i}, 'FontSize', 22, 'FontWeight', 'normal', 'FontName', 'Arial');
    
    % Y-axis main title (Rotated 90 degrees, only displayed on the left panel)
    if i == 1
        text(-1.4, max_radius/2, 'Threshold (°)', 'FontSize', 24, 'FontName', 'Arial', ...
            'Rotation', 90, 'HorizontalAlignment', 'center');
    end
    
    % Legend (Only displayed on the right panel to maintain clean layout)
    if i == 2
        lgd = legend([p1, p2, p3], {'Pre', 'Post1', 'Post2'}, 'Location', 'northeast');
        legend boxoff;
        lgd.FontSize = 18;
    end
    
    % Hide the default Cartesian axes
    axis off; 
    hold off;
end