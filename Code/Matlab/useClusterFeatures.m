function useClusterFeatures

close all
clusterFeatures_load = load('cluster_connections.mat');
clusterFeatures = clusterFeatures_load.cluster_connections;

clusterDistances_load = load('cluster_distances.mat');
clusterDistances = clusterDistances_load.Distances;

num = zeros(1,100);
%distances = zeros(1,100);
for i = 1:10
    figure;
    %bar(clusterFeatures(i,:))
    %ylim([0, 0.15])
    cluster = clusterFeatures(i,:);
    distances = clusterDistances(i,:);
    scatter(distances, cluster)
    xlim([0,5])
    num(i) = sum(cluster > 0.1);
    disp(['Cluster ',num2str(i),' ',num2str(num(i))])
end

    
