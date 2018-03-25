function myUsageHist(data)
% showing useage day by day by month
close all
Months = {'January', 'February', 'March', 'April', 'May', 'June', 'July',...
           'August', 'September', 'October', 'November', 'December'};
Days = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',...
         'Saturday', 'Sunday'};
hour_labels = {'12am','1am','2am','3am','4am','5am','6am','7am','8am','9am','10am','11am',...
               '12pm','1pm','2pm','3pm','4pm','5pm','6pm','7pm','8pm','9pm','10pm','11pm'};
           

%% weekday usage
weekday_rows = data.Weekday == 5 | data.Weekday == 6;
myHist(data.Hour(weekday_rows), 0:23, 'Hour', 'Hour');
xlim([0,23])
set(gca,'XTick', [0:23]);
set(gca,'XTickLabel', hour_labels, 'XTickLabelRotation', 45);

figure;
myHist(data.Hour(~weekday_rows), 0:23, 'Hour', 'Hour');
xlim([0,23])
set(gca,'XTick', [0:23]);
set(gca,'XTickLabel', hour_labels, 'XTickLabelRotation', 45);

%%
figure;
myHist(data.Distance, 0:0.1:10, 'Distance [km]', 'km');
xlim([0,10])

%% overall usage
figure;
histogram(data.Begin_Time, 'BinMethod', 'week')
ylabel('Frequency')
xlabel('Week')

width = '1';
total = size(data,1);

ylimits=get(gca,'ylim');
xlimits=get(gca,'xlim');
text(200, 4500*0.85, strcat(['Total: ',num2str(total)]))
text(200, 4500*0.8, strcat(['Bin width: ', width, ' ',  'Week']))