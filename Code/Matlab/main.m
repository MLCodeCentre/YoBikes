function main(Data)

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

counts_load = load('counts.mat');
counts = counts_load.counts;

differences_load = load('differences.mat');
differences = differences_load.differences;

% find non zeros

%[I,J,V] = ind2sub(size(counts), find(counts(:,:,:)>0));

thetas = zeros(n_bins, n_bins);
sums = zeros(n_bins, n_bins);
diffs = zeros(n_bins, n_bins);
ind = 0
% for lat = 1:n_bins
%     for lng = 1:n_bins
%         count = squeeze(counts(lat,lng,:));
%         bins = count>0;
%         theta_hat = binofit(sum(bins==1), numel(bins));
%         thetas(lat,lng) = theta_hat;
%         sums(lat,lng) = sum(count);
%         ind = ind + 1
%     end
% end

ind = 0
for lat = 1:n_bins
    for lng = 1:n_bins
        difference = squeeze(differences(lat,lng,:));
        diffs(lat,lng) = sum(difference);
        ind = ind + 1
    end
end

[LNG, LAT] = meshgrid(lng_range, lat_range);
h = surf(LNG, LAT, diffs);
set(h,'edgecolor','none')
%shading interp
colorbar;
view(2)
%plot(squeeze(counts(I(ind),J(ind),:)),'o');
ylabel('Latitude')
xlabel('Longitude')
title('Lambdas for Poisson Distribution of Bikes per hour')
xlim([min(min(LNG)), max(max(LNG))])
ylim([min(min(LAT)), max(max(LAT))])

% creating matrix lat, lng, lambda for any greater than zero.
non_zero_inds = find(diffs~=0);
numel(non_zero_inds)
lld = zeros(numel(non_zero_inds), 3);

for ind = 1:numel(non_zero_inds)
   
   non_zero_ind = non_zero_inds(ind);
   lat = LAT(non_zero_ind);
   lng = LNG(non_zero_ind);
   lld(ind,:) = [lat, lng, diffs(non_zero_ind)];
    
end

save(fullfile(rootDir,'Data','latlngdiff.mat'), 'lld')

% [LNG, LAT] = meshgrid(lng_range, lat_range);
% h = surf(LNG, LAT, thetas);
% set(h,'edgecolor','none')
% %shading interp
% colorbar;
% view(2)
% %plot(squeeze(counts(I(ind),J(ind),:)),'o');
% ylabel('Latitude')
% xlabel('Longitude')
% title('Lambdas for Poisson Distribution of Bikes per hour')
% xlim([min(min(LNG)), max(max(LNG))])
% ylim([min(min(LAT)), max(max(LAT))])

% creating matrix lat, lng, lambda for any greater than zero.
% non_zero_inds = find(thetas>0);
% numel(non_zero_inds)
% llts = zeros(numel(non_zero_inds), 4);
% 
% for ind = 1:numel(non_zero_inds)
%    
%    non_zero_ind = non_zero_inds(ind);
%    lat = LAT(non_zero_ind);
%    lng = LNG(non_zero_ind);
%    llts(ind,:) = [lat, lng, thetas(non_zero_ind), sums(non_zero_ind)];
%     
% end
% 
% save(fullfile(rootDir,'Data','latlngthetasum.mat'), 'llts')
