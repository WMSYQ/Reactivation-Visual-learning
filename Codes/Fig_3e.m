% =========================================================================
% Figure 3e: Generalization Index (%) across Reactivation and Control Groups
% =========================================================================

% Load generalization data and standard errors
load("Fig_3e.mat", "Generalization_Index", "SE");

% --- 1. Parameter Setup & Color Definition ---
% X-axis positions for the groups
x_react = [1, 2]; % Reactivation group
x_ctrl  = [4, 5]; % Control group (represented by markers at y=0)

% Post1 Colors (Blue theme)
c_face_p1 = [0.60, 0.74, 0.86]; % Light blue fill
c_edge_p1 = [0.33, 0.55, 0.78]; % Dark blue edge

% Post2 Colors (Orange theme)
c_face_p2 = [0.93, 0.64, 0.45]; % Light orange fill
c_edge_p2 = [0.89, 0.42, 0.13]; % Dark orange edge

c_err = [0.35, 0.35, 0.35];     % Dark gray for error bars

% Initialize figure window
figure('Name', 'Figure 3e', 'Position', [100, 100, 400, 480], 'Color', 'w');
hold on;

% --- 2. Plot Reference Baseline ---
% Draw a dashed horizontal baseline at y = 100% (drawn early to stay in background)
yline(100, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 3);

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

SE_lower = SE;
SE_upper = SE;

errorbar(x_react, Generalization_Index, SE_lower, SE_upper, ...
    'Color', c_err, 'LineStyle', 'none', 'LineWidth', 2.5, 'CapSize', 6);

% --- 5. Plot Control Group Markers ---
% Use red 'x' markers to denote the control group
plot(x_ctrl, [0, 0], 'x', 'Color', [0.75 0.1 0.1], 'MarkerSize', 12, 'LineWidth', 2);

% --- 6. Axes Formatting & Aesthetics ---
ylabel('Generalization (%)', 'FontSize', 22, 'FontName', 'Arial');

% Set Y-axis limits and ticks
ylim([0 108]); 
yticks(0:10:100);
xlim([0 6]);

% Clean up axes aesthetics
ax = gca;
ax.XTick = []; % Hide default X-axis ticks to prepare for custom labels
box off;
set(ax, 'LineWidth', 2.5, 'TickDir', 'out', 'TickLength', [0.02 0.02]);

% --- 7. Custom X-axis Labels & Group Separator ---
% Sub-labels for Post1 / Post2
text(1, -4, 'Post1', 'HorizontalAlignment', 'center', 'FontSize', 18, 'FontName', 'Arial');
text(2, -4, 'Post2', 'HorizontalAlignment', 'center', 'FontSize', 18, 'FontName', 'Arial');
text(4, -4, 'Post1', 'HorizontalAlignment', 'center', 'FontSize', 18, 'FontName', 'Arial');
text(5, -4, 'Post2', 'HorizontalAlignment', 'center', 'FontSize', 18, 'FontName', 'Arial');

% Primary group labels (Using cell arrays for line breaks)
text(1.5, -12, {'Reactivation'; 'group'}, 'HorizontalAlignment', 'center', 'FontSize', 20, 'FontName', 'Arial');
text(4.5, -12, {'Control'; 'group'}, 'HorizontalAlignment', 'center', 'FontSize', 20, 'FontName', 'Arial');

% Draw a vertical separator line extending below the X-axis ('Clipping', 'off' allows drawing outside axes)
plot([3, 3], [0, -18], 'k-', 'LineWidth', 2, 'Clipping', 'off');

hold off;