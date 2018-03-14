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

% removing short trips that take less than a minute 
to_small_duration_rows = Data.Duration <= 1 | Data.Distance < 0.01;
Data = Data(~to_small_duration_rows, :);

% removing trips or longer than 5 hours
fivehour_duration_rows = Data.Duration > 300;
Data = Data(~fivehour_duration_rows, :);


%too_fast_rows = Data.Speed > 30;
%Data = Data(~too_fast_rows, :);

Ctrs = [0:300];
Xcts = hist(Data.Duration, Ctrs);
figure(1)
bar(Ctrs, Xcts)