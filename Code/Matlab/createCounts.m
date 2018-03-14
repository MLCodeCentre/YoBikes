function createCounts(Data)

%data = readtable('date_formatted_bike_data.csv');
if isempty(Data)
    Data = readtable('date_formatted_bike_data.csv');
end

% Keeping Only rows within a certain distance of the centre
rows = Data.Begin_Distance < 3; 
Data = Data(rows, {'Hour', 'Year', 'DoY', 'Begin_Lat', 'Begin_Lng', 'End_Lat', 'End_Lng'});
rows = Data.Begin_Lat ~= 0;
Data = Data(rows, {'Hour', 'Year', 'DoY', 'Begin_Lat', 'Begin_Lng', 'End_Lat', 'End_Lng'});
rows = Data.Begin_Lng ~= 0;
Data = Data(rows, {'Hour', 'Year', 'DoY', 'Begin_Lat', 'Begin_Lng', 'End_Lat', 'End_Lng'});

n_bins = 100;
lat_range = linspace(min(Data.Begin_Lat), max(Data.Begin_Lat), n_bins);
lng_range = linspace(min(Data.Begin_Lng), max(Data.Begin_Lng), n_bins);
counts = zeros(n_bins, n_bins, 360*24);

time = 1;
rows = Data.Year == 2017;
YearData = Data(rows, {'DoY', 'Hour', 'Begin_Lat', 'Begin_Lng', 'End_Lat', 'End_Lng'});
YearDataSort = sortrows(YearData, [2,1]);
    
for Day = 6:365
    rows = YearDataSort.DoY==Day; 
    DayData = YearDataSort(rows, {'DoY', 'Hour', 'Begin_Lat', 'Begin_Lng', 'End_Lat', 'End_Lng'});
    
    for Hour = 0:23
        rows = DayData.Hour==Hour; 
        HourData = DayData(rows, {'Hour', 'Begin_Lat', 'Begin_Lng', 'End_Lat', 'End_Lng'});
        
        for rowIndex = 1:size(HourData,1)

            row = HourData(rowIndex, :);


            % substracting a bike if a journey starts there
            begin_lat_ind = find(abs((row.Begin_Lat - lat_range)) == min(abs((row.Begin_Lat - lat_range))));
            begin_lng_ind = find(abs((row.Begin_Lng - lng_range)) == min(abs((row.Begin_Lng - lng_range))));
            counts(begin_lat_ind, begin_lng_ind, time) = counts(begin_lat_ind, begin_lng_ind, time) + 1;
            
        end
        time = time + 1
    end
end

save(fullfile(rootDir,'Data','counts.mat'), 'counts', '-v7.3')

end % createCounts