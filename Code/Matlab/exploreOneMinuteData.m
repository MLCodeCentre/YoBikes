function exploreOneMinuteData(data)

Ones = [];
NotOnes = [];

d_range = 0:0.01:1;

for d = d_range    
    Ones = [Ones, sum(data.Duration(data.Distance<d & data.End_Cluster==data.Begin_Cluster)<=1) / ...
                  sum(data.Duration<=1)];
              
    NotOnes = [NotOnes, sum(data.Duration(data.Distance<d & data.End_Cluster==data.Begin_Cluster)>1) / ...
                        sum(data.Duration>1)];                
end

figure;
plot(d_range, Ones)
hold on
plot(d_range, NotOnes)
legend('One Minute IntraCluster Trips','Greater Than One Minute IntraCluster Trips')
xlabel('Trip Distance')
ylabel('Proportion of Total Trips')
