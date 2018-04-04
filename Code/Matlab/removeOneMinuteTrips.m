function cleanData = removeOneMinuteTrips()

data = readtable('yoBikeDataCleanClustered.csv');
size_before = size(data,1);

short_trips = (data.Distance <= 0.1);
cleanData = data(~short_trips,:);
disp(' ')
disp(['Size of Data after removing intracluster trips: ',' ',num2str(size(cleanData,1))])
disp(['Removed',' ',num2str(sum(short_trips)),' ','rows'])
disp(' ')

impossible_speeds = cleanData.Speed > 20;
cleanData = cleanData(~impossible_speeds,:);
disp(' ')
disp(['Size of Data after removing impossible speeds: ',' ',num2str(size(cleanData,1))])
disp(['Removed',' ',num2str(sum(impossible_speeds)),' ','rows'])
disp(' ')

Data_dir = fullfile(rootDir(),'Data');
%writetable(cleanData, fullfile(Data_dir, 'yoBikeDataCleanClusteredNoIntra.csv'))
%disp('Saved cleaned Data with no intracluster trips to yoBikeDataCleanClusteredNoIntra.csv')
