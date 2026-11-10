% =========================================================================
% Figure 1f: Behavioral Improvement by Group and Direction
% Add individual subject data as beeswarm scatter
% =========================================================================

% Load data
% MPI: 2 x 4
%   Row 1 = Post1
%   Row 2 = Post2
%   Col 1 = Reactivation 0°
%   Col 2 = Reactivation 90°
%   Col 3 = Control 0°
%   Col 4 = Control 90°
%
% SE: same organization as MPI
%
% subject_data: 13 x 8
%   Col 1 = Reactivation Post1 0°
%   Col 2 = Reactivation Post1 90°
%   Col 3 = Reactivation Post2 0°
%   Col 4 = Reactivation Post2 90°
%   Col 5 = Control Post1 0°
%   Col 6 = Control Post1 90°
%   Col 7 = Control Post2 0°
%   Col 8 = Control Post2 90°
%   Note: control group has only 11 subjects, so rows 12:13 in cols 5:8 are filler zeros

load('Fig_1f.mat');   % should contain MPI, SE, subject_data

% --- 1. Parameter Setup & Color Definition ---
x_pos = [1, 2, 4, 5];   % leave a gap between groups

c_light_blue = [157, 195, 230] / 255; % Post1, Reactivation
c_dark_blue  = [46, 117, 182] / 255;  % Post2, Reactivation
c_light_gray = [180, 180, 180] / 255;
c_dark_gray  = [120, 120, 120] / 255;
c_err        = [89, 89, 89] / 255;    % Error bars

% Convert MPI and SE into 4 x 2 form for grouped bar plotting
% Row:  React0, React90, Control0, Control90
% Col1: Post1
% Col2: Post2
MPI_plot = MPI';
SE_plot  = SE';

% Initialize figure
figure('Name', 'Figure 1f', 'Position', [100, 100, 600, 450], 'Color', 'w');
hold on;

% --- 2. Plot Grouped Bar Chart ---
b = bar(x_pos, MPI_plot, 'grouped', 'BarWidth', 0.8);

b(1).EdgeColor = 'none'; b(1).FaceColor = 'flat';
b(2).EdgeColor = 'none'; b(2).FaceColor = 'flat';

% Post1 colors
b(1).CData(1:2, :) = repmat(c_light_blue, 2, 1); % Reactivation
b(1).CData(3:4, :) = repmat(c_light_gray, 2, 1); % Control

% Post2 colors
b(2).CData(1:2, :) = repmat(c_dark_blue, 2, 1);  % Reactivation
b(2).CData(3:4, :) = repmat(c_dark_gray, 2, 1);  % Control

% --- 3. Get Bar Centers ---
x1 = b(1).XEndPoints;   % Post1 bars
x2 = b(2).XEndPoints;   % Post2 bars

% Order of actual bar centers on the plot:
% 1 = Reactivation 0° Post1
% 2 = Reactivation 0° Post2
% 3 = Reactivation 90° Post1
% 4 = Reactivation 90° Post2
% 5 = Control 0° Post1
% 6 = Control 0° Post2
% 7 = Control 90° Post1
% 8 = Control 90° Post2
bar_centers = [x1(1), x2(1), x1(2), x2(2), x1(3), x2(3), x1(4), x2(4)];

% --- 4. Reorganize Subject Data to Match Bar Order ---

% Reactivation group: 13 valid subjects
% Original order: [P1_0, P1_90, P2_0, P2_90]
% Reorder to:     [P1_0, P2_0, P1_90, P2_90]
react_data = subject_data(1:13, 1:4);
react_plot = react_data(:, [1, 3, 2, 4]);

% Control group: 15 valid subjects
ctrl_data = subject_data(1:15, 5:8);
ctrl_plot = ctrl_data(:, [1, 3, 2, 4]);

% Combine both groups into a 15 x 8 matrix
% NaN padding ensures missing Reactivation subjects are ignored
plot_data = nan(15, 8);

% Reactivation group: first 13 rows only
plot_data(1:13, 1:4) = react_plot;

% Control group: all 15 rows
plot_data(:, 5:8) = ctrl_plot;

% Match each column to its corresponding bar center
group = repmat(bar_centers, size(plot_data, 1), 1);

% Remove NaN values before plotting
x_swarm = group(:);
y_swarm = plot_data(:);
valid_idx = ~isnan(y_swarm);

% Matching scatter colors for the 8 bars
Scatter_color = [
    c_light_blue;  % React 0 Post1
    c_dark_blue;   % React 0 Post2
    c_light_blue;  % React 90 Post1
    c_dark_blue;   % React 90 Post2
    c_light_gray;  % Ctrl 0 Post1
    c_dark_gray;   % Ctrl 0 Post2
    c_light_gray;  % Ctrl 90 Post1
    c_dark_gray    % Ctrl 90 Post2
];

% Set final y-axis before beeswarm
ylim([0 65]);

% --- 5. Overlay Subject Scatter ---
beeswarm(x_swarm(valid_idx), y_swarm(valid_idx), ...
    'sort_style', 'up', ...
    'use_current_axes', true, ...
    'colormap', Scatter_color, ...
    'MarkerFaceAlpha', 1, ...
    'MarkerEdgeColor', 'white');

hold on;
set(gca, 'SortMethod', 'childorder'); % bars < scatter < error bars

% --- 6. Plot Error Bars ---
for i = 1:2
    x_bar = b(i).XEndPoints;
    errorbar(x_bar, MPI_plot(:, i), SE_plot(:, i), ...
        'Color', c_err, 'LineStyle', 'none', ...
        'LineWidth', 1.5, 'CapSize', 4);
end

% --- 7. Axes Formatting & Aesthetics ---
ylabel('Improvement (%)', 'FontSize', 22, 'FontName', 'Arial');

ylim([-30 60]);
yticks(-30:10:60);

xlim([0 6]);
xticks(x_pos);
xticklabels({'0°', '90°', '0°', '90°'});

set(gca, 'LineWidth', 1.5, 'TickDir', 'out', 'FontSize', 18, 'FontName', 'Arial');
box off;

ax = gca;
ax.XAxis.TickLength = [0 0];

% Group labels: below the individual angle labels
text(1.5, -28, 'Reactivation group', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 20, 'FontName', 'Arial', ...
    'Clipping', 'off');

text(4.5, -28, 'Control group', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 20, 'FontName', 'Arial', ...
    'Clipping', 'off');

% --- 8. Custom Legend Construction ---
lgd_x = 4.2;
lgd_y1 = 56;
lgd_y2 = 50;

% Post1
scatter(lgd_x, lgd_y1, 160, 's', 'filled', 'MarkerFaceColor', c_light_blue);
text(lgd_x + 0.25, lgd_y1, '/', 'FontSize', 18, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center');
scatter(lgd_x + 0.5, lgd_y1, 160, 's', 'filled', 'MarkerFaceColor', c_light_gray);
text(lgd_x + 0.7, lgd_y1, 'Post1', 'FontSize', 18, 'FontName', 'Arial', ...
    'VerticalAlignment', 'middle');

% Post2
scatter(lgd_x, lgd_y2, 160, 's', 'filled', 'MarkerFaceColor', c_dark_blue);
text(lgd_x + 0.25, lgd_y2, '/', 'FontSize', 18, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center');
scatter(lgd_x + 0.5, lgd_y2, 160, 's', 'filled', 'MarkerFaceColor', c_dark_gray);
text(lgd_x + 0.7, lgd_y2, 'Post2', 'FontSize', 18, 'FontName', 'Arial', ...
    'VerticalAlignment', 'middle');

hold off;