% =========================================================================
% Figure: Decoding Latency across EVC and IPS
% New version: grouped by time (Pre, Post1, Post2)
% Within each time point: Reactivation first, then Control
% =========================================================================

% --- 1. Load data ---
load('Fig_S8.mat');

% Data format:
% latency_EVC = [R_Pre, R_Post1, R_Post2, C_Pre, C_Post1, C_Post2]
% SE_EVC      = [R_Pre, R_Post1, R_Post2, C_Pre, C_Post1, C_Post2]
% latency_IPS and SE_IPS are arranged the same way

data_Latency = {latency_EVC, latency_IPS};
data_SE      = {SE_EVC, SE_IPS};
roi_titles   = {'EVC', 'IPS'};

% --- 2. Base colors (Reactivation group) ---
c_pre   = [0.55, 0.55, 0.55];   % Gray
c_post1 = [0.35, 0.55, 0.75];   % Blue
c_post2 = [0.93, 0.46, 0.13];   % Orange

% --- 3. Lighter colors for Control group ---
% Blend original color with white
light_factor = 0.45;   % 0~1, larger => lighter
lighten = @(c, f) c + (1 - c) * f;

c_pre_ctrl   = lighten(c_pre,   light_factor);
c_post1_ctrl = lighten(c_post1, light_factor);
c_post2_ctrl = lighten(c_post2, light_factor);

% --- 4. X positions ---
% Organized by time:
% Pre   : Reactivation, Control
% Post1 : Reactivation, Control
% Post2 : Reactivation, Control
x = [1, 2, 4, 5, 7, 8];

% --- 5. Figure initialization ---
figure('Name', 'Decoding Latency', ...
    'Position', [100, 100, 1000, 480], ...
    'Color', 'w');

% --- 6. Main plotting loop ---
for i = 1:2

    ax = subplot(1, 2, i);

    hold(ax, 'on');

    y_raw   = data_Latency{i}(:)';
    err_raw = data_SE{i}(:)';

    assert(numel(y_raw) == 6 && numel(err_raw) == 6, ...
        'Each latency and SE array must contain exactly 6 values.');

    % Reorder data:
    % original = [R_Pre, R_Post1, R_Post2, C_Pre, C_Post1, C_Post2]
    % new      = [R_Pre, C_Pre, R_Post1, C_Post1, R_Post2, C_Post2]
    reorder_idx = [1, 4, 2, 5, 3, 6];
    y   = y_raw(reorder_idx);
    err = err_raw(reorder_idx);

    % Color order corresponding to reordered data
    plot_colors = {
        c_pre,       c_pre_ctrl, ...
        c_post1,     c_post1_ctrl, ...
        c_post2,     c_post2_ctrl
        };

    % Plot points
    for j = 1:6
        errorbar(x(j), y(j), err(j), 'o', ...
            'Color', plot_colors{j}, ...
            'MarkerFaceColor', plot_colors{j}, ...
            'MarkerEdgeColor', plot_colors{j}, ...
            'MarkerSize', 12, ...
            'LineWidth', 2.5, ...
            'CapSize', 6);
    end

    % --- Axes formatting ---
    title(roi_titles{i}, ...
        'FontSize', 22, ...
        'FontName', 'Arial', ...
        'FontWeight', 'normal');

    if i == 1
        ylabel('First significant time (ms)', ...
            'FontSize', 19, 'FontName', 'Arial');
    end

    xlim([0.3, 8.7]);
    xticks(x);
    xticklabels({'Reactivation', 'Control', 'Reactivation', 'Control', 'Reactivation', 'Control'});

    if i == 1
        ylim([80, 200]);
        yticks(80:20:200);
    elseif i == 2
        ylim([80, 240]);
        yticks(80:20:240);
    end

    box(ax, 'off');
    set(ax, ...
        'LineWidth', 2, ...
        'TickDir', 'out', ...
        'TickLength', [0.015, 0.015], ...
        'FontSize', 12, ...
        'FontName', 'Arial');

    % --- Time labels below the x-axis ---
    text(ax, 0.17, -0.20, 'Pre', ...
        'Units', 'normalized', ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 14, ...
        'FontName', 'Arial', ...
        'Clipping', 'off');

    text(ax, 0.50, -0.20, 'Post1', ...
        'Units', 'normalized', ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 14, ...
        'FontName', 'Arial', ...
        'Clipping', 'off');

    text(ax, 0.83, -0.20, 'Post2', ...
        'Units', 'normalized', ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 14, ...
        'FontName', 'Arial', ...
        'Clipping', 'off');

    hold(ax, 'off');
end



% --- 7. Custom dual-color legend with circular markers and error bars ---
% Positioned at the southeast of the right panel

legend_x = 0.77;
legend_y_top = 0.30;
row_gap = 0.08;

legend_colors = {
    c_pre,   c_pre_ctrl;
    c_post1, c_post1_ctrl;
    c_post2, c_post2_ctrl
};

legend_labels = {'Pre', 'Post1', 'Post2'};

% Symbol dimensions in normalized figure units
marker_w = 0.012;
marker_h = 0.023;
eb_half_h = 0.015;
cap_half_w = 0.006;

% Draw one error-bar symbol
draw_error_symbol = @(xc, yc, color) ...
    drawLegendErrorbar(xc, yc, color, ...
    marker_w, marker_h, eb_half_h, cap_half_w);

for k = 1:3

    yc = legend_y_top - (k-1) * row_gap;

    % First symbol: Reactivation group (original color)
    x1 = legend_x + 0.008;
    draw_error_symbol(x1, yc + 0.012, legend_colors{k,1});

    % Slash between groups
    annotation('textbox', ...
        [legend_x + 0.020, yc - 0.002, 0.025, 0.036], ...
        'String', '/', ...
        'EdgeColor', 'none', ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', ...
        'FontName', 'Arial', ...
        'FontSize', 16, ...
        'Margin', 0);

    % Second symbol: Control group (lighter color)
    x2 = legend_x + 0.049;
    draw_error_symbol(x2, yc + 0.012, legend_colors{k,2});

    % Time-point label
    annotation('textbox', ...
        [legend_x + 0.066, yc - 0.002, 0.09, 0.036], ...
        'String', legend_labels{k}, ...
        'EdgeColor', 'none', ...
        'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'middle', ...
        'FontName', 'Arial', ...
        'FontSize', 14, ...
        'Margin', 0);
end

% --- Local function: circular marker + vertical error bar with caps ---
function drawLegendErrorbar(xc, yc, color, ...
    marker_w, marker_h, eb_half_h, cap_half_w)

    % Vertical error bar
    annotation('line', ...
        [xc, xc], [yc - eb_half_h, yc + eb_half_h], ...
        'Color', color, 'LineWidth', 1.5);

    % Upper and lower caps
    annotation('line', ...
        [xc - cap_half_w, xc + cap_half_w], ...
        [yc + eb_half_h, yc + eb_half_h], ...
        'Color', color, 'LineWidth', 1.5);

    annotation('line', ...
        [xc - cap_half_w, xc + cap_half_w], ...
        [yc - eb_half_h, yc - eb_half_h], ...
        'Color', color, 'LineWidth', 1.5);

    % Circular marker, filled with the corresponding color
    annotation('ellipse', ...
        [xc - marker_w/2, yc - marker_h/2, marker_w, marker_h], ...
        'FaceColor', color, ...
        'EdgeColor', color, ...
        'LineWidth', 1);
end



% --- 7. Export figure (optional) ---
% exportgraphics(gcf, ...
%     'C:\Users\Lab\Desktop\Review\Codes_New\Decoding_Latency_byTime.png', ...
%     'Resolution', 300);