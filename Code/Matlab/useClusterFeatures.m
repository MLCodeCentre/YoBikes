function useClusterFeatures

close all
clusterFeatures_load = load('cluster_connections.mat');
clusterFeatures = clusterFeatures_load.cluster_connections;

clusterDistances_load = load('cluster_distances.mat');
clusterDistances = clusterDistances_load.Distances;

num = zeros(1,293);
dist = zeros(1,293);
file_dir = fullfile(rootDir(), 'Images', 'Connection Distributions');
%distances = zeros(1,100);
for i = 1:293
    %figure;
    %bar(clusterFeatures(i,:))
    %ylim([0, 0.15])
    %xlim([0,5])
    %num(i) = sum(clusterFeatures(i,:) > 0.05);
    cluster = clusterFeatures(i,:);
    h = plot(cluster);
    ylabel('Proportion')
    xlabel('Ranked Cluster Connection')
    file_name = strcat([num2str(i), '.png']);
    saveas(h, fullfile(file_dir, file_name))
    close
end

