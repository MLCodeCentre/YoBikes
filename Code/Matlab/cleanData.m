function clean_Data = cleanData(Data)

% clean up script that removes all dodgey rows:
% (0,0) lat lngs 
% trips that are very short
% trips that are or very small in distance
% trips that are longer than 5 hours

close all;

if isempty(Data)
    Data = readtable('date_formatted_bike_data.csv');
end
disp(['Size of Data: ',' ',num2str(size(Data,1))])
disp(' ')

% removing zero lats or lngs
Data_size = size(Data,1);
zero_lat_lng_rows = Data.Begin_Lat == 0 | Data.Begin_Lng == 0 | ...
               Data.End_Lat == 0 | Data.End_Lng == 0;
Data = Data(~zero_lat_lng_rows, :);
disp(['Size of Data after non zero lat lng: ',' ',num2str(size(Data,1))])
disp(['Removed',' ',num2str(Data_size-size(Data,1)),' ','rows'])
disp(' ')

%Only keep data within 10kms start and end of bristol
Data_size = size(Data,1);
start_end_in_bristol_rows = Data.Begin_Distance < 10 & Data.End_Distance < 10;
Data = Data(start_end_in_bristol_rows, :);
disp(['Size of Data after only start and end < 10km from city centre: ',' ',num2str(size(Data,1))])
disp(['Removed',' ',num2str(Data_size-size(Data,1)),' ','rows'])
disp(' ')

% removing trips that are zero mins - maybe just unlock and lock straight
% away
Data_size = size(Data,1);
zero_minute_trips = Data.Duration == 0;
Data = Data(~zero_minute_trips, :);
disp(['Size of Data after only non zero duration: ',' ',num2str(size(Data,1))])
disp(['Removed',' ',num2str(Data_size-size(Data,1)),' ','rows'])
disp(' ')

% removing trips that have a zero distance
Data_size = size(Data,1);
zero_distance_trips = Data.Distance == 0;
Data = Data(~zero_distance_trips, :);
disp(['Size of Data after only non zero distance: ',' ',num2str(size(Data,1))])
disp(['Removed',' ',num2str(Data_size-size(Data,1)),' ','rows'])
disp(' ')

disp(['Removed',' ',num2str(132498-size(Data,1)),' ','rows in total'])
disp(' ')

clean_Data = Data;
% 
% figure;
% Ctrs = [0:0.1:5];
% Xcts = hist(OneMinData.Distance, Ctrs);
% bar(Ctrs, Xcts)
% xlabel('Distance [km]')
% ylabel('Fequency')
% title('One Min Data')

% duration distribution
% figure;
% Ctrs = [0:1:300];
% Xcts = hist(Data.Duration, Ctrs);
% bar(Ctrs, Xcts)
% xlabel('Duration [m]')
% ylabel('Fequency')
% title('Trips Greater than 0.5km and Slower than 30kmh^{-1}')
% 
% distance distribution
% figure;
% Ctrs = [0:0.05:6];
% Xcts = hist(Data.Distance, Ctrs);
% bar(Ctrs, Xcts)
% xlabel('Distance [km]')
% ylabel('Fequency')
% title('Trips Greater than 0.1km and Slower than 30kmh^{-1}')
% 
% histogram2(Data.Distance(Data.Duration < 100), Data.Duration(Data.Duration < 100), 'FaceColor','flat')
% ylabel('Duration [minutes]')
% xlabel('Distance [km]')
% zlabel('Number of Trips')
% title('Duration Distance for Trips Greater than 0.1km and Slower than 30kmh^{-1}')
% colorbar;
% 
% figure;
% histogram2(Data.Speed, Data.Duration, 'FaceColor','flat')
% xlabel('Speed')
% ylabel('Distance')
% zlabel('Number of Trips')
% colorbar;


Data_dir = fullfile(rootDir(),'Data');
writetable(Data,fullfile(Data_dir, 'yoBikeDataClean.csv'))
disp('Saved clean data to Data/yoBikeDataClean.csv')



