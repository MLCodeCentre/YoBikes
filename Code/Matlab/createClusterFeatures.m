function createClusterFeatures

ODM_Load = load('ODM.mat');
ODM = ODM_Load.ODM;
clusters = 293;
cluster_connections = zeros(clusters,clusters);
%non_zero_variances;

K = 1:clusters;
for k = K
    k
    % summing all journeys from K to all and from all to k
    %cluster_connections(k,:) = ODM(k,:) + ODM(:,k)';
    %changing, cluster connections are now all to K.
    cluster_connections(k,:) = ODM(:,k)';
    %
    
    % the k to k will have been added twice, so need to remove one
    cluster_connections(k,k) =  cluster_connections(k,k) - ODM(k,k);
    % now im actually going to remove intra cluster.
    cluster_connections(k,k) = 0;
    
    % now normalising across the row. Hence giving a percentage connection
    % score between k and each other cluster
    cluster_connections(k,:) = sort(cluster_connections(k,:)./sum(cluster_connections(k,:)),'DESCEND');
    
    
end

Data_dir = fullfile(rootDir(),'Data');
save(fullfile(Data_dir,'cluster_connections'),'cluster_connections')
    
    