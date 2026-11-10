% =========================================================================
% Figure 5d: Behavioral Improvements 
% =========================================================================

% Load behavioral improvement data and standard errors
load('Fig_5d.mat');

% --- 1. Parameter Setup & Color Definition ---
% Define custom RGB colors (normalized)
color_post1_bar1 = [0.33, 0.55, 0.78]; % Dark Blue (Post1, Bar 1)
color_post1_bar2 = [0.60, 0.74, 0.86]; % Light Blue (Post1, Bar 2)
color_post2_bar1 = [0.89, 0.42, 0.13]; % Dark Orange (Post2, Bar 1)
color_post2_bar2 = [0.93, 0.64, 0.45]; % Light Orange (Post2, Bar 2)

% Initialize figure window
figure('Name', 'Figure 5d', 'Position', [100, 100, 500, 500], 'Color', 'w');
hold on;

% --- 2. Plot Grouped Bar Chart ---
b = bar(MPI, 'grouped');

% Remove default black edges for a cleaner look
b(1).EdgeColor = 'none';
b(2).EdgeColor = 'none';

% Apply independent colors to each specific bar
b(1).FaceColor = 'flat';
b(2).FaceColor = 'flat';

% Assign colors to the first bar of each group
b(1).CData(1,:) = color_post1_bar1; % Post1
b(1).CData(2,:) = color_post2_bar1; % Post2

% Assign colors to the second bar of each group
b(2).CData(1,:) = color_post1_bar2; % Post1
b(2).CData(2,:) = color_post2_bar2; % Post2

% --- 3. Plot Error Bars ---
% Extract the exact X-coordinates of the bar centers
x1 = b(1).XEndPoints;
x2 = b(2).XEndPoints;

% Overlay subjects at the actual bar centers; preserve the existing axes.
% Columns: Post1 Bar1, Post1 Bar2, Post2 Bar1, Post2 Bar2.
bar_centers = [x1(1), x2(1), x1(2), x2(2)];
Scatter_color = [color_post1_bar1; color_post1_bar2; ...
    color_post2_bar1; color_post2_bar2];
group = repmat(bar_centers, size(subject_data, 1), 1);
ylim([0 50]); % Use the final axis scale when arranging the swarm.
beeswarm(group(:), subject_data(:), 'sort_style', 'up', ...
    'use_current_axes', true, 'colormap', Scatter_color, ...
    'MarkerFaceAlpha', 1, 'MarkerEdgeColor', 'white');
hold on;
set(gca, 'SortMethod', 'childorder'); % bars < scatter < error bars

% Draw error bars (dark gray, no connecting lines)
errorbar(x1, MPI(:,1), SE(:,1), 'k', 'LineStyle', 'none', ...
    'LineWidth', 1.5, 'CapSize', 5, 'Color', [0.35, 0.35, 0.35]);
errorbar(x2, MPI(:,2), SE(:,2), 'k', 'LineStyle', 'none', ...
    'LineWidth', 1.5, 'CapSize', 5, 'Color', [0.35, 0.35, 0.35]);

% --- 4. Figure Formatting ---
title('Behavioral improvements', 'FontSize', 18, 'FontWeight', 'normal', 'FontName', 'Arial');
ylabel('Improvement (%)', 'FontSize', 22, 'FontName', 'Arial');

% Set X-axis labels and tick properties
set(gca, 'XTick', [1 2], 'XTickLabel', {'Post1', 'Post2'}, ...
    'FontSize', 18, 'FontName', 'Arial');

% Set Y-axis limits and ticks
ylim([0 65]);
yticks(0:10:60);

% Aesthetics: hide top/right axes, thicken visible axes, format ticks
box off;
set(gca, 'LineWidth', 1.5, 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Remove X-axis tick marks to maintain a clean baseline while keeping Y-axis ticks
ax = gca;
ax.XAxis.TickLength = [0 0];

hold off;
