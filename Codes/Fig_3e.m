
% =========================================================================
% Figure 3e: Generalization Index (%) across Reactivation and Control Groups
% With individual subject data overlaid on the reactivation bars
% =========================================================================

% Load generalization data and standard errors
% Generalization_Index: [Post1, Post2]
% SE:                   [Post1, Post2]
% subject_data:         N x 2 (individual subjects, Post1 and Post2)

load("Fig_3e.mat", "Generalization_Index", "SE", "subject_data");

% --- 1. Parameter Setup & Color Definition ---
x_react = [1, 2];  % Reactivation group
x_ctrl  = [4, 5];  % Control group

% Post1 Colors (Blue theme)
c_face_p1 = [0.60, 0.74, 0.86]; % Light blue fill
c_edge_p1 = [0.33, 0.55, 0.78]; % Dark blue edge

% Post2 Colors (Orange theme)
c_face_p2 = [0.93, 0.64, 0.45]; % Light orange fill
c_edge_p2 = [0.89, 0.42, 0.13]; % Dark orange edge

c_err = [0.35, 0.35, 0.35];     % Dark gray for error bars

% Initialize figure window
figure('Name', 'Figure 3e', ...
    'Position', [100, 100, 400, 480], ...
    'Color', 'w');
hold on;

% --- 2. Plot Reference Baseline ---
% Dashed line at 100% generalization
yline(100, '--', ...
    'Color', [0.6, 0.6, 0.6], ...
    'LineWidth', 3);

% --- 3. Plot Reactivation Group Bars ---
bar_width = 0.6;

% Post1 Bar
b1 = bar(x_react(1), Generalization_Index(1), bar_width);
b1.FaceColor = c_face_p1;
b1.EdgeColor = c_edge_p1;
b1.LineWidth = 3;

% Post2 Bar
b2 = bar(x_react(2), Generalization_Index(2), bar_width);
b2.FaceColor = c_face_p2;
b2.EdgeColor = c_edge_p2;
b2.LineWidth = 3;

% --- 4. Overlay Individual Subject Data ---
% subject_data columns:
% Column 1 = Post1
% Column 2 = Post2
assert(size(subject_data, 2) == 2, ...
    'subject_data must have two columns: Post1 and Post2.');

% Use the actual bar centers
bar_centers = [b1.XEndPoints, b2.XEndPoints];

% Assign each subject to the corresponding bar center
group = repmat(bar_centers, size(subject_data, 1), 1);

% Draw beeswarm scatter on top of the bars
% Each column of subject_data corresponds to one bar
beeswarm(group(:), subject_data(:), ...
    'sort_style', 'up', ...
    'use_current_axes', true, ...
    'colormap', [c_face_p1; c_face_p2], ...
    'MarkerFaceAlpha', 1, ...
    'MarkerEdgeColor', 'white');

hold on;
set(gca, 'SortMethod', 'childorder'); % Bars < scatter < error bars

% --- 5. Plot Error Bars ---
errorbar(x_react, Generalization_Index, SE, ...
    'Color', c_err, ...
    'LineStyle', 'none', ...
    'LineWidth', 2.5, ...
    'CapSize', 6);

% --- 6. Plot Control Group Markers ---
% Control group remains represented by red X markers at zero
plot(x_ctrl, [0, 0], 'x', ...
    'Color', [0.75, 0.1, 0.1], ...
    'MarkerSize', 12, ...
    'LineWidth', 2);

% --- 7. Axes Formatting & Aesthetics ---
ylabel('Generalization (%)', ...
    'FontSize', 22, ...
    'FontName', 'Arial');

ylim([0, 160]);
yticks(0:20:160);
xlim([0, 6]);

ax = gca;
ax.XTick = [];
box off;

set(ax, ...
    'LineWidth', 2.5, ...
    'TickDir', 'out', ...
    'TickLength', [0.02, 0.02], ...
    'FontSize', 18, ...
    'FontName', 'Arial');

% --- 8. Custom X-axis Labels & Group Separator ---
% Post1 / Post2 labels
text(1, -4, 'Post1', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 18, 'FontName', 'Arial', ...
    'Clipping', 'off');

text(2, -4, 'Post2', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 18, 'FontName', 'Arial', ...
    'Clipping', 'off');

text(4, -4, 'Post1', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 18, 'FontName', 'Arial', ...
    'Clipping', 'off');

text(5, -4, 'Post2', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 18, 'FontName', 'Arial', ...
    'Clipping', 'off');

% Group labels
text(1.5, -12, {'Reactivation'; 'group'}, ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 12, 'FontName', 'Arial', ...
    'Clipping', 'off');

text(4.5, -12, {'Control'; 'group'}, ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 12, 'FontName', 'Arial', ...
    'Clipping', 'off');

% Vertical separator between groups
plot([3, 3], [0, -18], 'k-', ...
    'LineWidth', 2, ...
    'Clipping', 'off');

hold off;

% --- 9. Export (optional) ---
% exportgraphics(gcf, 'Fig_3e_with_subjects.png', 'Resolution', 600);
% exportgraphics(gcf, 'Fig_3e_with_subjects.pdf', 'ContentType', 'vector');
