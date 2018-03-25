function C = createClusters()

Data = readtable('yoBikeDataClean.csv');

disp(['There are ',num2str(size(Data,1)), ' Data Rows in yoBikeDataClean.csv'])

lats = [Data.Begin_Lat; Data.End_Lat];
lngs = [Data.Begin_Lng; Data.End_Lng];
X = [lats, lngs];

% %Code below used to find the optimal number of clusters is 52.
% k_min = 270;
% k_max = 300;
% clusts = zeros(size(X,1),k_max-k_min);
% 
% for k = k_min:k_max
%     k
%     [IDX, C, SUMD] = kmeans(X, k, 'emptyaction','singleton', 'replicate',3);
%     clusts(:, k+1-k_min) = IDX;
%     
% end
% 
% eva = evalclusters(X,clusts,'CalinskiHarabasz')
% opt_num_clusters = eva.OptimalK


% the best is 100

K = 293;
disp(['Performing Kmeans with ',' ',num2str(K),' ','Clusters']);
disp(' ')
[IDX, C] = kmeans(X, K, 'emptyaction','singleton');

% create start and end columns for data
Begin_Coords = [Data.Begin_Lat, Data.Begin_Lng];
End_Coords = [Data.End_Lat, Data.End_Lng];

Begin_Cluster = kmeans(Begin_Coords,K,'Start',C);
End_Cluster = kmeans(End_Coords,K,'Start',C);

clustered_data = [Data, table(Begin_Cluster, End_Cluster)];
Data_dir = fullfile(rootDir(),'Data');
writetable(clustered_data, fullfile(Data_dir, 'yoBikeDataCleanClustered.csv'))
disp(['Saved cleaned Data with cluster information with ',num2str(size(clustered_data,1)),' trips to yoBikeDataCleanClustered.csv'])
%     
