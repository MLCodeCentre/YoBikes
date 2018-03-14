function plotAllClusterHists(Data)

close all

if isempty(Data)
    Data = readtable('date_formatted_clustered_bike_data.csv');
end
total_num_trips = [];
for cluster1 = 0:29
    for cluster2 = 0:29
        if cluster1 ~= cluster2
            clusterPairDataRows = (Data.Begin_Cluster == cluster1 & Data.End_Cluster == cluster2);
            clusterPairData = Data(clusterPairDataRows, :);
            weekendRows = clusterPairData.Weekday == 5 | clusterPairData.Weekday == 6;
            clusterPairData = clusterPairData(~weekendRows, :);
            num_trips = size(clusterPairData,1);
            total_num_trips = [total_num_trips, num_trips];
            if num_trips > 300
                figure;
                histogram(clusterPairData.Hour), %'Normalization', 'cdf')
                xlabel('Hour of the Day')
                ylabel('Number of Trips')
                title(strcat(['From',' ','Cluster',' ',num2str(cluster1),' ','to',...
                              ' ','Cluster',' ',num2str(cluster2)]));
                hour_labels = {'12am','1am','2am','3am','4am','5am','6am','7am','8am','9am','10am','11am',...
                               '12pm','1pm','2pm','3pm','4pm','5pm','6pm','7pm','8pm','9pm','10pm','11pm'};
                set(gca,'XTick', [0:23]);
                set(gca,'XTickLabel', hour_labels, 'XTickLabelRotation', 45);
                
                %ylim([0,1])
                xlim([0,23])
            end
        end
    end
end

end
    