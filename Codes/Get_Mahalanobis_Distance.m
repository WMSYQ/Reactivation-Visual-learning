%     %% 1. 准备数据
%     % channel1 和 channel2 是 [N试次 x M时间点] 的矩阵
%     % 每个试次视为一个独立观测样本，每个时间点视为一个特征维度-为什么？

if isempty(gcp('nocreate'))
    parpool('local', 6);  % 使用4个worker（根据CPU核心数调整）
end

% listing_Minor_Pre = dir(['Minor*Pre*']);
% listing_Minor_Post1 = dir(['Minor*Post1*']);
% listing_Minor_Post2 = dir(['Minor*Post2*']);

% window_length: the length of the sliding time window (e.g., length:1 = each time point alone)
% each time point serves as the beginning
window_length = 5;

% if PCA is needed, then need_PCA = 1
need_PCA = 1;
[Mah_distance_all_Pre,Mah_distance_mean_Pre] = All_Subjects(listing_Minor_Pre,window_length,need_PCA);
[Mah_distance_all_Post1,Mah_distance_mean_Post1] = All_Subjects(listing_Minor_Post1,window_length,need_PCA);
[Mah_distance_all_Post2,Mah_distance_mean_Post2] = All_Subjects(listing_Minor_Post2,window_length,need_PCA);

delete(gcp('nocreate'))        % 关掉池子

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

% figure
for x = 1:4
    for y = 1:4
        if y < x
%             subplot(4,4,4*x-4+y)
            for times = 1:121-window_length+1
                % 目标格式：[N试次 x M特征(channel)]
                direction_1_data = mean(Response_all(x).data(:,:,times:times+window_length-1),3)';
                direction_2_data = mean(Response_all(y).data(:,:,times:times+window_length-1),3)';
                Mah_distance(x,y,times) = MahDist(direction_1_data,direction_2_data);
            end
            %             plot([-100:10:1100],squeeze(Mah_distance(x,y,:)),'LineWidth',1);
        end
    end
end

end

function [mahalanobis_distance] = MahDist(condition_1,condition_2)

% Calculate_Mahalanobis_Distance

%% 1. 计算两个通道各自的均值、二者的均值差
% 计算通道均值向量
mu1 = mean(condition_1, 1);  % 行平均，得到[1xM]向量
mu2 = mean(condition_2, 1);

% 计算均值差
diff_mu = mu1 - mu2;

% % % 可视化均值差异（可选）
% figure;
% plot(mu1, 'b'); hold on;
% plot(mu2, 'r');
% title('Channel Mean Waveforms');
% legend('Channel 1','Channel 2');
% xlabel('Time Points'); ylabel('Amplitude');

%% 2. 计算协方差矩阵
% 合并所有试次的数据以计算协方差矩阵（假设同分布）
all_data = [condition_1; condition_2];

[Nsamples, Nfeatures] = size(all_data);
Nsamples = Nsamples/2;

% 计算协方差矩阵（注意维度方向）
C = cov(all_data);
flag = is_Positive_Definite_Matrix(C); % 检查正定性。

% 添加正则化项防止矩阵奇异（当维度 > 样本量时必需）
if (Nsamples < Nfeatures) ||  ~flag
    lambda = 1e-6 * trace(C)/size(C,1);  % 自适应正则化系数
    C_reg = C + lambda * eye(size(C));
    reg_flag = is_Positive_Definite_Matrix(C_reg); % 检查正定性
    if ~reg_flag
        while (reg_flag ~= 1)
            %             lambda = lambda*2;
            C_reg = C_reg + lambda * eye(size(C));
            reg_flag = is_Positive_Definite_Matrix(C_reg); % 检查正定性
        end
    end
    C = C_reg;
end

%% 3. 计算协方差矩阵的逆矩阵
% 默认用inv计算，比较符合数据要求
C_inv = inv(C);
inv_flag = is_Positive_Definite_Matrix(C_inv); % 检查正定性

% 如果不符合要求，使用伪逆
if ~inv_flag
    C_inv = pinv(C);
    inv_flag = is_Positive_Definite_Matrix(C_inv); % 检查正定性
    if ~inv_flag
        error('伪逆矩阵非正定');
    end
end

%% 4. 计算马氏距离
mahalanobis_distance = sqrt(diff_mu * C_inv * diff_mu');
% distance_pdist = pdist2(mu1, mu2, 'mahalanobis', C_inv);
% 显示结果
% disp(['Mahalanobis Distance: ', num2str(mahalanobis_distance)]);

end

function [permission_flag] = is_Positive_Definite_Matrix(C)

permission_flag = 1;

% 1. 检查是否满秩
matrix_rank = rank(C);
% disp(['矩阵秩: ', num2str(matrix_rank)]);
if matrix_rank < min(size(C))
    permission_flag = 0;
%     disp('矩阵不满秩');
end


% 2. 检查奇异值
eigenvalues = eig(C);
if any(eigenvalues <= 0)
    permission_flag = 0;
%     disp('使用或增大正则化系数λ直至协方差矩阵正定');
end

% 3. 检查是否对称
is_symmetric = isequal(C,C');
if ~is_symmetric
    permission_flag = 0;
%     disp('逆矩阵不对称');
end

end

function [proj_conditions,n_components] = PCA_Source_data(Response_all)

n_conditions = 4;
n_vertex = size(Response_all(1).data,1);
n_timepoints = size(Response_all(1).data,3);

%% ===== 步骤1: 合并所有条件和时间点的数据以训练全局PCA =====

% 重构数据矩阵: 特征 × (试次×时间点)

pooled_data = [];
for c = 1:n_conditions
    cond_data = reshape(Response_all(c).data, n_vertex,[]);
    pooled_data = [pooled_data, cond_data]; 
end

% 执行全局PCA（注意转置为样本×特征）
[coeff, ~, ~, ~, explained] = pca(pooled_data');  
% coeff: 特征 × n_components 的投影矩阵
n_components = find(cumsum(explained)>=90, 1); % 保留90%方差的主成分

coeff = coeff(:,1:n_components);

%% ===== 步骤2: 将各条件数据投影到全局PCA空间 =====
proj_conditions = struct();
for c = 1:n_conditions
    % 原始数据: 特征 × 试次 × 时间点 → 投影后: n_components × 试次 × 时间点
    raw_data = Response_all(c).data;
    proj_data = [];
    for t = 1:n_timepoints
        % 每个时间点独立投影（但使用全局coeff）
        proj_data(:,:,t) = coeff' * raw_data(:,:,t); 
    end
    proj_conditions(c).data = proj_data;  % 存储投影后数据
end

end