% =========================================================================
% Behavioral accuracy in MEG
% Reactivation group and Control group shown side-by-side
% Data format:
%   rows    = Pre, Post1, Post2
%   columns = 0°, 30°, 60°, 90°
% =========================================================================

% clear; clc;

%% ===================== 1. Input data =====================
load("Fig_S6.mat");

%% ===================== 2. Color definition =====================
% Use the right four colors from your palette, ordered from dark to light
% 0° darkest -> 90° lightest

% c0  = [25, 74, 122]   / 255;   % #194A7A
% c30 = [71, 111, 149]  / 255;   % #476F95
% c60 = [117, 147, 175] / 255;   % #7593AF
% c90 = [163, 183, 202] / 255;   % #A3B7CA
% 
% bar_colors = [c0; c30; c60; c90];
% err_color  = [0.35, 0.35, 0.35];

% --- Colors sampled from the reference figure ---
c0  = [70,  121, 167] / 255;  % 0°  — #4679A7
c30 = [85,  145, 199] / 255;  % 30° — #5591C7
c60 = [132, 174, 220] / 255;  % 60° — #84AEDC
c90 = [184, 205, 232] / 255;  % 90° — #B8CDE8

bar_colors = [c0; c30; c60; c90];
% Keep the original error-bar color
err_color = [0.35, 0.35, 0.35];

%% ===================== 3. Figure setup =====================
figure('Name', 'MEG behavioral accuracy', ...
    'Position', [100, 100, 1100, 420], ...
    'Color', 'w');

t = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

group_labels = {'Pre', 'Post1', 'Post2'};
dir_labels   = {'0°', '30°', '60°', '90°'};

all_acc  = {Acc_react, Acc_ctrl};
all_se   = {SE_react,  SE_ctrl};
xlabels2 = {'Reactivation group', 'Control group'};

%% ===================== 4. Plot two panels =====================
for k = 1:2

    nexttile;
    hold on;

    data = all_acc{k};   % 3 x 4
    se   = all_se{k};    % 3 x 4

    % Grouped bar plot
    b = bar(data, 'grouped', 'BarWidth', 0.82);

    % Color each direction
    for i = 1:4
        b(i).FaceColor = bar_colors(i, :);
        b(i).EdgeColor = 'none';
    end

    % % Reference line: target accuracy of 75%
    % % Draw after bars so the line remains visible over them,
    % % but before error bars so the error bars stay on top.
    % yline(75, ':', ...
    %     'Color', [0.35, 0.35, 0.35], ...
    %     'LineWidth', 2, ...
    %     'HandleVisibility', 'off');

    % Error bars
    for i = 1:4
        x = b(i).XEndPoints;
        errorbar(x, data(:, i), se(:, i), ...
            'LineStyle', 'none', ...
            'Color', err_color, ...
            'LineWidth', 1.5, ...
            'CapSize', 5);
    end

    % Axis formatting
    xlim([0.5 3.5]);
    ylim([0 90]);
    yticks(0:10:90);
    xticks(1:3);
    xticklabels(group_labels);

    set(gca, 'LineWidth', 1.5, ...
        'TickDir', 'out', ...
        'TickLength', [0.015 0.015], ...
        'FontSize', 18, ...
        'FontName', 'Arial');
    box off;

    % Remove small tick marks on x-axis
    ax = gca;
    ax.XAxis.TickLength = [0 0];

    % Y label only on the left panel
    if k == 1
        ylabel('Accuracy (%)', 'FontSize', 24, 'FontName', 'Arial');
    else
        set(gca, 'YTickLabel', []);
    end

    % Group label below each panel
    xlabel(xlabels2{k}, 'FontSize', 22, 'FontName', 'Arial');

    % Legend only once, on the right panel
    if k == 2
        lgd = legend(b, dir_labels, ...
            'Location', 'eastoutside', ...
            'Box', 'off');
        lgd.FontSize = 18;
        lgd.ItemTokenSize = [18, 18];
    end

    hold off;
end