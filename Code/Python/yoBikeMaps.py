import folium
from folium import plugins
from folium.features import DivIcon
import pandas as pd
from mat4py import loadmat
import numpy as np
from progress.bar import Bar
from sklearn.cluster import KMeans
import googlemaps
import json


def plotLinksBetweenClusters():

    ODM = loadmat('Data/ODM_norm_mirror.mat')
    ODM = np.array(ODM['ODM_norm_mirror'])
    cluster_df = pd.read_csv('Data/clusters.csv')
    m = folium.Map([51.4545, -2.58], zoom_start=13)
    cluster_paths = json.load(open('Data/cluster_paths.json'))
   

    for cluster_origin in range(0,29):
        
        cluster_origin_info = cluster_df[cluster_df['Cluster']==cluster_origin]
        radius = float((15*cluster_origin_info['Num']/15000))
        print(radius)
        origin_lat = float(cluster_origin_info['Lat'])
        origin_lng = float(cluster_origin_info['Lng'])
     
        folium.CircleMarker(location=[origin_lat, origin_lng],
                            radius=radius,
                            color='#3186cc',
                            fill_color='#3186cc',
                            tooltip = 'Cluster {}, {} Trip End or Starts'.format(cluster_origin, int(cluster_origin_info['Num']))).add_to(m)
        folium.Marker([origin_lat, origin_lng],
                      icon=DivIcon(
                      icon_size=(150,36),
                      icon_anchor=(0,0),
                      html='<div style="font-size: 18pt; font-weight: bold">{}</div>'.format(str(cluster_origin)),
                            )
                        ).add_to(m)
        
        ODM_Cluster = ODM[cluster_origin, :]
        for cluster_dest, weight in enumerate(ODM_Cluster):
            if weight > 0.005:
                cluster_dest_info = cluster_df[cluster_df['Cluster']==cluster_dest]

                dest_lat = float(cluster_dest_info['Lat'])
                dest_lng = float(cluster_dest_info['Lng'])
                
                key = str(origin_lat) + str(origin_lng) + str(dest_lat) + str(dest_lng)
                try:
                    points = cluster_paths[key]
                    print('not google')
                except:
                    KeyError
                    print('Google')
                    points = getWayPoints((origin_lat, origin_lng), (dest_lat, dest_lng))
                    cluster_paths[key] = points
                
                opacity = weight/0.01
                folium.PolyLine(points,
                                tooltip = 'Cluster {} and Cluster {}: {}'.format(cluster_origin, cluster_dest, str(weight)[:6]),
                                opacity = opacity).add_to(m)
                
            
    m.save('Maps/ClusterLinks.html') 
    with open('Data/cluster_paths.json', 'w') as outfile:
        json.dump(cluster_paths, outfile)
           

def plotClusters(df):
    dist = 3
    df_centre = df[df['Begin_Distance'] < dist]
    df_centre = df_centre[df_centre['End_Distance'] < dist]
    df_centre = df_centre[df_centre['Speed'] > 0]
    #df_centre = df_centre[df_centre['Speed'] < 100]
    #df_centre = df_centre.head(100)
    print('Parsing lats and lngs')
    co_ords_Begin = [[row.Begin_Lat, row.Begin_Lng] for idx, row in df_centre.iterrows()]
    co_ords_End = [[row.End_Lat, row.End_Lng] for idx, row in df_centre.iterrows()]
    co_ords = co_ords_Begin + co_ords_End
    co_ords = np.array(co_ords)
    
    print('Performing KMeans')
    kmeans = KMeans(n_clusters=30, random_state=0).fit(co_ords)
    centroids = kmeans.cluster_centers_.tolist()
    m = folium.Map([51.4545, -2.58], zoom_start=13)
    
    inds = []
    centroid_lats = []
    centroid_lngs = []
    nums = []
    for ind, (lat, lng) in enumerate(centroids):
        num_elements = len([label for label in kmeans.labels_ if label == ind])
        inds.append(ind)
        centroid_lats.append(lat)
        centroid_lngs.append(lng)
        nums.append(num_elements)
        
        print(ind, num_elements)
        folium.CircleMarker(location=[lat, lng], radius=15*num_elements/15000,
                    color='#3186cc',
                    fill_color='#3186cc',
                    tooltip = 'Cluster {}: {} Journeys'.format(str(ind), str((num_elements)))).add_to(m)
    
    m.save('Maps/Centroids.html')
    
    # saving centroid information
    centroid_df = pd.DataFrame(
    {'Cluster': inds,
     'Lat': centroid_lats,
     'Lng': centroid_lngs,
     'Num': nums
    })
    
    centroid_df.to_csv('Data/clusters.csv')
    
    print('Calculating cluster memberships for Begining and End positions')
    # assigning each begin and end in df to cluster
    #df = df.head(10)
    Begin_lats = df['Begin_Lat']
    Begin_lngs = df['Begin_Lng']
    End_lats = df['End_Lat']
    End_lngs = df['End_Lng']
    
    Begin_coords = np.array([[lat, lng] for lat, lng in zip(Begin_lats, Begin_lngs)])
    Begin_clusters = kmeans.predict(Begin_coords)
    df['Begin_Cluster'] = Begin_clusters
    
    End_coords = np.array([[lat, lng] for lat, lng in zip(End_lats, End_lngs)])
    End_clusters = kmeans.predict(End_coords)
    df['End_Cluster'] = End_clusters
    #print(df)
    df.to_csv('Data/date_formatted_clustered_bike_data.csv')
 

def plotDifferenecesonMap():

    m = folium.Map([51.4545, -2.58], zoom_start=13)
    n_bins = 100;
    (lat_min, lat_max) = (51.427563, 51.481476)
    (lng_min, lng_max) = (-2.631043, -2.544795)
    
    lat_range = np.linspace(lat_min, lat_max, n_bins);
    lng_range = np.linspace(lng_min, lng_max, n_bins);
    
    lat_res = (lat_range[1] - lat_range[0])/2
    lng_res = (lng_range[1] - lng_range[0])/2
    
    data = loadmat('Data/latlngdiff.mat')
    llds = data['lld']
    #llds = llds[:1000]
    Diffs = [Diff for Lat, Lng, Diff in llds]
    Diff_max = max(Diffs)
    Diff_min = min(Diffs)
    
    bar = Bar('Plotting Tiles', max=len(Diffs))
    for lld in llds:
        Lat, Lng, Diff = lld
        #print(Lat, Lng, Diff)
        bounds = [[Lat+lat_res, Lng-lng_res],[Lat-lat_res, Lng+lng_res]]
        opacity = Diff/51.428652
        if opacity > 0:
            folium.Rectangle(
            bounds,
            color='#00ff00',
            fill='#00ff00',
            opacity=Diff/51.428652,
            fill_opacity=Diff/51.428652,
            tooltip = str((Diff))
            ).add_to(m)
        else:
            folium.Rectangle(
            bounds,
            color='#ff0000',
            fill='#ff0000',
            opacity=abs(Diff/51.428652),
            fill_opacity=abs(Diff/51.428652),
            tooltip = str((Diff))
            ).add_to(m)
                   
        bar.next()
    bar.finish()
    m.save('Maps/Differences.html')


def plotSumsonMap():

    m = folium.Map([51.4545, -2.58], zoom_start=13)
    n_bins = 100;
    (lat_min, lat_max) = (51.427563, 51.481476)
    (lng_min, lng_max) = (-2.631043, -2.544795)
    
    lat_range = np.linspace(lat_min, lat_max, n_bins);
    lng_range = np.linspace(lng_min, lng_max, n_bins);
    
    lat_res = (lat_range[1] - lat_range[0])/2
    lng_res = (lng_range[1] - lng_range[0])/2
    
    data = loadmat('Data/latlngthetasum.mat')
    lltss = data['llts']
    #lltss = lltss[:200]
    Sums = [Sum for Lat, Lng, Theta, Sum in lltss]
    Sum_max = max(Sums)
    
    bar = Bar('Plotting Tiles', max=len(Sums))
    for llts in lltss:
        Lat, Lng, Theta, Sum = llts
        bounds = [[Lat+lat_res, Lng-lng_res],[Lat-lat_res, Lng+lng_res]]
        opacity = Sum/Sum_max
        folium.Rectangle(
            bounds,
            color='#0000ff',
            fill='#0000ff',
            opacity=opacity,
            fill_opacity=opacity,
            tooltip = str((Sum))
        ).add_to(m)
        bar.next()
    bar.finish()
    m.save('Maps/TotalDepartures.html')
    

def plotMapOverTime(df):
    # Weekday in August
    #df_August = df[df['Month'] == 8]
    #df_plot = df_plot[df_plot['Weekday'] != 5]
    #df_plot = df_plot[df_plot['Weekday'] != 6]
    #df_plot = df[df['Hour'] == 8]
    df_plot = df
    df_centre = df_plot[df_plot['End_Distance'] < 2.5]
    df_plot = df_centre[['End_Lat','End_Lng']].round(5)
    df_plot['Hour'] = df_centre['Hour']

    #df_plot = df_plot[df_plot['hour'] == 2]

    m = folium.Map([51.4545, -2.58], zoom_start=13)

    bike_data = [[[row['End_Lat'],row['End_Lng']] for index, row in df_plot[df_plot['Hour'] == i].iterrows()] for i in range(0,23)]
    hm = plugins.HeatMapWithTime(bike_data,auto_play=True,max_opacity=0.8, radius=15)
    hm.add_to(m)

    m.save("Maps/HeatMap.html")


def getWayPoints(start, end):
   
    gmaps = googlemaps.Client(key='AIzaSyAC8KbHeJUsgG1h4qMcEAFjKHFd61mQSHo')
    dirs  = gmaps.directions(start, end, mode='bicycling')
    points = []
    try:
        waypoints = dirs[0]['legs'][0]['steps']
        
        for waypoint in waypoints:
            line = waypoint['polyline']['points']
            plot_points = decode_polyline(line)
            points.extend(plot_points)
        
    except:
        IndexError

    return points

    
def plotUsedRoads(df):

    day = 0
    hour = 12
    
    dist = 3
    df = df[df['Begin_Distance'] < dist]
    df = df[df['End_Distance'] < dist]

    #df_line = df[df['Month'] == 8]
    #df_line = df[df['Weekday'] == day]
    print(df.head())
    df_line = df[df['Hour'] == hour]
    print(len(df))
    df_line = df_line.head(2400)

    m2 = folium.Map([51.4545, -2.58], zoom_start=13)
    # heat_data = [(lat, lng) for lat, lng in zip(df_line['End_Lat'], df_line['End_Lng'])]
    # hm = plugins.HeatMap(heat_data)
    # m2.add_child(hm)
    bar = Bar('Plotting Roads', max=len(df_line))
    for ind, row in df_line.iterrows():
        
        start = row.Begin_Lat, row.Begin_Lng
        end = row.End_Lat, row.End_Lng
        points = getWayPoints(start, end)
        folium.PolyLine(points, color='blue', weight=5, opacity=0.2).add_to(m2)
        
        bar.next()
    bar.finish()
    m2.save('Maps/RoadMap_{}.html'.format(hour))

    
def decode_polyline(polyline_str):
    
    index, lat, lng = 0, 0, 0
    coordinates = []
    changes = {'latitude': 0, 'longitude': 0}

    # Coordinates have variable length when encoded, so just keep
    # track of whether we've hit the end of the string. In each
    # while loop iteration, a single coordinate is decoded.
    while index < len(polyline_str):
        # Gather lat/lon changes, store them in a dictionary to apply them later
        for unit in ['latitude', 'longitude']: 
            shift, result = 0, 0

            while True:
                byte = ord(polyline_str[index]) - 63
                index+=1
                result |= (byte & 0x1f) << shift
                shift += 5
                if not byte >= 0x20:
                    break

            if (result & 1):
                changes[unit] = ~(result >> 1)
            else:
                changes[unit] = (result >> 1)

        lat += changes['latitude']
        lng += changes['longitude']

        coordinates.append((lat / 100000.0, lng / 100000.0))

    return coordinates
    
    
def main():
    data_file = 'Data/date_formatted_bike_data.csv'
    df = pd.read_csv(data_file)
    #df = df[df['End_Distance'] > 3]
    #plotUsedRoads(df)
    #plotDifferenecesonMap()
    #plotClusters(df)
    plotLinksBetweenClusters()

if __name__ == '__main__':
    main()