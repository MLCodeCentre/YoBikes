function exploreOneMinuteData(data)

Ones = [];
NotOnes = [];

% speed = 0:0.1:30;
% 
% for s = speed    
%     Ones = [Ones, sum(data.Duration(data.Speed>s)<=1) / ...
%                   sum(data.Duration<=1)];
%               
%     NotOnes = [NotOnes, sum(data.Duration(data.Speed>s)>1) / ...
%                         sum(data.Duration>1)];                
% end
% 
% figure;
% plot(speed, Ones)
% hold on
% plot(speed, NotOnes)
% legend('One Minute Trips','Greater Than One Minute Trips')
% xlabel('Straight Line Speed')
% ylabel('Proportion of Trips less than Straight Line Speed')

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
legend('One Minute IntraCluster Trips','Greater Than One Minute IntraCluster Trips','location','southeast')
xlabel('Distance')
ylabel('Proportion of Trips less than Distance')
