% =========================================================================
% Figure 2b: Decoding Accuracy across ROIs (3x4 Panel Plot)
% Layout: 3 Rows (Different ROI groups) x 4 Columns (1 Bar + 3 Line charts)
% =========================================================================

load('Fig_2b.mat');
% --- 1. Define Color Palette (Grouped by Row) ---
% Row 1 Colors (Blue theme)
color1 = [167, 181, 219] / 255; % Pre
color2 = [68, 114, 196] / 255;  % Post1
color3 = [55, 93, 161] / 255;   % Post2

% Row 2 Colors (Orange theme)
color4 = [244, 185, 164] / 255; 
color5 = [237, 125, 49] / 255; 
color6 = [196, 102, 39] / 255;

% Row 3 Colors (Green theme)
color7 = [180, 207, 168] / 255; 
color8 = [112, 173, 71] / 255; 
color9 = [91, 142, 57] / 255;

% Combine colors into a cell array for batch processing
colors_all = {
    [color1; color2; color3], ... 
    [color4; color5; color6], ... 
    [color7; color8; color9]      
};

% --- 2. Data Preparation & Structuring ---
x_line = [50, 100, 150, 200]; % X-axis values for line charts

% Pack bar chart data and errors into cell arrays
bar_data = {
    ACC_4_way_200Voxels(1:3, :);
    ACC_4_way_200Voxels(4:6, :); 
    ACC_4_way_200Voxels(7:9, :); 
};
bar_errors = {
    SE_4_way_200Voxels(1:3, :);   
    SE_4_way_200Voxels(4:6, :);   
    SE_4_way_200Voxels(7:9, :);   
};

% Pack line chart data into a 3x3 cell array
line_data = {
    ACC_V1,   ACC_V2,   ACC_V3;   
    ACC_MT,   ACC_V3A,  ACC_IPS0; 
    ACC_IPS1, ACC_IPS2, ACC_IPS3  
};

% Define ROI names for each row
roi_names = {
    {'V1', 'V2', 'V3'}, ...
    {'MT', 'V3A', 'IPS0'}, ...
    {'IPS1', 'IPS2', 'IPS3'}
};

% --- 3. Axis Limits and Ticks Configuration ---
% Y-axis limits and ticks for Bar charts (per row)
bar_ylims  = {[20 70], [20 50], [20 45]};
bar_yticks = {20:10:70, 20:10:50, 20:10:40}; 

% Y-axis limits and ticks for Line charts (per row)
line_ylims  = {[30 70], [20 45], [20 40]};
line_yticks = {30:10:70, 20:10:40, 20:10:40}; 

% --- 4. Main Plotting Loop ---
% Create a global figure window
figure('Name', 'Figure 2b', 'Position', [100, 50, 1400, 1000], 'Color', 'w');
t = tiledlayout(3, 4, 'TileSpacing', 'compact', 'Padding', 'compact');

for row = 1:3
    % Extract colors for the current row
    c_pre   = colors_all{row}(1, :);
    c_post1 = colors_all{row}(2, :);
    c_post2 = colors_all{row}(3, :);
    
    % ---------------------------------------------------------------------
    % Column 1: Plot Grouped Bar Chart
    % ---------------------------------------------------------------------
    nexttile;
    hold on;
    
    data_bar = bar_data{row};
    errors_bar = bar_errors{row};
    
    % Plot bars
    b = bar(data_bar, 'grouped');
    b(1).FaceColor = c_pre;   b(1).EdgeColor = 'none';
    b(2).FaceColor = c_post1; b(2).EdgeColor = 'none';
    b(3).FaceColor = c_post2; b(3).EdgeColor = 'none';
    
    % Plot error bars
    for i = 1:3
        errorbar(b(i).XEndPoints, data_bar(:,i), errors_bar(:,i), 'k', 'LineStyle', 'none', ...
            'LineWidth', 1.5, 'CapSize', 4, 'Color', [0.35, 0.35, 0.35]);
    end
    
    ylabel('Decoding accuracy (%)', 'FontSize', 20, 'FontName', 'Arial');
    set(gca, 'XTick', 1:3, 'XTickLabel', roi_names{row}, 'FontSize', 16, 'FontName', 'Arial');
    
    % Apply row-specific Y-axis configuration for bar charts
    ylim(bar_ylims{row}); 
    yticks(bar_yticks{row});
    
    % Aesthetics
    box off; 
    set(gca, 'LineWidth', 1.5, 'TickDir', 'out', 'TickLength', [0.015, 0.015]);
    
    % Remove X-axis tick marks
    ax_bar = gca;
    ax_bar.XAxis.TickLength = [0, 0];
    hold off;
    
    % ---------------------------------------------------------------------
    % Columns 2-4: Plot Line Charts
    % ---------------------------------------------------------------------
    for col = 1:3
        nexttile;
        hold on;
        
        current_data = line_data{row, col};
        
        p1 = plot(x_line, current_data(1,:), '-o', 'Color', c_pre,   'MarkerFaceColor', c_pre,   'LineWidth', 2, 'MarkerSize', 5);
        p2 = plot(x_line, current_data(2,:), '-o', 'Color', c_post1, 'MarkerFaceColor', c_post1, 'LineWidth', 2, 'MarkerSize', 5);
        p3 = plot(x_line, current_data(3,:), '-o', 'Color', c_post2, 'MarkerFaceColor', c_post2, 'LineWidth', 2, 'MarkerSize', 5);
        
        title(roi_names{row}{col}, 'FontSize', 20, 'FontWeight', 'normal', 'FontName', 'Arial');
        
        % Only display Y-axis label on the first line chart of each row
        if col == 1
            ylabel('Decoding accuracy (%)', 'FontSize', 20, 'FontName', 'Arial');
        end
        
        xlim([25 225]); 
        xticks([50 100 150 200]);
        
        % Apply row-specific Y-axis configuration for line charts
        ylim(line_ylims{row});  
        yticks(line_yticks{row});
        
        % Aesthetics
        box off;
        set(gca, 'LineWidth', 1.5, 'TickDir', 'out', 'TickLength', [0.02, 0.02], 'FontSize', 16, 'FontName', 'Arial');
        
        % Remove X-axis tick marks
        ax_line = gca;
        ax_line.XAxis.TickLength = [0, 0];
        
        % Hide Y-axis tick labels for inner subplots to keep the layout clean
        if col > 1
            set(gca, 'YTickLabel', []);
        end
        
        % Add legend only to the rightmost subplot
        if col == 3
            lgd = legend([p1, p2, p3], {'Pre', 'Post1', 'Post2'}, 'Location', 'eastoutside');
            legend boxoff; 
            lgd.FontSize = 16; 
            lgd.ItemTokenSize = [30, 18];
        end
        hold off;
    end
end