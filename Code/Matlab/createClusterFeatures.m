function createClusterFeatures

ODM_Load = load('ODM.mat');
ODM = ODM_Load.ODM;
cluster_connections = zeros(100,100);

K = 1:100;
for k = K
 
    % summing all journeys from K to all and from all to k
    cluster_connections(k,:) = ODM(k,:) + ODM(:,k)';
    
    % the k to k will have been added twice, so need to remove one
    cluster_connections(k,k) =  cluster_connections(k,k) - ODM(k,k);
    % now im actually going to remove intra cluster.
    cluster_connections(k,k) = 0;
    
    % now normalising across the row. Hence giving a percentage connection
    % score between k and each other cluster
    cluster_connections(k,:) = cluster_connections(k,:)./sum(cluster_connections(k,:));
    
    
end

Data_dir = fullfile(rootDir(),'Data');
save(fullfile(Data_dir,'cluster_connections'),'cluster_connections')
    
    