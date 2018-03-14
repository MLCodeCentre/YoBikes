function ODMatrix(Data)

if isempty(Data)
    Data = readtable('date_formatted_clustered_bike_data.csv');
end
Data = Data(:,{'Begin_Cluster', 'End_Cluster'});
ODM = zeros(30,30);

for rowIndex = 1:size(Data,1)
    rowIndex
    row = Data(rowIndex,:);
    ODM(row.Begin_Cluster+1, row.End_Cluster+1) = ODM(row.Begin_Cluster+1, row.End_Cluster+1) + 1;
    
end
    
ODM;
    