function exploreOneMinuteData(data)
close all
%% intracluster distance

Ones = [];
NotOnes = [];
d_range = 0:0.01:1;

for d = d_range    
    Ones = [Ones, sum(data.Duration(data.Distance<d)<=1) / ...
                  sum(data.Duration<=1)];
              
    NotOnes = [NotOnes, sum(data.Duration(data.Distance<d)>1) / ...
                        sum(data.Duration>1)];                
end

figure;
plot(d_range, Ones)
hold on
plot(d_range, NotOnes)
legend('One Minute Trips','Longer Than One Minute Trips','location','southeast')
xlabel('Distance [km]')
ylabel('Proportion of Trips')
%% Speed

d=0.1;
tooshort = (data.Distance <= d);
sum(tooshort)
data = data(~tooshort,:);
size(data)

Ones = [];
NotOnes = [];

speed = 0:0.1:100;

for s = speed    
    Ones = [Ones, sum(data.Duration(data.Speed<s)<=1) / ...
                  sum(data.Duration<=1)];
              
    NotOnes = [NotOnes, sum(data.Duration(data.Speed<s)>1) / ...
                        sum(data.Duration>1)];                
end

figure;
plot(speed, Ones)
hold on
plot(speed, NotOnes)
legend('One Minute Trips','Longer Than One Minute Trips','location','southeast')
xlabel('Straight Line Speed [kmh^{-1}]')
ylabel('Proportion of Trips')

sum(data.Speed>20)
