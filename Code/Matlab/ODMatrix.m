function ODMatrix(Data)

if isempty(Data)
    Data = readtable('yoBikeDataCleanClusteredNoIntaNewClusters.csv');
end
Data = Data(:,{'Begin_Cluster', 'End_Cluster'});
ODM = zeros(100,100);
BeginEnd = zeros(100,2);

disp(['Calculating OD Matrix for ', num2str(size(Data,1)), ' trips'])

for rowIndex = 1:size(Data,1)
    rowIndex
    row = Data(rowIndex,:);
    ODM(row.Begin_Cluster, row.End_Cluster) = ODM(row.Begin_Cluster, row.End_Cluster) + 1;
    
    BeginEnd(row.Begin_Cluster, 1) = BeginEnd(row.Begin_Cluster, 1) + 1;
    BeginEnd(row.End_Cluster, 2) = BeginEnd(row.End_Cluster, 2) + 1;
    
end

Data_dir = fullfile(rootDir(),'Data');
save(fullfile(Data_dir, 'ODM.mat'), 'ODM') 
ODM;