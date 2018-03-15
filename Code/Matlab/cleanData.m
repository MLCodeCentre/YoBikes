function cleanData(Data)

% clean up script that removes all dodgey rows:
% (0,0) lat lngs 
% trips that are very short
% trips that are or very small in distance
% trips that are longer than 5 hours

close all;

if isempty(Data)
    Data = readtable('date_formatted_bike_data.csv');
end

% removing zero lats or lngs
zero_lat_lng_rows = Data.Begin_Lat == 0 | Data.Begin_Lng == 0 | ...
               Data.End_Lat == 0 | Data.End_Lng == 0;
Data = Data(~zero_lat_lng_rows, :);

% removing short trips that are less than 0.5k
too_small_distance_rows = Data.Distance < 0.5;
Data = Data(~too_small_distance_rows, :);

% removing short trips that take less than a minute 
too_big_distance_rows = Data.Distance > 200;
Data = Data(~too_big_distance_rows, :);

% removing trips or longer than 5 hours
fivehour_duration_rows = Data.Duration > 30;
Data = Data(~fivehour_duration_rows, :);

Data_dir = fullfile(rootDir(),'Data');
%writetable(Data,fullfile(Data_dir, 'yoBikeDataClean.csv'))
too_fast_rows = Data.Speed > 30;
Data = Data(~too_fast_rows, :);

histogram2(Data.Duration, Data.Distance, 'FaceColor','flat')
xlabel('Duration')
ylabel('Distance')
zlabel('Number of Trips')
colorbar;

% Ctrs = [0:0.1:20];
% Xcts = hist(Data.Distance, Ctrs);
% figure(1)
% bar(Ctrs, Xcts)
% 
% Ctrs = [0:300];
% Xcts = hist(Data.Duration, Ctrs);
% figure(2)
% bar(Ctrs, Xcts)