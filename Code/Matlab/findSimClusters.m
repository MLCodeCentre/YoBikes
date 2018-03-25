%Code below used to find the optimal number of clusters is 52.
function findSimClusters(data)

X = data;
k_min = 3;
k_max = 20;
clusts = zeros(size(X,1),k_max-k_min);

for k = k_min:k_max
    k
    [IDX, C, SUMD] = kmeans(X, k, 'emptyaction','singleton', 'replicate',5);
    clusts(:, k+1-k_min) = IDX;
    
end

eva = evalclusters(X,clusts,'CalinskiHarabasz')
opt_num_clusters = eva.OptimalK;

cluster_type = kmeans(data, opt_num_clusters);
cluster_num = 1:293;
cluster_types = table(cluster_num', cluster_type);
Data_dir = fullfile(rootDir(),'Data');
writetable(cluster_types, fullfile(Data_dir, 'cluster_types.csv'))


