function clusterDistances

clusterData = readtable('clusters.csv');
k = 100;
Distances = zeros(k,k);

for cluster1 = 1:k
    cluster1
    for cluster2 = 1:k
        cluster1_Lat = clusterData(clusterData.Cluster_ID==cluster1, :).Cluster_Lat;
        cluster1_Lng = clusterData(clusterData.Cluster_ID==cluster1, :).Cluster_Lng;
        cluster2_Lat = clusterData(clusterData.Cluster_ID==cluster2, :).Cluster_Lat;
        cluster2_Lng = clusterData(clusterData.Cluster_ID==cluster2, :).Cluster_Lng;
        
        [D1,D2] = lldistkm([cluster1_Lat cluster1_Lng],[cluster2_Lat cluster2_Lng]);
        Distances(cluster1, cluster2) = D1;                                   
    end
end
Data_dir = fullfile(rootDir(),'Data');
save(fullfile(Data_dir,'cluster_distances'),'Distances')