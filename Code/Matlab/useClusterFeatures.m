function useClusterFeatures

close all
clusterFeatures_load = load('cluster_connections.mat');
clusterFeatures = clusterFeatures_load.cluster_connections;

%clusterDistances_load = load('cluster_distances.mat');
%clusterDistances = clusterDistances_load.Distances;

K = 293;
num = zeros(1,K);
geo_coeffs = zeros(K,2);
file_dir = fullfile(rootDir(), 'Images', 'Connection Distributions');
%distances = zeros(1,100);
for i = 1:293
    i
    %bar(clusterFeatures(i,:))
    %ylim([0, 0.15])
    %xlim([0,5])
    %num(i) = sum(clusterFeatures(i,:) > 0.05);
    cluster = clusterFeatures(i,:);   
    h = plot(1:K, cluster, 'bx');
    hold on
    %[f,h] = fitExponential(cluster, K);
   
    p = fitGeometric(cluster,1:K);
    geofit = geopdf(1:K,p);
    plot(1:K, geofit, 'r-')
    hold off 
       
    geo_coeffs(i,1) = i;
    geo_coeffs(i,2) = p;
       
    ylabel('Proportion')
    xlabel('Ranked Cluster Connection')
    file_name = strcat([num2str(i), '.png']);
    %saveas(h, fullfile(file_dir, file_name))
    print(fullfile(file_dir, file_name),'-dpng')
end


Data_dir = fullfile(rootDir(), 'Data');
save(fullfile(Data_dir, 'geo_coeffs.mat'), 'geo_coeffs');

end

function [f,h] = fitExponential(connections, K)
    x = (1:K)';
    y = connections';
    f = fit(x,y,'exp1');
    legend('Order Cluster Connections','Fitted Curve')
    h = plot(f,x,y);
    xlabel('Ranked Cluster Connections')
    ylabel('Proportion')
end