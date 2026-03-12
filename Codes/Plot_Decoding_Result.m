function varargout = Plot_Decoding_Result(varargin)
% PLOT_DECODING_RESULT MATLAB code for Plot_Time_Course.fig
% This GUI application processes, visualizes, and performs statistical 
% tests on neural decoding results (e.g., classification accuracy, cluster-based permutation).

% =========================================================================
% PART 1: GUI Initialization Code - DO NOT EDIT
% =========================================================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Plot_Time_Course_OpeningFcn, ...
                   'gui_OutputFcn',  @Plot_Time_Course_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code


% --- Executes just before Plot_Time_Course is made visible.
function Plot_Time_Course_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Plot_Time_Course_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% =========================================================================
% PART 2: UI Callbacks (User Interactions & Parameter Settings)
% =========================================================================

function Decoding_result_Callback(hObject, eventdata, handles)
    [folder_prefix] = uigetdir([], 'Choose your folder of saved data');
    if isequal(folder_prefix, 0); return; end
    disp(['You selected ', folder_prefix, ' as your data folder']);
    handles.folder_prefix = folder_prefix;
    guidata(hObject, handles);

function Result_file_Callback(hObject, eventdata, handles)
    [subject_filename, subject_filepath] = uigetfile('*.mat', 'Choose your subject (.mat)');
    if isequal(subject_filename, 0)
       disp('Please select your subject again');
    else
       disp(['You selected subject ', fullfile(subject_filepath, subject_filename)]);
       handles.subject = fullfile(subject_filepath, subject_filename);
       guidata(hObject, handles);
    end

function Null_distribution_folder_Callback(hObject, eventdata, handles)
    [Null_distribution_folder] = uigetdir([], 'Choose your folder of saved data of your subject');
    if isequal(Null_distribution_folder, 0); return; end
    disp(['You selected ', Null_distribution_folder, ' as your data folder']);
    handles.Null_distribution_folder = Null_distribution_folder;
    guidata(hObject, handles);

function result_file_subj1_Callback(hObject, eventdata, handles)
    [subject_1_filename, subject_filepath] = uigetfile('*.mat', 'Choose your subject1 (.mat)');
    if ~isequal(subject_1_filename, 0)
        handles.subject_1_filename = fullfile(subject_filepath, subject_1_filename);
        guidata(hObject, handles);
    end

function result_file_subj2_Callback(hObject, eventdata, handles)
    [subject_2_filename, subject_filepath] = uigetfile('*.mat', 'Choose your subject2 (.mat)');
    if ~isequal(subject_2_filename, 0)
        handles.subject_2_filename = fullfile(subject_filepath, subject_2_filename);
        guidata(hObject, handles);
    end

function null_distribution_subj1_Callback(hObject, eventdata, handles)
    [Null_dir] = uigetdir([], 'Choose your folder of saved data of your subject1');
    if ~isequal(Null_dir, 0)
        handles.Null_distribution_subject_1_folder = Null_dir;
        guidata(hObject, handles);
    end

function null_distribution_subj2_Callback(hObject, eventdata, handles)
    [Null_dir] = uigetdir([], 'Choose your folder of saved data of your subject2');
    if ~isequal(Null_dir, 0)
        handles.Null_distribution_subject_2_folder = Null_dir;
        guidata(hObject, handles);
    end

function CV_input_Callback(hObject, eventdata, handles)
    cv = str2double(get(hObject, 'String'));
    disp(['Cross-validation folds: ', num2str(cv)]);
    handles.cv = cv;
    guidata(hObject, handles);

function CV_input_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', 'white');
    end

function number_of_condition_input_Callback(hObject, eventdata, handles)
    num_cond = str2double(get(hObject, 'String'));
    disp(['Number of conditions: ', num2str(num_cond)]);
    handles.number_of_condition = num_cond;
    guidata(hObject, handles);

function number_of_condition_input_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', 'white');
    end

function Permutation_test_Callback(hObject, eventdata, handles)
    if (get(hObject, 'Value'))
        handles.permutation_flag = 1;
        disp('Permutation test enabled: Null distributions will be calculated.');
    else
        handles.permutation_flag = 0;
    end
    guidata(hObject, handles);


% =========================================================================
% PART 3: Main Execution Callbacks (Save, Plot, Compare)
% =========================================================================

function Save_averaged_result_Callback(hObject, eventdata, handles)
    %% Load directories of Decoding results
    cd(fullfile(handles.folder_prefix, 'Decoding_Results'));
    
    listing_Con_Pre   = dir('ConPre');
    listing_Con_Post1 = dir('ConPost1');
    listing_Con_Post2 = dir('ConPost2');
    listing_Minor_Pre   = dir('MinorPre');
    listing_Minor_Post1 = dir('MinorPost1');
    listing_Minor_Post2 = dir('MinorPost2');

    %% Read decoding results for all groups and conditions
    cv = handles.cv;
    num_cond = handles.number_of_condition;
    
    [ACC_Con_Pre, ~, ~, ~, ~]     = my_read_decoding_result(listing_Con_Pre, cv, num_cond);
    [ACC_Con_Post1, ~, ~, ~, ~]   = my_read_decoding_result(listing_Con_Post1, cv, num_cond);
    [ACC_Con_Post2, ~, ~, ~, ~]   = my_read_decoding_result(listing_Con_Post2, cv, num_cond);
    [ACC_Minor_Pre, ~, ~, ~, ~]   = my_read_decoding_result(listing_Minor_Pre, cv, num_cond);
    [ACC_Minor_Post1, ~, ~, ~, ~] = my_read_decoding_result(listing_Minor_Post1, cv, num_cond);
    [ACC_Minor_Post2, ~, ~, ~, ~] = my_read_decoding_result(listing_Minor_Post2, cv, num_cond);

    %% Save averaged decoding results
    % Assuming 'decoding_template_10ms.mat' exists in the MATLAB path
    load('decoding_template_10ms.mat', 'DECODING_RESULTS'); 
    
    target_folder = fullfile(handles.folder_prefix, 'Decoding_result_mean');
    if ~exist(target_folder, 'dir')
        mkdir(target_folder);
    end
    cd(target_folder);

    % Save Control Group
    DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results = mean(ACC_Con_Pre, 1)';
    save('Decoding_Con_Pre_mean.mat', 'DECODING_RESULTS');
    DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results = mean(ACC_Con_Post1, 1)';
    save('Decoding_Con_Post1_mean.mat', 'DECODING_RESULTS');
    DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results = mean(ACC_Con_Post2, 1)';
    save('Decoding_Con_Post2_mean.mat', 'DECODING_RESULTS');

    % Save Reactivation Group (Minor)
    DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results = mean(ACC_Minor_Pre, 1)';
    save('Decoding_Minor_Pre_mean.mat', 'DECODING_RESULTS');
    DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results = mean(ACC_Minor_Post1, 1)';
    save('Decoding_Minor_Post1_mean.mat', 'DECODING_RESULTS');
    DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results = mean(ACC_Minor_Post2, 1)';
    save('Decoding_Minor_Post2_mean.mat', 'DECODING_RESULTS');

    %% Perform permutation test if flagged
    if isfield(handles, 'permutation_flag') && handles.permutation_flag == 1
        cd(fullfile(handles.folder_prefix, 'Null_Distributions'));
        
        Null_target_folder = fullfile(handles.folder_prefix, 'Null_distributions_all');
        if ~exist(Null_target_folder, 'dir')
            mkdir(Null_target_folder);
        end

        % Collect null distribution files
        my_collect_files(dir('ConPre'), fullfile(Null_target_folder, 'Con_Pre'));
        my_collect_files(dir('ConPost1'), fullfile(Null_target_folder, 'Con_Post1'));
        my_collect_files(dir('ConPost2'), fullfile(Null_target_folder, 'Con_Post2'));
        my_collect_files(dir('MinorPre'), fullfile(Null_target_folder, 'Minor_Pre'));
        my_collect_files(dir('MinorPost1'), fullfile(Null_target_folder, 'Minor_Post1'));
        my_collect_files(dir('MinorPost2'), fullfile(Null_target_folder, 'Minor_Post2'));
        disp('Null distribution files collected!');

        % Calculate and plot p-values
        figure;
        subplot(1,3,1); my_calculate_p(fullfile(target_folder, 'Decoding_Con_Pre_mean.mat'), fullfile(Null_target_folder, 'Con_Pre'));
        subplot(1,3,2); my_calculate_p(fullfile(target_folder, 'Decoding_Con_Post1_mean.mat'), fullfile(Null_target_folder, 'Con_Post1'));
        subplot(1,3,3); my_calculate_p(fullfile(target_folder, 'Decoding_Con_Post2_mean.mat'), fullfile(Null_target_folder, 'Con_Post2'));
        
        figure;
        subplot(1,3,1); my_calculate_p(fullfile(target_folder, 'Decoding_Minor_Pre_mean.mat'), fullfile(Null_target_folder, 'Minor_Pre'));
        subplot(1,3,2); my_calculate_p(fullfile(target_folder, 'Decoding_Minor_Post1_mean.mat'), fullfile(Null_target_folder, 'Minor_Post1'));
        subplot(1,3,3); my_calculate_p(fullfile(target_folder, 'Decoding_Minor_Post2_mean.mat'), fullfile(Null_target_folder, 'Minor_Post2'));
        
        disp('P-values calculated and plotted!');
    end


function plot_averaged_Callback(hObject, eventdata, handles)
    %% Load directories and decode results
    cd(fullfile(handles.folder_prefix, 'Decoding_Results'));
    cv = handles.cv;
    num_cond = handles.number_of_condition;
    
    [ACC_Con_Pre, SE_ACC_Con_Pre] = my_read_decoding_result(dir('ConPre'), cv, num_cond);
    [ACC_Con_Post1, SE_ACC_Con_Post1] = my_read_decoding_result(dir('ConPost1'), cv, num_cond);
    [ACC_Con_Post2, SE_ACC_Con_Post2] = my_read_decoding_result(dir('ConPost2'), cv, num_cond);
    [ACC_Minor_Pre, SE_ACC_Minor_Pre] = my_read_decoding_result(dir('MinorPre'), cv, num_cond);
    [ACC_Minor_Post1, SE_ACC_Minor_Post1] = my_read_decoding_result(dir('MinorPost1'), cv, num_cond);
    [ACC_Minor_Post2, SE_ACC_Minor_Post2] = my_read_decoding_result(dir('MinorPost2'), cv, num_cond);

    %% Perform cluster-based permutation test between conditions
    [H_Con_Post1_change, ~, H_Con_Post2_change, ~] = my_test(ACC_Con_Pre, ACC_Con_Post1, ACC_Con_Post2);
    [H_Minor_Post1_change, ~, H_Minor_Post2_change, ~] = my_test(ACC_Minor_Pre, ACC_Minor_Post1, ACC_Minor_Post2);

    % Placeholder zero matrices for within-group significance (requires null distribution implementation)
    H_Con_Pre = zeros(1, size(ACC_Con_Pre, 2)); H_Con_Post1 = H_Con_Pre; H_Con_Post2 = H_Con_Pre;
    H_Minor_Pre = zeros(1, size(ACC_Minor_Pre, 2)); H_Minor_Post1 = H_Minor_Pre; H_Minor_Post2 = H_Minor_Pre;

    %% Plot averaged results
    baseline = 100 / handles.number_of_condition;
    color1 = [127, 127, 127] / 255; % Gray
    color2 = [91, 155, 213] / 255;  % Blue
    color3 = [255, 102, 0] / 255;   % Orange

    figure('Color', 'white', 'Position', [100, 100, 1000, 800]);

    subplot(2,2,1);
    plot_Classification_Accuracy(baseline, 'Pre', 'Post1', ACC_Minor_Pre, ACC_Minor_Post1, SE_ACC_Minor_Pre, SE_ACC_Minor_Post1, H_Minor_Pre, H_Minor_Post1, H_Minor_Post1_change, color1, color2);
    title('Reactivation Group: Post1 vs Pre');

    subplot(2,2,2);
    plot_Classification_Accuracy(baseline, 'Pre', 'Post2', ACC_Minor_Pre, ACC_Minor_Post2, SE_ACC_Minor_Pre, SE_ACC_Minor_Post2, H_Minor_Pre, H_Minor_Post2, H_Minor_Post2_change, color1, color3);
    title('Reactivation Group: Post2 vs Pre');

    subplot(2,2,3);
    plot_Classification_Accuracy(baseline, 'Pre', 'Post1', ACC_Con_Pre, ACC_Con_Post1, SE_ACC_Con_Pre, SE_ACC_Con_Post1, H_Con_Pre, H_Con_Post1, H_Con_Post1_change, color1, color2);
    title('Control Group: Post1 vs Pre');

    subplot(2,2,4);
    plot_Classification_Accuracy(baseline, 'Pre', 'Post2', ACC_Con_Pre, ACC_Con_Post2, SE_ACC_Con_Pre, SE_ACC_Con_Post2, H_Con_Pre, H_Con_Post2, H_Con_Post2_change, color1, color3);
    title('Control Group: Post2 vs Pre');


function Plot_one_subject_Callback(hObject, eventdata, handles)
    figure;
    my_calculate_p(handles.subject, handles.Null_distribution_folder);

function Compare_Callback(hObject, eventdata, handles)
    load(handles.subject_1_filename, 'DECODING_RESULTS');
    ACC_subject1 = squeeze(mean(DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.decoding_results, 2));  
    SE_subject1  = std(squeeze(mean(DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.decoding_results, 1)))';

    load(handles.subject_2_filename, 'DECODING_RESULTS');
    ACC_subject2 = squeeze(mean(DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.decoding_results, 2));  
    SE_subject2  = std(squeeze(mean(DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.decoding_results, 1)))';
    
    H_1 = zeros(1, length(ACC_subject1));
    H_2 = zeros(1, length(ACC_subject2));
    H_change = zeros(1, length(ACC_subject2));

    color1 = [0.00, 0.45, 0.74]; % Blue
    color2 = [0.85, 0.33, 0.10]; % Orange
    
    figure('Color', 'white');
    plot_Classification_Accuracy(25, 'Subject 1', 'Subject 2', ACC_subject1, ACC_subject2, SE_subject1, SE_subject2, H_1, H_2, H_change, color1, color2);


% =========================================================================
% PART 4: Core Processing & Statistical Functions
% =========================================================================

function [ACC, SE_ACC, AUC, SE_AUC, ACC_each_direction] = my_read_decoding_result(subject_list, cv, number_of_condition)
    % MY_READ_DECODING_RESULT Extracts decoding accuracy and AUC from result files.
    ACC = []; 
    AUC = []; 
    ACC_each_direction = [];
    
    % Filter out '.' and '..' directories
    subject_list = subject_list(~ismember({subject_list.name}, {'.', '..'}));

    for subj = 1:length(subject_list)
        file_name = fullfile(subject_list(subj).folder, subject_list(subj).name, 'MTT_binary_results_1msbins_1mssteps.mat');
        if ~exist(file_name, 'file'); continue; end
        
        load(file_name, 'DECODING_RESULTS');
        ACC(subj, :) = DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results;
        AUC(subj, :) = DECODING_RESULTS.ROC_AUC_RESULTS.combined_CV_ROC_results.mean_decoding_results;
        
        confusion_matrix = DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.confusion_matrix_results.confusion_matrix;
        mean_confusion_matrix = [];
        
        time_length = length(DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results);
        % Assume field name contains the cv fold, e.g., 'cv50' or 'cv10' (hardcoded fallback to original cv50)
        cv_field = 'cv50'; 
        
        if number_of_condition == 4
            for j = 1:time_length
                mean_confusion_matrix(1,j) = confusion_matrix(1,1,j).(cv_field);
                mean_confusion_matrix(2,j) = confusion_matrix(2,2,j).(cv_field); 
                mean_confusion_matrix(3,j) = confusion_matrix(3,3,j).(cv_field); 
                mean_confusion_matrix(4,j) = confusion_matrix(4,4,j).(cv_field);
            end
        elseif number_of_condition == 2
            for j = 1:time_length
                mean_confusion_matrix(1,j) = confusion_matrix(1,1,j).(cv_field);
                mean_confusion_matrix(2,j) = confusion_matrix(2,2,j).(cv_field); 
            end
        end
        ACC_each_direction(subj, :, :) = mean_confusion_matrix;
    end
    
    SE_ACC = std(ACC, 0, 1) ./ sqrt(size(ACC, 1));
    SE_AUC = std(AUC, 0, 1) ./ sqrt(size(AUC, 1));


function my_calculate_p(decoding_result_filename, dir_null_distribution)
    % MY_CALCULATE_P Plots standard results object to calculate empirical p-values
    result_names{1} = decoding_result_filename;
    plot_obj = plot_standard_results_object(result_names);
    
    pval_dir_name{1} = fullfile(dir_null_distribution, '');
    plot_obj.p_values = pval_dir_name;

    plot_obj.collapse_all_times_when_estimating_pvals = 1;
    plot_obj.p_value_alpha_level = 0.05;
    plot_obj.plot_results;


function my_collect_files(subject_list, target_folder)
    % MY_COLLECT_FILES Copies .mat files to a target null distribution folder
    if ~exist(target_folder, 'dir')
        mkdir(target_folder);
    end
    
    subject_list = subject_list(~ismember({subject_list.name}, {'.', '..'}));
    
    for i = 1:length(subject_list)
        file_dir = fullfile(subject_list(i).folder, subject_list(i).name);
        mat_files = dir(fullfile(file_dir, '*.mat'));
        for j = 1:length(mat_files)
            source_file = fullfile(mat_files(j).folder, mat_files(j).name);
            copyfile(source_file, target_folder);
        end
    end


function [H_post1, P_post1, H_post2, P_post2] = my_test(Pre, Post1, Post2)
    % MY_TEST Performs cluster-based permutation tests across conditions
    [H_post1, P_post1] = Cluster_based_permutation_test(Pre, Post1);
    [H_post2, P_post2] = Cluster_based_permutation_test(Pre, Post2);


function [H_corrected, P_corrected] = my_FDR_correction(P_input)
    % MY_FDR_CORRECTION Corrects p-values using Benjamini-Hochberg FDR
    P_corrected = mafdr(P_input, 'BHFDR', true);
    H_corrected = P_corrected < 0.05;


function [output_H, output_p] = Cluster_based_permutation_test(data_A, data_B)
    % CLUSTER_BASED_PERMUTATION_TEST Non-parametric statistical testing
    % Input format expected: [Subjects x Timepoints]
    
    n_perm = 5000; % Number of permutations
    n_timepoints = size(data_A, 2);
    n_subjects = size(data_A, 1);
    
    % Defining threshold for clustering (Two-tailed t-test)
    cluster_defining_threshold = tinv(0.975, n_subjects - 1); 

    % Prepare data: Dim 1 = Condition, Dim 2 = Timepoint, Dim 3 = Subject
    data = zeros(2, n_timepoints, n_subjects);
    for time = 1:n_timepoints
        data(1, time, :) = data_A(:, time);
        data(2, time, :) = data_B(:, time);
    end

    % 1. Calculate observed t-statistics
    t_values = zeros(1, n_timepoints);
    for time_point = 1:n_timepoints
        [~, ~, ~, stats] = ttest(squeeze(data(1, time_point, :)), squeeze(data(2, time_point, :)));
        t_values(time_point) = stats.tstat;
    end

    % Define clusters based on threshold
    clusters = abs(t_values) > cluster_defining_threshold;
    cluster_labels = bwlabel(clusters);

    % Calculate observed cluster mass (sum of t-values)
    cluster_stats = arrayfun(@(x) sum(t_values(cluster_labels == x)), 1:max(cluster_labels));

    % 2. Permutation testing
    permuted_cluster_stats = zeros(n_perm, 1);
    for i_perm = 1:n_perm
        perm_data = data;
        % Randomly swap conditions for each subject
        for subj = 1:n_subjects
            if rand() > 0.5
                perm_data(:, :, subj) = perm_data([2 1], :, subj);
            end
        end
        
        perm_t_values = zeros(1, n_timepoints);
        for time_point = 1:n_timepoints
            [~, ~, ~, stats] = ttest(squeeze(perm_data(1, time_point, :)), squeeze(perm_data(2, time_point, :)));
            perm_t_values(time_point) = stats.tstat;
        end
        
        perm_clusters = abs(perm_t_values) > cluster_defining_threshold;
        perm_cluster_labels = bwlabel(perm_clusters);
        
        if max(perm_cluster_labels) > 0
            perm_cluster_stats_temp = arrayfun(@(x) sum(perm_t_values(perm_cluster_labels == x)), 1:max(perm_cluster_labels));
            permuted_cluster_stats(i_perm) = max(abs(perm_cluster_stats_temp));
        else
            permuted_cluster_stats(i_perm) = 0;
        end
    end

    % 3. Calculate final p-values
    output_p = ones(1, n_timepoints);
    if ~isempty(cluster_stats)
        p_values = arrayfun(@(x) mean(permuted_cluster_stats >= abs(x)), cluster_stats);
        for n_cluster = 1:length(cluster_stats)
            output_p(cluster_labels == n_cluster) = p_values(n_cluster);
        end
    end
    output_H = output_p < 0.05;


function [output_H] = my_continuous_data(input_H, criteria)
    % MY_CONTINUOUS_DATA Filters for consecutive significant time points
    flag = zeros(size(input_H));
    for i = 1:(length(input_H) - criteria + 1)
        if sum(input_H(i : i + criteria - 1)) == criteria
            flag(i : i + criteria - 1) = 1;
        end
    end
    output_H = input_H & flag;


% =========================================================================
% PART 5: Plotting Function
% =========================================================================

function plot_Classification_Accuracy(baseline, legend_1, legend_2, ACC1, ACC2, SE1, SE2, H_line1, H_line2, H_change, color1, color2)
    % PLOT_CLASSIFICATION_ACCURACY Plots time-series decoding accuracy with shaded errors and significance bars.
    
    if baseline == 50
        y_range = [40 90];
        height_change = 78;
    else
        y_range = [20 65];
        height_change = 48;
    end

    % Optional: Gaussian smoothing applied to the data before plotting
    sigma = 1;
    for subj = 1:size(ACC1, 1)
        ACC1(subj,:) = imgaussfilt(ACC1(subj,:), sigma);
        ACC2(subj,:) = imgaussfilt(ACC2(subj,:), sigma);
    end
    % Recalculate Standard Error after smoothing
    SE1 = std(ACC1, 0, 1) ./ sqrt(size(ACC1, 1) - 1);
    SE2 = std(ACC2, 0, 1) ./ sqrt(size(ACC2, 1) - 1);

    % Convert to percentage
    ACC1 = ACC1 .* 100;
    ACC2 = ACC2 .* 100;
    SE1 = SE1 .* 100;
    SE2 = SE2 .* 100;
    
    sampling_rate = 10;
    begin_time = -100;
    end_time = 1100;
    time = begin_time : sampling_rate : end_time;

    hold on;
    % Plot main lines
    plot(time, mean(ACC1, 1), 'LineWidth', 1.5, 'Color', color1);
    plot(time, mean(ACC2, 1), 'LineWidth', 1.5, 'Color', color2);
    
    % Plot shaded error bars
    shadedErrorBar(time, mean(ACC1, 1), SE1, 'lineprops', {'Color', color1}, 'transparent', 1);
    shadedErrorBar(time, mean(ACC2, 1), SE2, 'lineprops', {'Color', color2}, 'transparent', 1);
    
    % Plot baseline reference
    line([begin_time end_time], [baseline baseline], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.5);

    % Plot significance markers (H_change) at the specified height
    for i = 1:length(H_change)
        if H_change(i) == 1
            x_start = begin_time + (i - 1.5) * sampling_rate;
            x_end   = begin_time + (i - 0.5) * sampling_rate;
            line([x_start, x_end], [height_change height_change], 'LineWidth', 2, 'Color', color2);
        end
    end

    % Formatting
    xlabel('Time (ms)');
    ylabel('Decoding accuracy (%)');    
    set(gca, 'FontName', 'Arial', 'Fontsize', 14, 'TickDir', 'out', 'LineWidth', 1.5, 'Box', 'off');
    axis([begin_time end_time y_range(1) y_range(2)]);
    hold off;
