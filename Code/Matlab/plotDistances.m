function plotDistances(data)

close all

% get sensible distances
data = data(data.Distance<100, :);

commuterRows = (data.Hour > 6 & data.Hour > 9) | (data.Hour > 15 & data.Hour < 20);
commuterData = data(commuterRows, :);
histogram(commuterData.Distance, 'Normalization', 'cdf')
xlim([0,10])
title('Commuter')

figure
notCommuterData = data(~commuterRows, :);
histogram(notCommuterData.Distance, 'Normalization', 'cdf')
xlim([0,10])
title('Not Commuter')


