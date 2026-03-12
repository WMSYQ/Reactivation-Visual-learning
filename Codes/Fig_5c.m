% =========================================================================
% Figure 5c: Behavioral Thresholds across Directions
% Layout: Grouped bar chart with custom nested significance brackets 
%         and an open-table style X-axis.
% =========================================================================

% Load threshold data and standard errors
% Note: The -90° 'Pre' condition should contain 0 in the dataset to 
% automatically leave a blank space in the grouped bar chart.
load('Fig_5c.mat');

% --- 1. Parameter Setup & Color Definition ---
c_pre   = [127, 127, 127] / 255; % Gray (Pre)
c_post1 = [91, 155, 213] / 255;  % Blue (Post1)
c_post2 = [237, 125, 49] / 255;  % Orange (Post2)

% Initialize widened figure window to accommodate the external legend
figure('Name', 'Figure 5c', 'Position', [100, 100, 800, 500], 'Color', 'w');
hold on;

% --- 2. Plot Grouped Bar Chart and Error Bars ---
b = bar(Threshold, 'grouped', 'BarWidth', 0.85, 'EdgeColor', 'none');
b(1).FaceColor = c_pre;
b(2).FaceColor = c_post1;
b(3).FaceColor = c_post2;

% Plot error bars
for i = 1:3
    x_pos = b(i).XEndPoints;
    errorbar(x_pos, Threshold(:,i), SE(:,i), 'Color', [0.3 0.3 0.3], ...
        'LineStyle', 'none', 'LineWidth', 1.5, 'CapSize', 6);
end

% --- 3. Axes Formatting & Aesthetics ---
xlim([0.4 3.6]);
ylim([0 8.5]);
yticks(0:2:8); 

ylabel('Threshold (°)', 'FontSize', 22, 'FontName', 'Arial');

% --- 4. Open-Table Style X-Axis Labels ---
% Hide default X-axis ticks and labels
set(gca, 'XTick', [], 'XTickLabel', []);

% Manually write sub-labels (Pre, Post1, Post2) under each bar
y_text_pos1 = -0.4;
labels = {'Pre', 'Post1', 'Post2'};
for group = 1:3
    for cond = 1:3
        text(b(cond).XEndPoints(group), y_text_pos1, labels{cond}, ...
            'FontSize', 14, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
    end
end

% Manually write primary group labels (0°, 90°, -90°)
y_text_pos2 = -1.2;
text(1, y_text_pos2, '0°', 'FontSize', 20, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
text(2, y_text_pos2, '90°', 'FontSize', 20, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
text(3, y_text_pos2, '-90°', 'FontSize', 20, 'FontName', 'Arial', 'HorizontalAlignment', 'center');

% Draw vertical separator lines between groups (Leaving bottom open)
plot([1.5 1.5], [0, -1.6], 'k-', 'LineWidth', 1.5, 'Clipping', 'off');
plot([2.5 2.5], [0, -1.6], 'k-', 'LineWidth', 1.5, 'Clipping', 'off');

% --- 5. Global Polish & External Legend ---
box off;
set(gca, 'LineWidth', 2, 'TickDir', 'out', 'TickLength', [0.015 0.015], 'FontSize', 18, 'FontName', 'Arial');

% Add legend outside the plot area
lgd = legend({'Pre', 'Post1', 'Post2'}, 'Location', 'northeastoutside', 'Box', 'off');
lgd.FontSize = 16;
lgd.ItemTokenSize = [20, 18]; 

hold off;