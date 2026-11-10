
% =========================================================================
% Supplementary Figure 1: MRI Thresholds across Motion Directions
% Grouped bars + individual subject scatter + SEM error bars
% =========================================================================

% Load data
% Threshold_MRI: 3 x 4
%   Row 1 = Pre
%   Row 2 = Post1
%   Row 3 = Post2
%   Cols  = 0, 30, 60, 90 degrees
%
% subject_data: 13 x 12
%   Cols 1:4   = Pre,   0/30/60/90 degrees
%   Cols 5:8   = Post1, 0/30/60/90 degrees
%   Cols 9:12  = Post2, 0/30/60/90 degrees

%% Reactivation group
load('Fig_S1.mat', 'Threshold_MRI', 'subject_data');

% --- 1. Data Preparation ---
% assert(isequal(size(Threshold_MRI), [3, 4]), ...
%     'Threshold_MRI must be a 3 x 4 matrix.');
% 
% assert(isequal(size(subject_data), [13, 12]), ...
%     'subject_data must be a 13 x 12 matrix.');

% Rows = directions; columns = test phases
Y = Threshold_MRI';

% Calculate SEM from individual subject data
SE_MRI = zeros(3, 4);

for cond = 1:3
    for dir_idx = 1:4
        col_idx = (cond - 1) * 4 + dir_idx;
        vals = subject_data(:, col_idx);
        vals = vals(isfinite(vals));

        SE_MRI(cond, dir_idx) = std(vals, 0) / sqrt(numel(vals));
    end
end

SE_plot = SE_MRI';

% --- 2. Classic Color Palette ---
c_pre   = [127, 127, 127] / 255; % Gray
c_post1 = [91, 155, 213] / 255;  % Blue
c_post2 = [237, 125, 49] / 255;  % Orange

colors = [c_pre; c_post1; c_post2];

% --- 3. Initialize Figure ---
figure('Name', 'Supplementary Figure - MRI Thresholds', ...
    'Position', [100, 100, 760, 480], ...
    'Color', 'w');

ax = axes;
hold(ax, 'on');

x = 1:4;
bar_width = 0.8;

% --- 4. Plot Grouped Bars ---
b = bar(ax, x, Y, 'grouped', 'BarWidth', bar_width);

for cond = 1:3
    b(cond).FaceColor = colors(cond, :);
    b(cond).EdgeColor = 'none';
end

% Get actual bar centers
bar_centers = zeros(4, 3);

for cond = 1:3
    bar_centers(:, cond) = b(cond).XEndPoints(:);
end

% --- 5. Overlay Individual Subject Scatter ---
% Each direction contains 13 individual subject values per condition.

marker_size = 18;  % Smaller scatter points

for cond = 1:3
    for dir_idx = 1:4

        col_idx = (cond - 1) * 4 + dir_idx;
        vals = subject_data(:, col_idx);

        % Ignore missing or non-finite values
        valid = isfinite(vals);
        vals = vals(valid);

        % Center subjects on the corresponding bar;
        % beeswarm spreads points horizontally to reduce overlap
        x_scatter = repmat( ...
            bar_centers(dir_idx, cond), numel(vals), 1);

        beeswarm(x_scatter, vals, ...
            'sort_style', 'up', ...
            'use_current_axes', true, ...
            'colormap', colors(cond, :), ...
            'MarkerFaceAlpha', 1, ...
            'MarkerEdgeColor', 'white');

    end
end

% Reduce the size of all individual scatter markers
% The beeswarm output is plotted as Scatter objects.
scatter_handles = findobj(ax, 'Type', 'Scatter');

for k = 1:numel(scatter_handles)
    scatter_handles(k).SizeData = marker_size;
end

% Ensure bars are behind the scatter and error bars
set(ax, 'SortMethod', 'childorder');

% --- 6. Plot SEM Error Bars ---
for cond = 1:3
    errorbar(ax, bar_centers(:, cond), Y(:, cond), SE_plot(:, cond), ...
        'Color', [0.35, 0.35, 0.35], ...
        'LineStyle', 'none', ...
        'LineWidth', 1.3, ...
        'CapSize', 4);
end

% --- 7. Axes Formatting ---
ylabel(ax, 'Threshold (°)', ...
    'FontSize', 18, ...
    'FontName', 'Arial');

xlim(ax, [0.5, 4.5]);
xticks(ax, 1:4);
xticklabels(ax, {'0°', '30°', '60°', '90°'});

% Requested Y-axis range
ylim(ax, [0, 10]);
yticks(ax, 0:1:10);

set(ax, ...
    'FontName', 'Arial', ...
    'FontSize', 14, ...
    'LineWidth', 1.2, ...
    'TickDir', 'out', ...
    'TickLength', [0.015, 0.015]);

box(ax, 'off');

% --- 8. Legend ---
lgd = legend(ax, b, {'Pre', 'Post1', 'Post2'}, ...
    'Location', 'southoutside', ...
    'Orientation', 'horizontal');

lgd.Box = 'off';
lgd.FontName = 'Arial';
lgd.FontSize = 13;

hold(ax, 'off');

% --- 9. Export (optional) ---
% exportgraphics(gcf, ...
%     'Supplementary_MRI_Thresholds.png', ...
%     'Resolution', 600);

% exportgraphics(gcf, ...
%     'Supplementary_MRI_Thresholds.pdf', ...
%     'ContentType', 'vector');


%% Reactivation group
load('Fig_S1_control.mat', 'Threshold_MRI', 'subject_data');

% --- 1. Data Preparation ---
% assert(isequal(size(Threshold_MRI), [3, 4]), ...
%     'Threshold_MRI must be a 3 x 4 matrix.');
% 
% assert(isequal(size(subject_data), [13, 12]), ...
%     'subject_data must be a 13 x 12 matrix.');

% Rows = directions; columns = test phases
Y = Threshold_MRI';

% Calculate SEM from individual subject data
SE_MRI = zeros(3, 4);

for cond = 1:3
    for dir_idx = 1:4
        col_idx = (cond - 1) * 4 + dir_idx;
        vals = subject_data(:, col_idx);
        vals = vals(isfinite(vals));

        SE_MRI(cond, dir_idx) = std(vals, 0) / sqrt(numel(vals));
    end
end

SE_plot = SE_MRI';

% --- 2. Classic Color Palette ---
c_pre   = [127, 127, 127] / 255; % Gray
c_post1 = [91, 155, 213] / 255;  % Blue
c_post2 = [237, 125, 49] / 255;  % Orange

colors = [c_pre; c_post1; c_post2];

% --- 3. Initialize Figure ---
figure('Name', 'Supplementary Figure - MRI Thresholds', ...
    'Position', [100, 100, 760, 480], ...
    'Color', 'w');

ax = axes;
hold(ax, 'on');

x = 1:4;
bar_width = 0.8;

% --- 4. Plot Grouped Bars ---
b = bar(ax, x, Y, 'grouped', 'BarWidth', bar_width);

for cond = 1:3
    b(cond).FaceColor = colors(cond, :);
    b(cond).EdgeColor = 'none';
end

% Get actual bar centers
bar_centers = zeros(4, 3);

for cond = 1:3
    bar_centers(:, cond) = b(cond).XEndPoints(:);
end

% --- 5. Overlay Individual Subject Scatter ---
% Each direction contains 13 individual subject values per condition.

marker_size = 18;  % Smaller scatter points

for cond = 1:3
    for dir_idx = 1:4

        col_idx = (cond - 1) * 4 + dir_idx;
        vals = subject_data(:, col_idx);

        % Ignore missing or non-finite values
        valid = isfinite(vals);
        vals = vals(valid);

        % Center subjects on the corresponding bar;
        % beeswarm spreads points horizontally to reduce overlap
        x_scatter = repmat( ...
            bar_centers(dir_idx, cond), numel(vals), 1);

        beeswarm(x_scatter, vals, ...
            'sort_style', 'up', ...
            'use_current_axes', true, ...
            'colormap', colors(cond, :), ...
            'MarkerFaceAlpha', 1, ...
            'MarkerEdgeColor', 'white');

    end
end

% Reduce the size of all individual scatter markers
% The beeswarm output is plotted as Scatter objects.
scatter_handles = findobj(ax, 'Type', 'Scatter');

for k = 1:numel(scatter_handles)
    scatter_handles(k).SizeData = marker_size;
end

% Ensure bars are behind the scatter and error bars
set(ax, 'SortMethod', 'childorder');

% --- 6. Plot SEM Error Bars ---
for cond = 1:3
    errorbar(ax, bar_centers(:, cond), Y(:, cond), SE_plot(:, cond), ...
        'Color', [0.35, 0.35, 0.35], ...
        'LineStyle', 'none', ...
        'LineWidth', 1.3, ...
        'CapSize', 4);
end

% --- 7. Axes Formatting ---
ylabel(ax, 'Threshold (°)', ...
    'FontSize', 18, ...
    'FontName', 'Arial');

xlim(ax, [0.5, 4.5]);
xticks(ax, 1:4);
xticklabels(ax, {'0°', '30°', '60°', '90°'});

% Requested Y-axis range
ylim(ax, [0, 10]);
yticks(ax, 0:1:10);

set(ax, ...
    'FontName', 'Arial', ...
    'FontSize', 14, ...
    'LineWidth', 1.2, ...
    'TickDir', 'out', ...
    'TickLength', [0.015, 0.015]);

box(ax, 'off');

% --- 8. Legend ---
lgd = legend(ax, b, {'Pre', 'Post1', 'Post2'}, ...
    'Location', 'southoutside', ...
    'Orientation', 'horizontal');

lgd.Box = 'off';
lgd.FontName = 'Arial';
lgd.FontSize = 13;

hold(ax, 'off');

% --- 9. Export (optional) ---
% exportgraphics(gcf, ...
%     'Supplementary_MRI_Thresholds.png', ...
%     'Resolution', 600);

% exportgraphics(gcf, ...
%     'Supplementary_MRI_Thresholds.pdf', ...
%     'ContentType', 'vector');

