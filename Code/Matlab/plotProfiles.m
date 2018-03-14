function plotProfiles(Data)

%data = readtable('date_formatted_bike_data.csv');
if isempty(Data)
    Data = readtable('date_formatted_bike_data.csv');
end

close all;
%
rows = Data.Distance > 0;
Data = Data(rows, :);

% showing useage day by day by month
Months = {'January', 'February', 'March', 'April', 'May', 'June', 'July',...
           'August', 'September', 'October', 'November', 'December'};
Days = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',...
         'Saturday', 'Sunday'};
hour_labels = {'12am','1am','2am','3am','4am','5am','6am','7am','8am','9am','10am','11am',...
               '12pm','1pm','2pm','3pm','4pm','5pm','6pm','7pm','8pm','9pm','10pm','11pm'};
                          
               
     
%% creating day profiles for each month
% Year = 2017;
% rows = Data.Year == Year;
% YearData = Data(rows, {'Month', 'Weekday', 'Hour'});
% for Month = 5:12
%     rows = YearData.Month == Month;
%     MonthData = YearData(rows, {'Weekday', 'Hour'});
%    for Day = 0:6
%        figure;
%        rows = MonthData.Weekday == Day;
%        DayData = MonthData(rows, {'Hour'});
%        h = histogram(DayData.Hour);
%        xlim([0,23])
%        set(gca,'XTick', [0:23]);
%        set(gca,'XTickLabel', hour_labels, 'XTickLabelRotation', 45);
%        title(strcat(['Histogram of Usage per Hour on a',' ',Days{Day+1},...
%                      ', ', Months{Month}, ' ', num2str(Year)]))
%        xlabel('Hour of the Day')
%        ylabel('Frequency')
%        file_dir = fullfile(rootDir(), 'Images', 'Useage Histograms', Days{Day+1});
%        [status, msg, msgID] = mkdir(file_dir);
%        file_name = strcat([num2str(Month), '.png']);
%        saveas(h, fullfile(file_dir, file_name))
%        close
%    end
% end
% 
% Year = 2018;
% rows = Data.Year == Year;
% YearData = Data(rows, {'Month', 'Weekday', 'Hour'});
% for Month = 1:1
%     rows = YearData.Month == Month;
%     MonthData = YearData(rows, {'Weekday', 'Hour'});
%    for Day = 0:6
%        figure;
%        rows = MonthData.Weekday == Day;
%        DayData = MonthData(rows, {'Hour'});
%        h = histogram(DayData.Hour);
%        xlim([0,23])
%        set(gca,'XTick', [0:23]);
%        set(gca,'XTickLabel', hour_labels, 'XTickLabelRotation', 45);
%        title(strcat(['Histogram of Usage per Hour on a',' ',Days{Day+1},...
%                      ', ', Months{Month}, ' ', num2str(Year)]))
%        xlabel('Hour of the Day')
%        ylabel('Frequency')
%        file_name = strcat([num2str(12+Month), '.png']);
%        saveas(h, fullfile(rootDir(), 'Images', 'Useage Histograms', Days{Day+1}, file_name))
%        close
%    end
% end

%% Duration Histograms 
% 
% figure;
% rows = Data.Duration < 120;
% DurationData = Data(rows, {'Duration'});
% rows = DurationData.Duration > 0;
% DurationData = DurationData(rows, {'Duration'});
% h = histogram(DurationData.Duration);
% title('Trip Duration Histogram')
% xlabel('Trip Duration [m]')
% ylabel('Frequency')
% file_name = 'Trip Duration Histogram.png';
% % saveas(h, fullfile(rootDir(),'Images', file_name))

%% Time of day for all data
% Overall Hour of the day
% figure;
% h = histogram(Data.Hour);
% title('Histogram of Usage per Hour of the Day')
% xlabel('Hour of the Day')
% ylabel('Frequency')
% xlim([0,23])
% set(gca,'XTick', [0:23]);
% set(gca,'XTickLabel', hour_labels, 'XTickLabelRotation', 45);
% file_name = 'Hour of Day Usage Histogram.png';
% saveas(h, fullfile(rootDir(),'Images','Usage Histograms','Overall',file_name))
% 

% % Time of day for each day
% for Day = 0:6
%     figure;
%     rows = Data.Weekday == Day;
%     DayData = Data(rows, {'Hour'});
%     h = histogram(DayData.Hour);
%     title(strcat(['Histogram of Usage per Hour on a', ' ', Days{Day+1}]))
%     xlabel('Hour of the Day')
%     ylabel('Frequency')
%     xlim([0,23])
%     set(gca,'XTick', [0:23]);
%     set(gca,'XTickLabel', hour_labels, 'XTickLabelRotation', 45);
%     file_name = strcat([num2str(Day), '.png']);
%     saveas(h, fullfile(rootDir(), 'Images', 'Usage Histograms', 'Overall', file_name))
%     close;
% end

%% overall useage
% figure;
% rows = Data.Year < 2019;
% TimeData = Data(rows, {'Begin_Time'});
% h = histogram(TimeData.Begin_Time)
% title('Histogram of Usage')
% xlabel('Day of the Year')
% ylabel('Frequency')
% file_name = 'Time Usage Histogram.png';
% saveas(h, fullfile(rootDir(),'Images', file_name)) 


% plot speed profile
% figure;
% rows = Data.Speed < 20;
% SpeedData = Data(rows, {'Speed'});
% h = histogram(SpeedData.Speed);
% xlim([0,22])
% title('Histogram of Straight Line Speeds')
% xlabel('Speed [km^{-1}]')
% ylabel('Frequency')
% file_name = 'Speed Histogram.png';
% saveas(h, fullfile(rootDir(),'Images', file_name)) 
