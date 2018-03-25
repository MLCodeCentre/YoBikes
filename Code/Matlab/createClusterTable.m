function createClusterTable(C)

disp('createClusterTable.m')
disp('Data/Loading yoBikeDataCleanClusteredNoIntra.csv')
Data = readtable('yoBikeDataCleanClusteredNoIntra.csv');

K = 293;
% create start and end columns for data
Begin_Coords = [Data.Begin_Lat, Data.Begin_Lng];
End_Coords = [Data.End_Lat, Data.End_Lng];

Begin_Cluster = kmeans(Begin_Coords,K,'Start',C);
End_Cluster = kmeans(End_Coords,K,'Start',C);
DataNewClusters = [Data(:,1:18), table(Begin_Cluster, End_Cluster)];

% create cluster table and save
Cluster_Lat = C(:,1);
Cluster_Lng = C(:,2);
Cluster_ID = [1:K]';
Cluster_Begin_Number = [];
Cluster_End_Number = [];

for k = 1:K
     Cluster_Begin_Number = [Cluster_Begin_Number; sum(Begin_Cluster==k)];
     Cluster_End_Number = [Cluster_End_Number; sum(End_Cluster==k)];
end

Cluster_Begin_End_Number = Cluster_Begin_Number + Cluster_End_Number;
cluster_table = table(Cluster_ID, Cluster_Lat, Cluster_Lng, Cluster_Begin_Number, Cluster_End_Number, Cluster_Begin_End_Number);

Data_dir = fullfile(rootDir(),'Data');

writetable(DataNewClusters, fullfile(Data_dir, 'yoBikeDataCleanClusteredNoIntaNewClusters.csv'))
disp(['Saving file yoBikeDataCleanClusteredNoIntaNewClusters.csv with ',num2str(size(DataNewClusters, 1)),' rows'])
writetable(cluster_table, fullfile(Data_dir, 'clusters.csv'))
disp(['Saving file clusters.csv with ',num2str(size(cluster_table, 1)),' rows'])