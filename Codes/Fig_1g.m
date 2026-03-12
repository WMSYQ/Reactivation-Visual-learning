% =========================================================================
% Figure 1g: Generalization Index (%)
% =========================================================================

% Load generalization data and standard errors
load('Fig_1g.mat', 'Generalization_Index', 'SE');

% --- 1. Parameter Setup & Color Definition ---
x = [1, 2];

% Post1 Colors (Blue theme)
faceColor1 = [0.60, 0.74, 0.86]; % Light blue fill
edgeColor1 = [0.33, 0.55, 0.78]; % Dark blue edge

% Post2 Colors (Orange theme)
faceColor2 = [0.93, 0.64, 0.45]; % Light orange fill
edgeColor2 = [0.89, 0.42, 0.13]; % Dark orange edge

% Initialize figure window
figure('Name', 'Figure 1g', 'Position', [600, 100, 350, 450], 'Color', 'w');
hold on;

% --- 2. Plot Bars with Independent Edge and Face Colors ---
bar_width = 0.4; % Bar thickness

% Plot Post1 Bar
b1 = bar(1, Generalization_Index(1), bar_width); 
b1.FaceColor = faceColor1;
b1.EdgeColor = edgeColor1;
b1.LineWidth = 3.5; % Thicken edges for better contrast

% Plot Post2 Bar
b2 = bar(2, Generalization_Index(2), bar_width);
b2.FaceColor = faceColor2;
b2.EdgeColor = edgeColor2;
b2.LineWidth = 3.5;

% --- 3. Plot Reference Line ---
% Draw a dashed horizontal baseline at y = 100% (theoretical maximum)
yline(100, '--', 'Color', [0.55, 0.55, 0.55], 'LineWidth', 2.5);

% --- 4. Plot Error Bars ---
SE_lower = SE; 
SE_upper = SE; 

% Plot error bars above the reference line
errorbar(x, Generalization_Index, SE_lower, SE_upper, 'k', 'LineStyle', 'none', ...
    'LineWidth', 2.5, 'CapSize', 6, 'Color', [0.35, 0.35, 0.35]);

% --- 5. Add Significance Stars ---
star_y_pos = 105; % Y-axis position for the stars

text(1, star_y_pos, '***', 'HorizontalAlignment', 'center', ...
    'FontSize', 22, 'FontWeight', 'bold');
text(2, star_y_pos, '***', 'HorizontalAlignment', 'center', ...
    'FontSize', 22, 'FontWeight', 'bold');

% --- 6. Figure Formatting & Aesthetics ---
ylabel('Generalization (%)', 'FontSize', 22, 'FontName', 'Arial');

% Set X-axis limits and labels with padding
xlim([0.3 2.7]);
set(gca, 'XTick', [1 2], 'XTickLabel', {'Post1', 'Post2'}, ...
    'FontSize', 18, 'FontName', 'Arial');

% Set Y-axis limits and ticks
ylim([0 115]); 
yticks(0:20:100);

% Clean up axes (Box off, outward ticks, no X-axis tick lines)
box off;
set(gca, 'LineWidth', 2, 'TickDir', 'out', 'TickLength', [0.02 0.02]);

% Remove small tick lines on the X-axis for a cleaner look
ax = gca;
ax.XAxis.TickLength = [0 0];

hold off;