function dataProcessing

% loading data as returned from Python - possibly edit this in future
data_raw = readtable('date_formatted_bike_data.csv');

% cleaning - removing zero data this gets saved to yoBikeDataClean.csv
clean_Data = cleanData(data_raw);

% using Kmeans to calculate clusters (remember this is only NonZero cleaning)
[clustered_Data, C] = createClusters(clean_Data);

% we now use these clusters to perform more cleaning (70% of 1 min trips
% but only 10% of all others trips are intracluster tips less than 0.2k
clean_Data = removeOneMinuteTrips(clustered_Data);

% create cluster.csv that contains information about each cluster
createClusterTable(clean_Data, C)



