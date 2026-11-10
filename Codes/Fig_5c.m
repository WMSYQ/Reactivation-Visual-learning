
% =========================================================================
% Figure 5c: Behavioral Thresholds across Directions
% Grouped bars + individual subject scatter + SEM error bars
% Open-table style X-axis
% =========================================================================

% Load data
% Threshold: 3 x 3
%   Rows    = 0°, 90°, -90°
%   Columns = Pre, Post1, Post2
%
% subject_data: N x 8
%   Col 1 = Pre 0°
%   Col 2 = Pre 90°
%   Col 3 = Post1 0°
%   Col 4 = Post1 90°
%   Col 5 = Post1 -90°
%   Col 6 = Post2 0°
%   Col 7 = Post2 90°
%   Col 8 = Post2 -90°

load('Fig_5c.mat', 'Threshold', 'SE', 'subject_data');

% --- 1. Parameter Setup & Colors ---
c_pre   = [127, 127, 127] / 255;
c_post1 = [91, 155, 213] / 255;
c_post2 = [237, 125, 49] / 255;

colors = [c_pre; c_post1; c_post2];
c_err = [0.3, 0.3, 0.3];

assert(isequal(size(Threshold), [3, 3]), ...
    'Threshold must be a 3 x 3 matrix.');

assert(isequal(size(SE), [3, 3]), ...
    'SE must be a 3 x 3 matrix.');

assert(size(subject_data, 2) == 8, ...
    'subject_data must have 8 columns.');

nSub = size(subject_data, 1);

% --- 2. Initialize Figure ---
figure('Name', 'Figure 5c', ...
    'Position', [100, 100, 800, 500], ...
    'Color', 'w');

hold on;

% --- 3. Plot Grouped Bars ---
b = bar(Threshold, 'grouped', ...
    'BarWidth', 0.85, ...
    'EdgeColor', 'none');

b(1).FaceColor = c_pre;
b(2).FaceColor = c_post1;
b(3).FaceColor = c_post2;

% Actual centers of bars
x_pre   = b(1).XEndPoints;
x_post1 = b(2).XEndPoints;
x_post2 = b(3).XEndPoints;

% --- 4. Define Explicit Subject Data-to-Bar Mapping ---
% Each entry specifies exactly which subject_data column belongs
% to which bar. NaN means that the condition does not exist.

bar_x = [ ...
    x_pre(1),   x_post1(1), x_post2(1), ...  % 0°
    x_pre(2),   x_post1(2), x_post2(2), ...  % 90°
    NaN,        x_post1(3), x_post2(3)  ...  % -90°
    ];

subject_col = [1, 3, 6, ...  % 0°: Pre, Post1, Post2
               2, 4, 7, ...  % 90°: Pre, Post1, Post2
               NaN, 5, 8];   % -90°: no Pre, then Post1, Post2

bar_cond = [1, 2, 3, ...     % 0°
            1, 2, 3, ...     % 90°
            NaN, 2, 3];      % -90°

% Diagnostic output: verify the subject-data mapping
fprintf('\nSubject-data mapping for Figure 5c:\n');

for k = 1:9
    if isnan(subject_col(k))
        fprintf('Bar %d: no data (expected -90° Pre)\n', k);
    else
        vals = subject_data(:, subject_col(k));
        fprintf('Bar %d: subject_data column %d, %d finite values\n', ...
            k, subject_col(k), sum(isfinite(vals)));
    end
end

% --- 5. Overlay Individual Subject Scatter ---
ylim([0, 8.5]);

marker_size = 28;

for k = 1:9

    % Explicitly skip -90° Pre: no bar position and no subject data
    if isnan(subject_col(k)) || isnan(bar_x(k))
        continue;
    end

    % Retrieve only the subject data assigned to this bar
    vals = subject_data(:, subject_col(k));

    % Remove missing values
    vals = vals(isfinite(vals));

    if isempty(vals)
        continue;
    end

    % All subjects are assigned to the correct bar center
    x_scatter = repmat(bar_x(k), numel(vals), 1);

    % Draw this bar's subjects using its own condition color
    beeswarm(x_scatter, vals, ...
        'sort_style', 'up', ...
        'use_current_axes', true, ...
        'colormap', colors(bar_cond(k), :), ...
        'MarkerFaceAlpha', 1, ...
        'MarkerEdgeColor', 'white');

    hold on;

    % Resize newly created scatter objects
    % Only resize Scatter objects, not bars or error bars
    scatter_handles = findobj(gca, 'Type', 'Scatter');

    if ~isempty(scatter_handles)
        set(scatter_handles, 'SizeData', marker_size);
    end
end

% Keep the bars behind the scatter
set(gca, 'SortMethod', 'childorder');

% --- 6. Plot Error Bars ---
for i = 1:3
    errorbar(b(i).XEndPoints, Threshold(:, i), SE(:, i), ...
        'Color', c_err, ...
        'LineStyle', 'none', ...
        'LineWidth', 1.5, ...
        'CapSize', 6);
end

% --- 7. Axes Formatting ---
xlim([0.4, 3.6]);
ylim([0, 8.5]);
yticks(0:2:8);

ylabel('Threshold (°)', ...
    'FontSize', 22, ...
    'FontName', 'Arial');

set(gca, 'XTick', [], 'XTickLabel', []);

% --- 8. Open-Table Style X-Axis Labels ---
y_text_pos1 = -0.4;
labels = {'Pre', 'Post1', 'Post2'};

for group_idx = 1:3
    for cond = 1:3
        text(b(cond).XEndPoints(group_idx), y_text_pos1, labels{cond}, ...
            'FontSize', 14, ...
            'FontName', 'Arial', ...
            'HorizontalAlignment', 'center', ...
            'Clipping', 'off');
    end
end

% Primary direction labels
y_text_pos2 = -1.2;

text(1, y_text_pos2, '0°', ...
    'FontSize', 20, 'FontName', 'Arial', ...
    'HorizontalAlignment', 'center', 'Clipping', 'off');

text(2, y_text_pos2, '90°', ...
    'FontSize', 20, 'FontName', 'Arial', ...
    'HorizontalAlignment', 'center', 'Clipping', 'off');

text(3, y_text_pos2, '-90°', ...
    'FontSize', 20, 'FontName', 'Arial', ...
    'HorizontalAlignment', 'center', 'Clipping', 'off');

% Vertical separators
plot([1.5, 1.5], [0, -1.6], 'k-', ...
    'LineWidth', 1.5, 'Clipping', 'off');

plot([2.5, 2.5], [0, -1.6], 'k-', ...
    'LineWidth', 1.5, 'Clipping', 'off');

% --- 9. Legend and Final Formatting ---
box off;

set(gca, ...
    'LineWidth', 2, ...
    'TickDir', 'out', ...
    'TickLength', [0.015, 0.015], ...
    'FontSize', 18, ...
    'FontName', 'Arial');

lgd = legend(b, {'Pre', 'Post1', 'Post2'}, ...
    'Location', 'northeastoutside', ...
    'Box', 'off');

lgd.FontSize = 16;
lgd.ItemTokenSize = [20, 18];

hold off;
