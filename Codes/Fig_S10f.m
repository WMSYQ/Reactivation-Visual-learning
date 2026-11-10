
% =========================================================================
% Distance to Centroid (Delta R^2)
% Reactivation group vs. Control group
% Grouped by test phase: Pre, Post1, Post2
% Bar plot + individual subject scatter + SEM error bars
% =========================================================================

% -------------------------------------------------------------------------
% 1. Input data
% Rows = subjects
% Cols = Pre, Post1, Post2
% -------------------------------------------------------------------------
load('Fig_S10f.mat');

% -------------------------------------------------------------------------
% 2. Compute mean and SEM
% -------------------------------------------------------------------------

mean_react = mean(react_data, 1, 'omitnan');
mean_ctrl  = mean(ctrl_data, 1, 'omitnan');

sem_react = std(react_data, 0, 1, 'omitnan') ./ ...
    sqrt(sum(isfinite(react_data), 1));

sem_ctrl = std(ctrl_data, 0, 1, 'omitnan') ./ ...
    sqrt(sum(isfinite(ctrl_data), 1));

% Order: Pre React, Pre Control,
%        Post1 React, Post1 Control,
%        Post2 React, Post2 Control

Y = [
    mean_react(1), mean_ctrl(1), ...
    mean_react(2), mean_ctrl(2), ...
    mean_react(3), mean_ctrl(3)
];

SE = [
    sem_react(1), sem_ctrl(1), ...
    sem_react(2), sem_ctrl(2), ...
    sem_react(3), sem_ctrl(3)
];

% -------------------------------------------------------------------------
% 3. Color definition
% -------------------------------------------------------------------------

c_react = [21, 114, 161] / 255;  % Deep blue (#1572A1)
c_ctrl  = [154, 208, 236] / 255; % Light blue (#9AD0EC)

bar_colors = [
    c_react
    c_ctrl
    c_react
    c_ctrl
    c_react
    c_ctrl
];

% -------------------------------------------------------------------------
% 4. Figure setup
% -------------------------------------------------------------------------

figure('Name', 'Distance to Centroid', ...
    'Position', [100, 100, 760, 460], ...
    'Color', 'w');

ax = axes;
hold(ax, 'on');

% Two bars per test phase, with gaps between phases
x_pos = [1 2 4 5 7 8];

bar_width = 0.75;

% -------------------------------------------------------------------------
% 5. Plot bars
% -------------------------------------------------------------------------

b = bar(ax, x_pos, Y, bar_width, ...
    'FaceColor', 'flat', ...
    'EdgeColor', 'none');

for i = 1:6
    b.CData(i, :) = bar_colors(i, :);
end

% -------------------------------------------------------------------------
% 6. Overlay individual subject scatter using beeswarm
% -------------------------------------------------------------------------

marker_size = 35;

% Each test phase: Reactivation group followed by Control group
for phase = 1:3

    % Reactivation group
    vals = react_data(:, phase);
    vals = vals(isfinite(vals));

    col_react = 2 * phase - 1;
    x_scatter = repmat(x_pos(col_react), numel(vals), 1);

    beeswarm(x_scatter, vals, ...
        'sort_style', 'up', ...
        'use_current_axes', true, ...
        'colormap', c_react, ...
        'MarkerFaceAlpha', 1, ...
        'MarkerEdgeColor', 'white');

    % Control group
    vals = ctrl_data(:, phase);
    vals = vals(isfinite(vals));

    col_ctrl = 2 * phase;
    x_scatter = repmat(x_pos(col_ctrl), numel(vals), 1);

    beeswarm(x_scatter, vals, ...
        'sort_style', 'up', ...
        'use_current_axes', true, ...
        'colormap', c_ctrl, ...
        'MarkerFaceAlpha', 1, ...
        'MarkerEdgeColor', 'white');

end

% Resize scatter markers
scatter_handles = findobj(ax, 'Type', 'Scatter');

for k = 1:numel(scatter_handles)
    scatter_handles(k).SizeData = marker_size;
end

% Ensure bars are behind scatter and error bars
set(ax, 'SortMethod', 'childorder');

% -------------------------------------------------------------------------
% 7. Plot SEM error bars
% -------------------------------------------------------------------------

errorbar(ax, x_pos, Y, SE, ...
    'Color', [0.35, 0.35, 0.35], ...
    'LineStyle', 'none', ...
    'LineWidth', 1.3, ...
    'CapSize', 4);

% -------------------------------------------------------------------------
% 8. Axis formatting
% -------------------------------------------------------------------------

ylabel(ax, 'Distance to Centroid (\Delta R^2)', ...
    'FontSize', 18, ...
    'FontName', 'Arial');

xlim(ax, [0.3 8.7]);

% Center labels for each pair of bars
phase_centers = [1.5 4.5 7.5];

xticks(ax, phase_centers);
xticklabels(ax, {'Pre', 'Post1', 'Post2'});

ylim(ax, [0 0.1]);
yticks(ax, 0:0.01:0.1);

set(ax, ...
    'FontName', 'Arial', ...
    'FontSize', 14, ...
    'LineWidth', 1.2, ...
    'TickDir', 'out', ...
    'TickLength', [0.015, 0.015]);

box(ax, 'off');
ax.XAxis.TickLength = [0 0];

% -------------------------------------------------------------------------
% 9. Legend: Group
% -------------------------------------------------------------------------

dummy_react = scatter(nan, nan, 80, 's', 'filled', ...
    'MarkerFaceColor', c_react, ...
    'MarkerEdgeColor', 'none');

dummy_ctrl = scatter(nan, nan, 80, 's', 'filled', ...
    'MarkerFaceColor', c_ctrl, ...
    'MarkerEdgeColor', 'none');

lgd = legend(ax, [dummy_react, dummy_ctrl], ...
    {'Reactivation group', 'Control group'}, ...
    'Location', 'southoutside', ...
    'Orientation', 'horizontal');

lgd.Box = 'off';
lgd.FontName = 'Arial';
lgd.FontSize = 13;

hold(ax, 'off');

% -------------------------------------------------------------------------
% 10. Export (optional)
% -------------------------------------------------------------------------

% exportgraphics(gcf, ...
%     'Distance_to_Centroid_bar_scatter.png', ...
%     'Resolution', 600);

% exportgraphics(gcf, ...
%     'Distance_to_Centroid_bar_scatter.pdf', ...
%     'ContentType', 'vector');
