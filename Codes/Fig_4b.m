% =========================================================================
% Figure 4b: Channel Variance and Clustered Noise Covariance Matrices
% =========================================================================

% Load covariance matrix data
load('Fig_4b.mat');

% --- 1. Parameter Setup & Color Definition ---
color1 = [127, 127, 127] / 255; % Gray (Pre)
color2 = [91, 155, 213] / 255;  % Blue (Post1)
color3 = [255, 102, 0] / 255;   % Orange (Post2)

% Combine colors into a unified palette matrix
Color_RGB = [color1; color2; color3];

% --- 2. Channel Selection (Variance Masking) ---
% Extract diagonal values (variance) from the original covariance matrices
diag_values_Pre   = diag(Mean_Matrix_Pre);
diag_values_Post1 = diag(Mean_Matrix_Post1);
diag_values_Post2 = diag(Mean_Matrix_Post2);

% Create a mask to exclude channels with near-zero covariance in the 'Pre' condition
valid_channels = diag_values_Pre > 5e-24; 

% Select valid data for beeswarm plotting
Selected_1 = horzcat(diag_values_Pre(valid_channels), diag_values_Post1(valid_channels));
Selected_2 = horzcat(diag_values_Pre(valid_channels), diag_values_Post2(valid_channels));

% =========================================================================
% Part 1: Plot Diagonal Values (Channel Variance Beeswarm Plots)
% =========================================================================

% --- Figure A: Compare Pre vs Post1 ---
figure('Name', 'Figure 4b - Variance (Pre vs Post1)', 'Color', 'white');
my_Plot_Bar_with_Beeswarm_and_Line(Selected_1, 1:2, Color_RGB([1, 2], :), Color_RGB([1, 2], :), Color_RGB(2, :));

title('Channel Variance: Pre vs Post1', 'FontName', 'Arial', 'FontSize', 16);
xticks([1 2]);
xticklabels({'Pre', 'Post1'});
ylim([0 4e-23]);

% --- Figure B: Compare Pre vs Post2 ---
figure('Name', 'Figure 4b - Variance (Pre vs Post2)', 'Color', 'white');
my_Plot_Bar_with_Beeswarm_and_Line(Selected_2, 1:2, Color_RGB([1, 3], :), Color_RGB([1, 3], :), Color_RGB(3, :));

title('Channel Variance: Pre vs Post2', 'FontName', 'Arial', 'FontSize', 16);
xticks([1 2]);
xticklabels({'Pre', 'Post2'});
ylim([0 4e-23]);


% =========================================================================
% Part 2: Compare Post and Pre using Clustered Covariance Matrices
% =========================================================================

% Subset the original matrices using the valid channel index 
% (e.g., reducing from 72x72 down to the valid dimensions)
New_Mean_Matrix_Pre   = Mean_Matrix_Pre(valid_channels, valid_channels);
New_Mean_Matrix_Post1 = Mean_Matrix_Post1(valid_channels, valid_channels);
New_Mean_Matrix_Post2 = Mean_Matrix_Post2(valid_channels, valid_channels);

% Calculate the difference matrices (Post - Pre) using the pruned matrices
Diff_Post1 = New_Mean_Matrix_Post1 - New_Mean_Matrix_Pre;
Diff_Post2 = New_Mean_Matrix_Post2 - New_Mean_Matrix_Pre;

% Apply symmetric clustering and sorting
n_cluster = 5; % Number of clusters for hierarchical clustering
[Diff_1_sorted, ~] = symmetric_cluster_sort(Diff_Post1, n_cluster);
[Diff_2_sorted, ~] = symmetric_cluster_sort(Diff_Post2, n_cluster);

% --- Figure C: Plot the Clustered Difference Matrices ---
figure('Name', 'Figure 4b - Covariance Matrices', 'Color', 'white', 'Position', [100, 100, 900, 400]);

% Subplot 1: Post1 - Pre
subplot(1, 2, 1);
imagesc(Diff_1_sorted);
colorbar;
colormap(jet);
title('Noise Cov Matrix (Post1 - Pre)', 'FontSize', 14);
xlabel('Occipital Channel', 'FontSize', 12);
ylabel('Occipital Channel', 'FontSize', 12);
xticks(10:10:40);
yticks(10:10:40);
set(gca, 'CLim', [-5e-24, 1.4e-23], 'FontName', 'Arial', 'FontSize', 12, 'Color', 'white');

% Subplot 2: Post2 - Pre
subplot(1, 2, 2);
imagesc(Diff_2_sorted);
colorbar;
colormap(jet);
title('Noise Cov Matrix (Post2 - Pre)', 'FontSize', 14);
xlabel('Occipital Channel', 'FontSize', 12);
ylabel('Occipital Channel', 'FontSize', 12);
xticks(10:10:40);
yticks(10:10:40);
set(gca, 'CLim', [-5e-24, 1e-23], 'FontName', 'Arial', 'FontSize', 12, 'Color', 'white');


% =========================================================================
% Custom Functions
% =========================================================================

function [M_sorted, order] = symmetric_cluster_sort(M, n_clusters)
    % SYMMETRIC_CLUSTER_SORT Clusters and sorts a symmetric matrix.
    % Uses hierarchical clustering (average linkage) to group highly 
    % correlated channels together for better visualization.
    
    if ~isequal(M, M')
        error('Input matrix must be symmetric.');
    end
    
    n_elements = size(M, 1);
    
    % Hierarchical clustering (using average linkage)
    linkage_matrix = linkage(squareform(pdist(M)), 'average'); 
    idx = cluster(linkage_matrix, 'maxclust', n_clusters);
    
    class_means = zeros(n_clusters, 1);
    for k = 1:n_clusters
        class_members = (idx == k);
        class_means(k) = mean(diag(M(class_members, class_members)));
    end
    
    [~, class_order] = sort(class_means, 'descend');
    
    order = [];
    for k = 1:n_clusters
        current_class = class_order(k);
        class_members = find(idx == current_class);
        
        class_diag = diag(M(class_members, class_members));
        [~, in_class_order] = sort(class_diag, 'descend');
        class_order_optimized = class_members(in_class_order);
        
        order = [order; class_order_optimized(:)];
    end
    
    M_sorted = M(order, order);
end


function my_Plot_Bar_with_Beeswarm_and_Line(data_input, group_input, Scatter_color, Bar_color, Line_Color)
    % MY_PLOT_BAR_WITH_BEESWARM_AND_LINE Generates a custom beeswarm plot 
    % overlaid with mean horizontal bars, error bars, and subject-linking lines.
    % Note: Requires the third-party 'beeswarm' function in the MATLAB path.
    
    n_group  = length(group_input);
    n_sample = size(data_input, 1);
    
    Mean_data = mean(data_input, 1);
    SE_data   = std(data_input, 0, 1) / sqrt(n_sample);
    
    data  = reshape(data_input, [], 1);
    group = reshape(repmat(group_input, n_sample, 1), [], 1);
    
    % Draw beeswarm scatter
    beeswarm(group, data, 'sort_style', 'up', 'colormap', Scatter_color, ...
        'MarkerFaceAlpha', 1, 'MarkerEdgeColor', 'white');
    hold on;
    
    % Draw error bars
    errorbar(1:n_group, Mean_data, SE_data, 'k', 'LineStyle', 'none', ...
        'LineWidth', 2, 'CapSize', 8);
        
    % Draw horizontal mean lines
    line([0.8 1.2], [Mean_data(1) Mean_data(1)], 'Color', Bar_color(1,:), 'LineWidth', 3);
    line([1.8 2.2], [Mean_data(2) Mean_data(2)], 'Color', Bar_color(2,:), 'LineWidth', 3);
    
    % Draw linking lines for individual subjects
    for i = 1:n_sample
        line([1.25 1.75], [data_input(i,1) data_input(i,2)], 'Color', Line_Color, 'LineWidth', 1);
    end
    
    xticks([]);
    
    set(gcf, 'Color', 'white');
    set(gca, 'Color', 'white', 'box', 'off', 'TickDir', 'out', ...
        'FontSize', 16, 'FontName', 'Arial', 'LineWidth', 1.5);
        
    hold off;
end