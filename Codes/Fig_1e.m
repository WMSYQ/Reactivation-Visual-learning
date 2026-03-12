% =========================================================================
% Figure 1e: MRI Thresholds across Directions (Polar-style Plot)
% =========================================================================

% Load the threshold data 
load('Fig_1e.mat', 'Threshold_MRI');

% --- 1. Data Preparation ---
% Offset data by -2 to optimize the radial plotting scale near the origin
Threshold = Threshold_MRI - 2;

% Define angles for the quarter-circle (0, 30, 60, 90 degrees)
% Added 0 at both ends to create a closed path originating from the center
angles = [0, 30, 60, 90]; 
theta = deg2rad([0, angles, 0]);  

% Define group colors
color1 = [127, 127, 127] / 255; % Gray (Pre)
color2 = [91, 155, 213] / 255;  % Blue (Post1)
color3 = [255, 102, 0] / 255;   % Orange (Post2)

% Initialize figure
figure('Name', 'Figure 1e', 'Position', [100, 100, 500, 500], 'Color', 'w');
hold on;
axis equal; % Ensure proper aspect ratio for the circular grid

% --- 2. Draw Custom Background Grid ---
% Drawn first so it remains in the background and does not occlude data
max_radius = 5;
grid_angles = 0:30:90; 
grid_radii = 0:ceil(max_radius); 

% Plot radial angle lines (thick dotted gray lines)
for angle = grid_angles
    rad_angle = deg2rad(angle);
    plot([0, max_radius * cos(rad_angle)], ...
         [0, max_radius * sin(rad_angle)], ...
         ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 2.5);
end

% Plot circular radius lines
theta_grid = linspace(0, pi/2, 100); 
for radius = grid_radii
    if radius > 0
        x_circle = radius * cos(theta_grid);
        y_circle = radius * sin(theta_grid);
        plot(x_circle, y_circle, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 2.5);
        
        % Add radius labels (shift text value by +2 to reverse the earlier offset)
        text(-0.2, radius, num2str(radius + 2), ...
             'VerticalAlignment', 'middle', ...
             'HorizontalAlignment', 'right', ...
             'FontName', 'Arial', 'FontSize', 20);
    end
end

% --- 3. Plot Data Lines and Markers ---
% Lines and markers are plotted separately to prevent markers from appearing at the origin (0,0)

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

% Add Y-axis title (rotated 90 degrees)
text(-1.2, max_radius/2, 'Threshold (°)', 'FontSize', 24, 'FontName', 'Arial', ...
    'Rotation', 90, 'HorizontalAlignment', 'center');

% Add legend
lgd = legend([p1, p2, p3], {'Pre', 'Post1', 'Post2'}, 'Location', 'northeast');
legend boxoff;
lgd.FontSize = 18;

% Hide the default Cartesian axes to display only the custom polar grid
axis off; 
hold off;