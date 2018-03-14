function clusterDistances

clusterData = readtable('clusters.csv');
Distances = zeros(30,30);

for cluster1 = 0:29
    for cluster2 = 0:29
        cluster1_Lat = clusterData(clusterData.Cluster==cluster1, {'Lat'}).Lat;
        cluster1_Lng = clusterData(clusterData.Cluster==cluster1, {'Lng'}).Lng;
        cluster2_Lat = clusterData(clusterData.Cluster==cluster2, {'Lat'}).Lat;
        cluster2_Lng = clusterData(clusterData.Cluster==cluster2, {'Lng'}).Lng;
        
        [D1,D2] = lldistkm([cluster1_Lat cluster1_Lng],[cluster2_Lat cluster2_Lng]);
        Distances(cluster1+1, cluster2+1) = D1;                                   
    end
end

save('cluster_distances','Distances')