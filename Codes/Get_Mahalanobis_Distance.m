%     %% 1. Prepare data
%     % channel1 and channel2 are [N_trials x M_timepoints] matrices
%     % Each trial is considered an independent observation sample, and each time point is considered a feature dimension - why?
if isempty(gcp('nocreate'))
    parpool('local', 6);  % Use workers (adjust according to CPU core count)
end

% listing_Reactivation_Pre = dir(['Reactivation*Pre*']);
% listing_Reactivation_Post1 = dir(['Reactivation*Post1*']);
% listing_Reactivation_Post2 = dir(['Reactivation*Post2*']);

% window_length: the length of the sliding time window (e.g., length:1 = each time point alone)
% each time point serves as the beginning
window_length = 5;

% if PCA is needed, then need_PCA = 1
need_PCA = 1;

[Mah_distance_all_Pre,Mah_distance_mean_Pre] = All_Subjects(listing_Reactivation_Pre,window_length,need_PCA);
[Mah_distance_all_Post1,Mah_distance_mean_Post1] = All_Subjects(listing_Reactivation_Post1,window_length,need_PCA);
[Mah_distance_all_Post2,Mah_distance_mean_Post2] = All_Subjects(listing_Reactivation_Post2,window_length,need_PCA);

delete(gcp('nocreate'))        % Close parallel pool

sampling_rate = 10;
time_range = [-100:10:1100-(window_length-1)*sampling_rate];

color1 = [127,127,127]/255;
color2 = [91,155,213]/255;
color3 = [255, 102, 0]/255;

figure
for x = 1:4
    for y = 1:4
        if y < x
            subplot(4,4,4*x-4+y)
            hold on
            plot(time_range,squeeze(Mah_distance_mean_Pre(x,y,:)),'LineWidth',1.5,'Color',color1);
            plot(time_range,squeeze(Mah_distance_mean_Post1(x,y,:)),'LineWidth',1.5,'Color',color2);
            plot(time_range,squeeze(Mah_distance_mean_Post2(x,y,:)),'LineWidth',1.5,'Color',color3);
            set(gca,'tickdir','out');
            set(gcf, 'Color', 'white');
            set(gca, 'Color', 'white');
        end
    end
end

function [Mah_distance_all,Mah_distance_mean] = All_Subjects(subject_list,window_length,need_PCA)
parfor subj = 1:length(subject_list)
    file_name = fullfile(subject_list(subj).folder,subject_list(subj).name, 'binary_1ms_bins_1ms_sampled.mat');
    binned_data = load(file_name,'binned_data');
    binned_labels = load(file_name,'binned_labels');
    [Mah_distance_all(subj,:,:,:)]= Each_Subject(binned_data.binned_data,binned_labels.binned_labels,window_length,need_PCA);
end
Mah_distance_mean = squeeze(mean(Mah_distance_all,1));
end

function [Mah_distance]= Each_Subject(binned_data,binned_labels,window_length,need_PCA)
for trial = 1:size(binned_labels.stim_ID{1, 1})
    label_A(trial) = strcmp(binned_labels.stim_ID{1,1}(trial),'A');
    label_B(trial) = strcmp(binned_labels.stim_ID{1,1}(trial),'B');
    label_C(trial) = strcmp(binned_labels.stim_ID{1,1}(trial),'C');
    label_D(trial) = strcmp(binned_labels.stim_ID{1,1}(trial),'D');
end

for channel = 1:size(binned_data,2) % channel or vertex
    Response_all(1).data(channel,:,:) = binned_data{1,channel}(label_A,:);
    Response_all(2).data(channel,:,:) = binned_data{1,channel}(label_B,:);
    Response_all(3).data(channel,:,:) = binned_data{1,channel}(label_C,:);
    Response_all(4).data(channel,:,:) = binned_data{1,channel}(label_D,:);
end

Response_all(1).name = 'Degree 0';
Response_all(2).name = 'Degree 30';
Response_all(3).name = 'Degree 60';
Response_all(4).name = 'Degree 90';

if need_PCA
    [Response_all,n_components] = PCA_Source_data(Response_all);
    disp(['n components: ', num2str(n_components)]);
end

figure
for x = 1:4
    for y = 1:4
        if y < x
            subplot(4,4,4*x-4+y)
            for times = 1:121-window_length+1
                % Target format: [N_trials x M_features(channels)]
                direction_1_data = mean(Response_all(x).data(:,:,times:times+window_length-1),3)';
                direction_2_data = mean(Response_all(y).data(:,:,times:times+window_length-1),3)';
                Mah_distance(x,y,times) = MahDist(direction_1_data,direction_2_data);
            end
        end
    end
end
end

function [mahalanobis_distance] = MahDist(condition_1,condition_2)
% Calculate_Mahalanobis_Distance
%% 1. Calculate the mean of each channel and the difference between their means
% Calculate channel mean vectors
mu1 = mean(condition_1, 1);  % Row mean, obtaining [1xM] vector
mu2 = mean(condition_2, 1);

% Calculate mean difference
diff_mu = mu1 - mu2;

% % % Visualize mean difference (optional)
% figure;
% plot(mu1, 'b'); hold on;
% plot(mu2, 'r');
% title('Channel Mean Waveforms');
% legend('Channel 1','Channel 2');
% xlabel('Time Points'); ylabel('Amplitude');

%% 2. Calculate covariance matrix
% Merge data from all trials to calculate the covariance matrix (assuming identical distribution)
all_data = [condition_1; condition_2];
[Nsamples, Nfeatures] = size(all_data);
Nsamples = Nsamples/2;

% Calculate covariance matrix (pay attention to dimension direction)
C = cov(all_data);
flag = is_Positive_Definite_Matrix(C); % Check positive definiteness

% Add regularization term to prevent matrix singularity (necessary when dimensions > sample size)
if (Nsamples < Nfeatures) ||  ~flag
    lambda = 1e-6 * trace(C)/size(C,1);  % Adaptive regularization coefficient
    C_reg = C + lambda * eye(size(C));
    reg_flag = is_Positive_Definite_Matrix(C_reg); % Check positive definiteness
    if ~reg_flag
        while (reg_flag ~= 1)
            %             lambda = lambda*2;
            C_reg = C_reg + lambda * eye(size(C));
            reg_flag = is_Positive_Definite_Matrix(C_reg); % Check positive definiteness
        end
    end
    C = C_reg;
end

%% 3. Calculate the inverse of the covariance matrix
% Default to using inv, which better meets data requirements
C_inv = inv(C);
inv_flag = is_Positive_Definite_Matrix(C_inv); % Check positive definiteness

% If requirements are not met, use pseudo-inverse
if ~inv_flag
    C_inv = pinv(C);
    inv_flag = is_Positive_Definite_Matrix(C_inv); % Check positive definiteness
    if ~inv_flag
        error('Pseudo-inverse matrix is not positive definite');
    end
end

%% 4. Calculate Mahalanobis distance
mahalanobis_distance = sqrt(diff_mu * C_inv * diff_mu');
% distance_pdist = pdist2(mu1, mu2, 'mahalanobis', C_inv);

% Display results
% disp(['Mahalanobis Distance: ', num2str(mahalanobis_distance)]);
end

function [permission_flag] = is_Positive_Definite_Matrix(C)
permission_flag = 1;

% 1. Check if it is full rank
matrix_rank = rank(C);
% disp(['Matrix rank: ', num2str(matrix_rank)]);
if matrix_rank < min(size(C))
    permission_flag = 0;
%     disp('Matrix is not full rank');
end

% 2. Check eigenvalues
eigenvalues = eig(C);
if any(eigenvalues <= 0)
    permission_flag = 0;
%     disp('Use or increase regularization coefficient lambda until covariance matrix is positive definite');
end

% 3. Check if symmetric
is_symmetric = isequal(C,C');
if ~is_symmetric
    permission_flag = 0;
%     disp('Inverse matrix is not symmetric');
end
end

function [proj_conditions,n_components] = PCA_Source_data(Response_all)
n_conditions = 4;
n_vertex = size(Response_all(1).data,1);
n_timepoints = size(Response_all(1).data,3);

%% ===== Step 1: Merge data from all conditions and time points to train global PCA =====
% Reconstruct data matrix: features x (trials x timepoints)
pooled_data = [];
for c = 1:n_conditions
    cond_data = reshape(Response_all(c).data, n_vertex,[]);
    pooled_data = [pooled_data, cond_data]; 
end

% Execute global PCA (note transposition to samples x features)
[coeff, ~, ~, ~, explained] = pca(pooled_data');  
% coeff: feature x n_components projection matrix
n_components = find(cumsum(explained)>=90, 1); % Retain principal components explaining 90% variance
coeff = coeff(:,1:n_components);

%% ===== Step 2: Project data of each condition into the global PCA space =====
proj_conditions = struct();
for c = 1:n_conditions
    % Raw data: features x trials x timepoints -> Projected: n_components x trials x timepoints
    raw_data = Response_all(c).data;
    proj_data = [];
    for t = 1:n_timepoints
        % Independent projection for each time point (using global coeff)
        proj_data(:,:,t) = coeff' * raw_data(:,:,t); 
    end
    proj_conditions(c).data = proj_data;  % Store projected data
end
end