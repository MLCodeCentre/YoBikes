function plotClusterHists(Data, cluster, trip_thresh)

close all

if isempty(Data)
    Data = readtable('date_formatted_clustered_bike_data.csv');
end

total_num_trips = [];

for cluster2 = 0:29
    cluster1 = cluster;
    if cluster1 ~= cluster2
        clusterPairDataRows = (Data.Begin_Cluster == cluster1 & Data.End_Cluster == cluster2);
        clusterPairData = Data(clusterPairDataRows, :);
        num_trips = size(clusterPairData,1);
        total_num_trips = [total_num_trips, num_trips];
        if num_trips > trip_thresh
            figure;
            histogram(clusterPairData.Hour)
            xlabel('Hour of the Day')
            ylabel('Number of Trips')
            title(strcat(['From',' ','Cluster',' ',num2str(cluster1),' ','to',...
                          ' ','Cluster',' ',num2str(cluster2)]));
            hour_labels = {'12am','1am','2am','3am','4am','5am','6am','7am','8am','9am','10am','11am',...
               '12pm','1pm','2pm','3pm','4pm','5pm','6pm','7pm','8pm','9pm','10pm','11pm'};
            set(gca,'XTick', [0:23]);
            set(gca,'XTickLabel', hour_labels, 'XTickLabelRotation', 45);
        end
    end
end

for cluster1 = 0:29
    cluster2 = cluster;
    if cluster1 ~= cluster2
        clusterPairDataRows = (Data.Begin_Cluster == cluster1 & Data.End_Cluster == cluster2);
        clusterPairData = Data(clusterPairDataRows, :);
        num_trips = size(clusterPairData,1);
        total_num_trips = [total_num_trips, num_trips];
        if num_trips > trip_thresh
            figure;
            histogram(clusterPairData.Hour)
            xlabel('Hour of the Day')
            ylabel('Number of Trips')
            title(strcat(['From',' ','Cluster',' ',num2str(cluster1),' ','to',...
                          ' ','Cluster',' ',num2str(cluster2)]));
            hour_labels = {'12am','1am','2am','3am','4am','5am','6am','7am','8am','9am','10am','11am',...
               '12pm','1pm','2pm','3pm','4pm','5pm','6pm','7pm','8pm','9pm','10pm','11pm'};
            set(gca,'XTick', [0:23]);
            set(gca,'XTickLabel', hour_labels, 'XTickLabelRotation', 45);
        end
    end
end

end
    