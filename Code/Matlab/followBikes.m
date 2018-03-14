function followBikes(Data)

%data = readtable('date_formatted_bike_data.csv');
if isempty(Data)
    Data = readtable('date_formatted_bike_data.csv');
end

Data = Data(Data.Duration > 0, {'Begin_Time', 'End_Time', 'Begin_Lat',...
                                'Begin_Lng', 'End_Lat', 'End_Lng'});
% removing the zero lat and lngs..
Data = Data(Data.Begin_Lat ~= 0, :); 
Data = Data(Data.Begin_Lng ~= 0, :);
Data = Data(Data.End_Lat ~= 0, :);
Data = Data(Data.End_Lng ~= 0, :);
Data = sortrows(Data, 2);

num_bikes = 1;
num_trips_in_journey = 100;
trip_data = Data(4,:);
trip_data.distance = 0;
% now find trips that begin where this ends to some thresh
Lat_Thresh = 10/111251; % 10m
Lng_Thresh = 10/69895; % 10m 

Journey_table = [];

for i = 1:num_trips_in_journey
    i
    Journey_table = [Journey_table; trip_data];
    % get all trips within the next 2 days
    next_trip = [];
    Lat_Thresh = 1/111251; % 10m
    Lng_Thresh = 1/69895; % 10m
    while size(next_trip, 1) == 0
        next_trip = Data(Data.Begin_Time > trip_data.End_Time, :);
        next_trip = next_trip(datenum(next_trip.Begin_Time - trip_data.End_Time) < 2, :);
        next_trip = next_trip(abs(next_trip.Begin_Lat - trip_data.End_Lat) < Lat_Thresh, :);
        next_trip = next_trip(abs(next_trip.Begin_Lng - trip_data.End_Lng) < Lng_Thresh, :);
        
        Lat_Thresh = Lat_Thresh + 5/111251;
        Lng_Thresh = Lng_Thresh + 5/69895;
              
    end
    next_trip.distance = [abs(next_trip.Begin_Lat - trip_data.End_Lat),...
                             abs(next_trip.Begin_Lng - trip_data.End_Lng)])';    
    next_trip = sortrows(next_trip, 6);
    trip_data = next_trip(1,:);
end

Journey_table