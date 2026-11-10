
% =========================================================================
% Figure 2c: Four-direction Decoding Accuracy across ROIs
% Two-panel bar plot: EVC (V1-V3) and IPS (IPS1-IPS3)
% =========================================================================


% % EVC: V1, V2, V3
% bar_data_EVC = [];
% bar_errors_EVC = [];
% 
% % IPS: IPS1, IPS2, IPS3
% bar_data_IPS = [];
% bar_errors_IPS = [];


% --- 1. Color Palette ---

% EVC: Blue theme
colors_EVC = [
    167, 181, 219
    68, 114, 196
    55, 93, 161
] / 255;

% IPS: Green theme
colors_IPS = [
    180, 207, 168
    112, 173, 71
    91, 142, 57
] / 255;


% --- 2. Data Preparation ---


roi_names_EVC = {'V1', 'V2', 'V3'};
roi_names_IPS = {'IPS1', 'IPS2', 'IPS3'};

%% 0° vs its neighborhoods
load("Fig_2c_0.mat")

% --- 3. Initialize Figure ---

figure('Name', 'Four-direction Decoding Accuracy', ...
    'Position', [100, 100, 1050, 480], ...
    'Color', 'w');

t = tiledlayout(1, 2, ...
    'TileSpacing', 'compact', ...
    'Padding', 'compact');


% --- 4. EVC Bar Chart ---

ax1 = nexttile;
hold(ax1, 'on');

b1 = bar(ax1, bar_data_EVC, 'grouped');

for i = 1:3
    b1(i).FaceColor = colors_EVC(i, :);
    b1(i).EdgeColor = 'none';

    errorbar(ax1, b1(i).XEndPoints, ...
        bar_data_EVC(:,i), bar_errors_EVC(:,i), ...
        'Color', [0.35, 0.35, 0.35], ...
        'LineStyle', 'none', ...
        'LineWidth', 1.5, ...
        'CapSize', 4);
end

title(ax1, 'EVC (V1, V2, and V3) 0°', ...
    'FontSize', 19, ...
    'FontWeight', 'normal', ...
    'FontName', 'Arial');

ylabel(ax1, 'Decoding accuracy (%)', ...
    'FontSize', 20, 'FontName', 'Arial');

set(ax1, ...
    'XTick', 1:3, ...
    'XTickLabel', roi_names_EVC, ...
    'FontSize', 16, ...
    'FontName', 'Arial', ...
    'LineWidth', 1.5, ...
    'TickDir', 'out', ...
    'TickLength', [0.015, 0.015]);

ylim(ax1, [45 94]);
yticks(ax1, 45:5:90);

box(ax1, 'off');
ax1.XAxis.TickLength = [0 0];

hold(ax1, 'off');


% --- 5. IPS Bar Chart ---

ax2 = nexttile;
hold(ax2, 'on');

b2 = bar(ax2, bar_data_IPS, 'grouped');

for i = 1:3
    b2(i).FaceColor = colors_IPS(i, :);
    b2(i).EdgeColor = 'none';

    errorbar(ax2, b2(i).XEndPoints, ...
        bar_data_IPS(:,i), bar_errors_IPS(:,i), ...
        'Color', [0.35, 0.35, 0.35], ...
        'LineStyle', 'none', ...
        'LineWidth', 1.5, ...
        'CapSize', 4);
end

title(ax2, 'IPS (IPS1, IPS2, and IPS3) 0°', ...
    'FontSize', 19, ...
    'FontWeight', 'normal', ...
    'FontName', 'Arial');

ylabel(ax2, 'Decoding accuracy (%)', ...
    'FontSize', 20, 'FontName', 'Arial');

set(ax2, ...
    'XTick', 1:3, ...
    'XTickLabel', roi_names_IPS, ...
    'FontSize', 16, ...
    'FontName', 'Arial', ...
    'LineWidth', 1.5, ...
    'TickDir', 'out', ...
    'TickLength', [0.015, 0.015]);

ylim(ax2, [45 84]);
yticks(ax2, 45:5:80);

box(ax2, 'off');
ax2.XAxis.TickLength = [0 0];

hold(ax2, 'off');

% --- 6. Individual Legends ---

% EVC Legend (Blue)
lgd1 = legend(ax1, b1, {'Pre', 'Post1', 'Post2'}, ...
    'Location', 'northeast');

lgd1.Box = 'off';
lgd1.FontSize = 13;
lgd1.FontName = 'Arial';
lgd1.ItemTokenSize = [20, 15];

% IPS Legend (Green)
lgd2 = legend(ax2, b2, {'Pre', 'Post1', 'Post2'}, ...
    'Location', 'northeast');

lgd2.Box = 'off';
lgd2.FontSize = 13;
lgd2.FontName = 'Arial';
lgd2.ItemTokenSize = [20, 15];


% --- 7. Export (optional) ---

% exportgraphics(gcf, 'Figure_2b_EVC_IPS.png', 'Resolution', 600);
% exportgraphics(gcf, 'Figure_2b_EVC_IPS.pdf', 'ContentType', 'vector');


%% 90° vs its neighborhoods
load("Fig_2c_90.mat")

% --- 3. Initialize Figure ---

figure('Name', 'Four-direction Decoding Accuracy', ...
    'Position', [100, 100, 1050, 480], ...
    'Color', 'w');

t = tiledlayout(1, 2, ...
    'TileSpacing', 'compact', ...
    'Padding', 'compact');


% --- 4. EVC Bar Chart ---

ax1 = nexttile;
hold(ax1, 'on');

b1 = bar(ax1, bar_data_EVC, 'grouped');

for i = 1:3
    b1(i).FaceColor = colors_EVC(i, :);
    b1(i).EdgeColor = 'none';

    errorbar(ax1, b1(i).XEndPoints, ...
        bar_data_EVC(:,i), bar_errors_EVC(:,i), ...
        'Color', [0.35, 0.35, 0.35], ...
        'LineStyle', 'none', ...
        'LineWidth', 1.5, ...
        'CapSize', 4);
end

title(ax1, 'EVC (V1, V2, and V3) 90°', ...
    'FontSize', 19, ...
    'FontWeight', 'normal', ...
    'FontName', 'Arial');

ylabel(ax1, 'Decoding accuracy (%)', ...
    'FontSize', 20, 'FontName', 'Arial');

set(ax1, ...
    'XTick', 1:3, ...
    'XTickLabel', roi_names_EVC, ...
    'FontSize', 16, ...
    'FontName', 'Arial', ...
    'LineWidth', 1.5, ...
    'TickDir', 'out', ...
    'TickLength', [0.015, 0.015]);

ylim(ax1, [45 94]);
yticks(ax1, 45:5:90);

box(ax1, 'off');
ax1.XAxis.TickLength = [0 0];

hold(ax1, 'off');


% --- 5. IPS Bar Chart ---

ax2 = nexttile;
hold(ax2, 'on');

b2 = bar(ax2, bar_data_IPS, 'grouped');

for i = 1:3
    b2(i).FaceColor = colors_IPS(i, :);
    b2(i).EdgeColor = 'none';

    errorbar(ax2, b2(i).XEndPoints, ...
        bar_data_IPS(:,i), bar_errors_IPS(:,i), ...
        'Color', [0.35, 0.35, 0.35], ...
        'LineStyle', 'none', ...
        'LineWidth', 1.5, ...
        'CapSize', 4);
end

title(ax2, 'IPS (IPS1, IPS2, and IPS3) 90°', ...
    'FontSize', 19, ...
    'FontWeight', 'normal', ...
    'FontName', 'Arial');

ylabel(ax2, 'Decoding accuracy (%)', ...
    'FontSize', 20, 'FontName', 'Arial');

set(ax2, ...
    'XTick', 1:3, ...
    'XTickLabel', roi_names_IPS, ...
    'FontSize', 16, ...
    'FontName', 'Arial', ...
    'LineWidth', 1.5, ...
    'TickDir', 'out', ...
    'TickLength', [0.015, 0.015]);

ylim(ax2, [45 84]);
yticks(ax2, 45:5:80);

box(ax2, 'off');
ax2.XAxis.TickLength = [0 0];

hold(ax2, 'off');

% --- 6. Individual Legends ---

% EVC Legend (Blue)
lgd1 = legend(ax1, b1, {'Pre', 'Post1', 'Post2'}, ...
    'Location', 'northeast');

lgd1.Box = 'off';
lgd1.FontSize = 13;
lgd1.FontName = 'Arial';
lgd1.ItemTokenSize = [20, 15];

% IPS Legend (Green)
lgd2 = legend(ax2, b2, {'Pre', 'Post1', 'Post2'}, ...
    'Location', 'northeast');

lgd2.Box = 'off';
lgd2.FontSize = 13;
lgd2.FontName = 'Arial';
lgd2.ItemTokenSize = [20, 15];


% --- 7. Export (optional) ---

% exportgraphics(gcf, 'Figure_2b_EVC_IPS.png', 'Resolution', 600);
% exportgraphics(gcf, 'Figure_2b_EVC_IPS.pdf', 'ContentType', 'vector');
