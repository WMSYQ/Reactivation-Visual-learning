% =========================================================================
% Figure 3d: Behavioral Improvement by Group and Direction
% =========================================================================

% Load improvement data and standard errors
load('Fig_3d.mat');

% --- 1. Parameter Setup & Color Definition ---
% Define X-axis positions (Skipping position 3 creates a visual gap between groups)
x_pos = [1, 2, 4, 5]; 

% Define custom RGB colors
c_light_blue = [157, 195, 230] / 255; % Light Blue (Post1, Reactivation)
c_dark_blue  = [46, 117, 182] / 255;  % Dark Blue (Post2, Reactivation)
c_light_gray = [127, 127, 127] / 255; % Light Gray (Post1, Control)
c_dark_gray  = [59, 56, 56] / 255;    % Dark Gray (Post2, Control)
c_err        = [89, 89, 89] / 255;    % Dark Gray for error bars

% Initialize figure window
figure('Name', 'Figure 3d', 'Position', [100, 100, 600, 450], 'Color', 'w');
hold on;

% --- 2. Plot Grouped Bar Chart ---
b = bar(x_pos, Improvement, 'grouped', 'BarWidth', 0.8);

% Enable independent coloring for each bar face and remove default edges
b(1).EdgeColor = 'none'; b(1).FaceColor = 'flat';
b(2).EdgeColor = 'none'; b(2).FaceColor = 'flat';

% Assign colors for Post1 (Left bars of each pair)
% First two bars: Light Blue (Reactivation); Last two bars: Light Gray (Control)
b(1).CData(1:2, :) = repmat(c_light_blue, 2, 1);
b(1).CData(3:4, :) = repmat(c_light_gray, 2, 1);

% Assign colors for Post2 (Right bars of each pair)
% First two bars: Dark Blue (Reactivation); Last two bars: Dark Gray (Control)
b(2).CData(1:2, :) = repmat(c_dark_blue, 2, 1);
b(2).CData(3:4, :) = repmat(c_dark_gray, 2, 1);

% --- 3. Plot Error Bars ---
for i = 1:2
    x_bar = b(i).XEndPoints;
    errorbar(x_bar, Improvement(:,i), SE(:,i), 'Color', c_err, 'LineStyle', 'none', ...
        'LineWidth', 1.5, 'CapSize', 4);
end

% --- 4. Axes Formatting & Aesthetics ---
ylabel('Improvement (%)', 'FontSize', 22, 'FontName', 'Arial');

% Set Y-axis limits and ticks
ylim([0 60]);
yticks(0:10:60);

% Set continuous X-axis range and primary tick labels
xlim([0 6]); 
xticks(x_pos);
xticklabels({'0°', '90°', '0°', '90°'});

% Clean up axes aesthetics
set(gca, 'LineWidth', 1.5, 'TickDir', 'out', 'FontSize', 18, 'FontName', 'Arial');
box off;

% Hide X-axis tick marks for a cleaner baseline
ax = gca;
ax.XAxis.TickLength = [0 0];

% Add primary group labels below the X-axis
text(1.5, -6, 'Reactivation group', 'HorizontalAlignment', 'center', 'FontSize', 20, 'FontName', 'Arial');
text(4.5, -6, 'Control group', 'HorizontalAlignment', 'center', 'FontSize', 20, 'FontName', 'Arial');

% --- 5. Custom Legend Construction ---
% Coordinates for custom legend placement
lgd_x = 4.2; 
lgd_y1 = 56;
lgd_y2 = 50;

% Row 1: Post1 Legend (Light Blue / Light Gray)
scatter(lgd_x, lgd_y1, 160, 's', 'filled', 'MarkerFaceColor', c_light_blue);
text(lgd_x + 0.25, lgd_y1, '/', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
scatter(lgd_x + 0.5, lgd_y1, 160, 's', 'filled', 'MarkerFaceColor', c_light_gray);
text(lgd_x + 0.7, lgd_y1, 'Post1', 'FontSize', 18, 'FontName', 'Arial', 'VerticalAlignment', 'middle');

% Row 2: Post2 Legend (Dark Blue / Dark Gray)
scatter(lgd_x, lgd_y2, 160, 's', 'filled', 'MarkerFaceColor', c_dark_blue);
text(lgd_x + 0.25, lgd_y2, '/', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
scatter(lgd_x + 0.5, lgd_y2, 160, 's', 'filled', 'MarkerFaceColor', c_dark_gray);
text(lgd_x + 0.7, lgd_y2, 'Post2', 'FontSize', 18, 'FontName', 'Arial', 'VerticalAlignment', 'middle');

hold off;