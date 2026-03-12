% =========================================================================
% Figure 4d: Mahalanobis Distance
% Layout: 4x8 Grid displaying pairwise orientation comparisons for EVC & IPS
% =========================================================================

% Load distance data
load('Fig_4d.mat');

% --- 1. Parameter Setup ---
% Define orientation labels
angles = {'0°', '30°', '60°', '90°'};

% Initialize matrices to store P-values for both ROIs
P12_EVC = zeros(4, 4); P13_EVC = zeros(4, 4);
P12_IPS = zeros(4, 4); P13_IPS = zeros(4, 4);

% Create a widened figure to accommodate the side-by-side 4x8 layout
figure('Name', 'Figure 4d', 'Position', [50, 50, 1600, 800], 'Color', 'w'); 

% Configure independent Y-axis limits for EVC and IPS
ylim_EVC = [0.35, 0.575];
ylim_IPS = [0.30, 0.420];

% --- 2. Main Plotting Loop ---
for x = 1:4
    for y = 1:4
        if y < x
            % -------------------------------------------------------------
            % Left Panel: EVC (Occupies columns 1-4 of the 4x8 grid)
            % -------------------------------------------------------------
            subplot(4, 8, 8*(x-1) + y); 
            
            data_Pre   = squeeze(MEAN_Distance_EVC_Pre(x,y,:));
            data_Post1 = squeeze(MEAN_Distance_EVC_Post1(x,y,:));
            data_Post2 = squeeze(MEAN_Distance_EVC_Post2(x,y,:));
            
            % Plot bars and retrieve P-values
            [P12_EVC(x,y), P13_EVC(x,y)] = my_Plot_Three_bars_with_Sig(data_Pre, data_Post1, data_Post2, ylim_EVC);
            
            % Clean subplot title (e.g., 0° ↔ 30°)
            title(sprintf('%s \x2194 %s', angles{y}, angles{x}), 'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Arial');
            
            % -------------------------------------------------------------
            % Right Panel: IPS (Occupies columns 5-8 of the 4x8 grid)
            % -------------------------------------------------------------
            subplot(4, 8, 8*(x-1) + (y+4)); % Shift column index by +4
            
            data_Pre_IPS   = squeeze(MEAN_Distance_IPS_Pre(x,y,:));
            data_Post1_IPS = squeeze(MEAN_Distance_IPS_Post1(x,y,:));
            data_Post2_IPS = squeeze(MEAN_Distance_IPS_Post2(x,y,:));
            
            % Plot bars and retrieve P-values
            [P12_IPS(x,y), P13_IPS(x,y)] = my_Plot_Three_bars_with_Sig(data_Pre_IPS, data_Post1_IPS, data_Post2_IPS, ylim_IPS);
            
            % Clean subplot title
            title(sprintf('%s \x2194 %s', angles{y}, angles{x}), 'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Arial');
        end
    end
end

% --- 3. Global ROI Titles (Invisible Axes Technique) ---
% Create an invisible axis for the left section and add 'EVC' title
axes('Position', [0.10, 0.92, 0.35, 0.05], 'Visible', 'off');
text(0.5, 0.5, 'EVC', 'FontSize', 28, 'FontWeight', 'bold', 'FontName', 'Arial', 'HorizontalAlignment', 'center');

% Create an invisible axis for the right section and add 'IPS' title
axes('Position', [0.55, 0.92, 0.35, 0.05], 'Visible', 'off');
text(0.5, 0.5, 'IPS', 'FontSize', 28, 'FontWeight', 'bold', 'FontName', 'Arial', 'HorizontalAlignment', 'center');


% =========================================================================
% Custom Functions
% =========================================================================

function [p12, p13] = my_Plot_Three_bars_with_Sig(data_Pre, data_Post1, data_Post2, y_limits)
    % MY_PLOT_THREE_BARS_WITH_SIG Custom bar plotting function with significance stars.
    % Utilizes dynamic base values to accommodate varying Y-axis limits.
    
    % --- 1. Data Structuring and Statistics ---
    data = [data_Pre(:), data_Post1(:), data_Post2(:)]; 
    n_sample = size(data, 1);
    
    mean_data = mean(data, 1);
    error_values = std(data, 0, 1) / sqrt(n_sample); 
    
    % Paired t-tests (Left-tailed)
    [~, p12] = ttest(data(:,1), data(:,2), 'Tail', 'left');
    [~, p13] = ttest(data(:,1), data(:,3), 'Tail', 'left');
    
    % --- 2. Color Definition ---
    color1 = [127, 127, 127] / 255;  % Gray (Pre)
    color2 = [91, 155, 213] / 255;   % Blue (Post1)
    color3 = [255, 102, 0] / 255;    % Orange (Post2)
    
    % --- 3. Plot Bars ---
    % Anchor the bottom of the bars dynamically using y_limits(1)
    b = bar(1:3, mean_data, 'BarWidth', 0.6, 'LineStyle', 'none', 'BaseValue', y_limits(1));
    hold on;
    
    b.FaceColor = 'flat';
    b.CData(1,:) = color1;
    b.CData(2,:) = color2;
    b.CData(3,:) = color3;
    
    % --- 4. Plot Error Bars ---
    errorbar(1:3, mean_data, error_values, 'k', 'LineStyle', 'none',...
             'LineWidth', 1.5, 'CapSize', 6, 'Color', [0.2 0.2 0.2]);
             
    % --- 5. Add Significance Markers ---
    % Dynamically calculate star height: 5% of the total Y-axis span above the error bar
    star_offset = (y_limits(2) - y_limits(1)) * 0.05;  
    font_size = 18;                     
    
    % Marker for Post1 (p12)
    star1 = get_star_string(p12);
    if ~isempty(star1)
        text(2, mean_data(2) + error_values(2) + star_offset, star1,...
            'FontSize', font_size, 'HorizontalAlignment', 'center', 'Color', color2);
    end
    
    % Marker for Post2 (p13)
    star2 = get_star_string(p13);
    if ~isempty(star2)
        text(3, mean_data(3) + error_values(3) + star_offset, star2,...
            'FontSize', font_size, 'HorizontalAlignment', 'center', 'Color', color3);
    end
    
    % --- 6. Axes Formatting and Aesthetics ---
    set(gca, 'XTick', 1:3, 'XTickLabel', {'Pre', 'Post1', 'Post2'},...
             'FontSize', 12, 'LineWidth', 1.2, 'Box', 'off', 'TickDir', 'out');
             
    % Apply provided Y-axis limits
    ylim(y_limits);
    
    set(gcf, 'Color', 'white');
    set(gca, 'Color', 'white');
    
    hold off;
end

function star = get_star_string(p)
    % GET_STAR_STRING Helper function to convert p-values to significance stars.
    if p < 0.001
        star = '***';
    elseif p < 0.01
        star = '**';
    elseif p < 0.05
        star = '*';
    else
        star = '';
    end
end