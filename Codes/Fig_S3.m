
%% Plot Univariate Results: 3×3 ROI Subplots

ROI_names = {'V1','V2','V3','MT','V3A',...
             'IPS0','IPS1','IPS2','IPS3'};
Test_prefix = {'Pre','Post1','Post2'};
degree_list = [0 30 60 90];

n_ROI = numel(ROI_names);
n_test = numel(Test_prefix);
n_degree = numel(degree_list);


%% Reactivation group
%% 1. Input
load("Fig_S3.mat");

%% 2. Define Colors
base_colors = [
    0.36 0.54 0.76;   % 0°  Blue
    0.38 0.66 0.52;   % 30° Green
    0.85 0.58 0.38;   % 60° Orange
    0.66 0.50 0.75    % 90° Purple
];

lightness = [0.08 0.22 0.36];

colors = zeros(12,3);

for d = 1:n_degree
    for t = 1:n_test
        idx = (d-1)*n_test + t;
        colors(idx,:) = base_colors(d,:) * (1-lightness(t))...
                      + lightness(t);
    end
end

%% 3. Create Figure
fig = figure('Color','w',...
    'Units','pixels',...
    'Position',[100 100 1250 760]);

tl = tiledlayout(fig,3,3,...
    'TileSpacing','compact',...
    'Padding','compact');

%% 4. Bar Parameters
degree_x = 1:4;
bar_spacing = 0.20;
bar_width = 0.18;

legend_handles = gobjects(12,1);
legend_labels = cell(12,1);

%% 5. Plot Each ROI
for r = 1:n_ROI

    ax = nexttile(tl,r);
    hold(ax,'on');

    for d = 1:n_degree
        for t = 1:n_test

            idx = (d-1)*n_test + t;

            % Bar position
            x = degree_x(d) + (t-2)*bar_spacing;

            y = Mean_Beta(r,idx);
            se = SE_Beta(r,idx);

            % Bar
            h = bar(ax,x,y,bar_width,...
                'FaceColor',colors(idx,:),...
                'EdgeColor','w',...
                'LineWidth',0.3);

            % Error bar
            errorbar(ax,x,y,se,...
                'LineStyle','none',...
                'Color',[0.35 0.35 0.35],...
                'LineWidth',1,...
                'CapSize',2.5,...
                'HandleVisibility','off');

            % Save handles for shared legend
            if r == 1
                legend_handles(idx) = h;
                legend_labels{idx} = sprintf('%d°  %s',...
                    degree_list(d),Test_prefix{t});
            end
        end
    end

    %% Axes Settings
    ax.FontName = 'Arial';
    ax.FontSize = 11;
    ax.LineWidth = 0.9;
    ax.TickDir = 'out';
    ax.TickLength = [0.008 0.008];

    ax.XTick = degree_x;
    ax.XTickLabel = {'0°','30°','60°','90°'};
    ax.XLim = [0.5 4.5];
    if r < 4
         ax.YLim = [0 4];
    elseif r<7
        ax.YLim = [0 2];
    else
        ax.YLim = [0 2.5];
    end
   
%     ax.YTick = 0:1:3;

    ax.XGrid = 'off';
    ax.YGrid = 'off';
    ax.Box = 'off';

    title(ax,ROI_names{r},...
        'FontName','Arial',...
        'FontSize',13,...
        'FontWeight','normal');

end

%% 6. Shared Labels
ylabel(tl,'Mean beta',...
    'FontName','Arial',...
    'FontSize',13);

title(tl,'ROI-wise Univariate Responses Reactivation Group',...
    'FontName','Arial',...
    'FontSize',15,...
    'FontWeight','normal');

%% 7. Shared Legend
lgd = legend(legend_handles,legend_labels,...
    'Orientation','vertical',...
    'FontName','Arial',...
    'FontSize',10,...
    'Box','off');

lgd.Layout.Tile = 'east';

%% 8. Export
% exportgraphics(fig,'ROI_Univariate_3x3.png','Resolution',300);
% exportgraphics(fig,'ROI_Univariate_3x3.pdf','ContentType','vector');

%% Control group
%% 1. Input
load("Fig_S3_control.mat");

%% 2. Define Colors
base_colors = [
    0.36 0.54 0.76;   % 0°  Blue
    0.38 0.66 0.52;   % 30° Green
    0.85 0.58 0.38;   % 60° Orange
    0.66 0.50 0.75    % 90° Purple
];

lightness = [0.08 0.22 0.36];

colors = zeros(12,3);

for d = 1:n_degree
    for t = 1:n_test
        idx = (d-1)*n_test + t;
        colors(idx,:) = base_colors(d,:) * (1-lightness(t))...
                      + lightness(t);
    end
end

%% 3. Create Figure
fig = figure('Color','w',...
    'Units','pixels',...
    'Position',[100 100 1250 760]);

tl = tiledlayout(fig,3,3,...
    'TileSpacing','compact',...
    'Padding','compact');

%% 4. Bar Parameters
degree_x = 1:4;
bar_spacing = 0.20;
bar_width = 0.18;

legend_handles = gobjects(12,1);
legend_labels = cell(12,1);

%% 5. Plot Each ROI
for r = 1:n_ROI

    ax = nexttile(tl,r);
    hold(ax,'on');

    for d = 1:n_degree
        for t = 1:n_test

            idx = (d-1)*n_test + t;

            % Bar position
            x = degree_x(d) + (t-2)*bar_spacing;

            y = Mean_Beta(r,idx);
            se = SE_Beta(r,idx);

            % Bar
            h = bar(ax,x,y,bar_width,...
                'FaceColor',colors(idx,:),...
                'EdgeColor','w',...
                'LineWidth',0.3);

            % Error bar
            errorbar(ax,x,y,se,...
                'LineStyle','none',...
                'Color',[0.35 0.35 0.35],...
                'LineWidth',1,...
                'CapSize',2.5,...
                'HandleVisibility','off');

            % Save handles for shared legend
            if r == 1
                legend_handles(idx) = h;
                legend_labels{idx} = sprintf('%d°  %s',...
                    degree_list(d),Test_prefix{t});
            end
        end
    end

    %% Axes Settings
    ax.FontName = 'Arial';
    ax.FontSize = 11;
    ax.LineWidth = 0.9;
    ax.TickDir = 'out';
    ax.TickLength = [0.008 0.008];

    ax.XTick = degree_x;
    ax.XTickLabel = {'0°','30°','60°','90°'};
    ax.XLim = [0.5 4.5];
    if r < 4
         ax.YLim = [0 4];
    elseif r<7
        ax.YLim = [0 2];
    else
        ax.YLim = [0 2.5];
    end
   
%     ax.YTick = 0:1:3;

    ax.XGrid = 'off';
    ax.YGrid = 'off';
    ax.Box = 'off';

    title(ax,ROI_names{r},...
        'FontName','Arial',...
        'FontSize',13,...
        'FontWeight','normal');

end

%% 6. Shared Labels
ylabel(tl,'Mean beta',...
    'FontName','Arial',...
    'FontSize',13);

title(tl,'ROI-wise Univariate Responses Control Group',...
    'FontName','Arial',...
    'FontSize',15,...
    'FontWeight','normal');

%% 7. Shared Legend
lgd = legend(legend_handles,legend_labels,...
    'Orientation','vertical',...
    'FontName','Arial',...
    'FontSize',10,...
    'Box','off');

lgd.Layout.Tile = 'east';

%% 8. Export
% exportgraphics(fig,'ROI_Univariate_3x3.png','Resolution',300);
% exportgraphics(fig,'ROI_Univariate_3x3.pdf','ContentType','vector');

