function cleanData = removeOneMinuteTrips(data)

size_before = size(data,1);
d=0.2;
short_intra_trips = (data.Distance<d & data.End_Cluster==data.Begin_Cluster);
cleanData = data(~short_intra_trips,:);
disp(['Size of Data after removing intracluster trips shorter than 0.1km: ',' ',num2str(size(cleanData,1))])
disp(['Removed',' ',num2str(size_before-size(cleanData,1)),' ','rows'])
disp(' ')
Data_dir = fullfile(rootDir(),'Data');
writetable(cleanData, fullfile(Data_dir, 'yoBikeDataCleanClusteredNoIntra.csv'))
