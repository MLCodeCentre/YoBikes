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
from scipy.spatial import Voronoi, voronoi_plot_2d
from geopy.distance import vincenty

def plotClusterAndPolygons():
    
    cluster_df = pd.read_csv('Data/clusters.csv')
    print('{} Trip Start and Ends found'.format(cluster_df['Cluster_Begin_End_Number'].sum()))
    print('And Therefore {} Trips found'.format(str(cluster_df['Cluster_Begin_End_Number'].sum()/2)))
    cluster_type_df = pd.read_csv('Data/cluster_types.csv')
    
    colors = {'1': 	'#FF0000',
              '2':  '#008000',
              '3':  '#0000FF',
              '4':  '#FF00FF',
              '5':  '#800080'}
    
    ODM = loadmat('Data/ODM.mat')
    ODM = np.array(ODM['ODM'])

    m = folium.Map([51.4545, -2.58], zoom_start=13)
       
    print('plotting clusters')
   
    for cluster_origin in range(1,293):
        
        cluster_origin_info = cluster_df[cluster_df['Cluster_ID']==cluster_origin]
        cluster_type_info = cluster_type_df[cluster_type_df['Var1']==cluster_origin]
        cluster_type = str(int((cluster_type_info['cluster_type'])))
        print(cluster_type)
        color = colors[cluster_type]
        origin_lat = float(cluster_origin_info['Cluster_Lat'])
        origin_lng = float(cluster_origin_info['Cluster_Lng'])

     
        folium.CircleMarker(location=[origin_lat, origin_lng],
                            color=color,
                            fill=True,
                            fill_color=color).add_to(m)
        
        folium.Marker([origin_lat, origin_lng],
                      icon=DivIcon(
                      icon_size=(150,36),
                      icon_anchor=(0,0),
                      html='<div style="font-size: 12pt; font-weight: bold">{}</div>'.format(str(cluster_origin)),
                            )
                      ).add_to(m)
                        
    print('calculating polygons')

    points = [[float(cluster['Cluster_Lat']), float(cluster['Cluster_Lng'])] for ind, cluster in cluster_df.iterrows()]
    vor = Voronoi(points)
    print('drawing polygons')
    bristol_centre = ((51.454514, -2.587910))
    for vpair in vor.ridge_vertices:
        if vpair[0] >= 0 and vpair[1] >= 0:
            v0 = vor.vertices[vpair[0]]
            v1 = vor.vertices[vpair[1]]
            v0 = [float(v) for v in v0]
            v1 = [float(v) for v in v1]
            if vincenty(v0, bristol_centre).km < 10 and vincenty(v1, bristol_centre).km < 10:
            # Draw a line from v0 to v1.
                folium.PolyLine(([v0,v1]), opacity = 0.4, color='#101010').add_to(m)
    
    m.save('Maps/Clusters.html') 

def plotLinksBetweenClusters():

    ODM = loadmat('Data/ODM_norm_mirror.mat')
    ODM = np.array(ODM['ODM_norm_mirror'])
    cluster_df = pd.read_csv('Data/clusters.csv')
    m = folium.Map([51.4545, -2.58], zoom_start=13)
    cluster_paths = json.load(open('Data/cluster_paths.json'))
    
    #print(cluster_df)

    for cluster_origin in range(1,293):
        
        cluster_origin_info = cluster_df[cluster_df['Cluster_Number']==cluster_origin]
        #print(int(cluster_origin_info['Cluster_Members']))
        radius = float((15*cluster_origin_info['Cluster_Members']/2000))
        #print(radius)
        origin_lat = float(cluster_origin_info['Lat'])
        origin_lng = float(cluster_origin_info['Lng'])
              
        folium.CircleMarker(location=[origin_lat, origin_lng],
                            radius=radius,
                            color=color,
                            fill_color=color,
                            tooltip = 'Cluster {}, {} Trip End or Starts'.format(cluster_origin, str(int(cluster_origin_info['Cluster_Members'])))).add_to(m)
        folium.Marker([origin_lat, origin_lng],
                      icon=DivIcon(
                      icon_size=(150,36),
                      icon_anchor=(0,0),
                      html='<div style="font-size: 18pt; font-weight: bold">{}</div>'.format(str(cluster_origin)),
                            )
                        ).add_to(m)
        
        ODM_Cluster = ODM[cluster_origin, :]
        for cluster_dest, weight in enumerate(ODM_Cluster):
            if weight > 0.5:
                cluster_dest_info = cluster_df[cluster_df['Cluster_Number']==cluster_dest]

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
                    cluster_paths[key] = pointsacti
                
                opacity = weight/0.01
                folium.PolyLine(points,
                                tooltip = 'Cluster {} and Cluster {}: {}'.format(cluster_origin, cluster_dest, str(weight)[:6]),
                                opacity = opacity).add_to(m)
                
            
    m.save('Maps/ClusterLinks.html') 
    with open('Data/cluster_paths.json', 'w') as outfile:
        json.dump(cluster_paths, outfile)
           

def generateHTML(cluster_origin, trip_start_and_ends, cluster_type, difference, lat, lng):

    google_url = "http://maps.google.com/maps?q=&layer=c&cbll={},{}&cbp=11,0,0,0,0".format(lat,lng)
    graph_url = "file:///C:/Users/ts1454/YoBikes/Images/Connection%20Distributions/{}.png".format(cluster_origin)

    html="""
    <h3>Cluster {}</h3>
    <p>
    Total trips: <b>{}</b><br>
    {} size: <b>{}</b>
    </p>
    <a href={}>Google street view</a>
    <a href={}>Connection Distribution</a>
    """.format(cluster_origin, trip_start_and_ends, cluster_type, difference, google_url, graph_url, graph_url)
    return html
   

def plotClusterDifferences():
    
    cluster_df = pd.read_csv('Data/clusters.csv')
    print('{} Trip Start and Ends found'.format(cluster_df['Cluster_Begin_End_Number'].sum()))
    print('And Therefore {} Trips found'.format(str(cluster_df['Cluster_Begin_End_Number'].sum()/2)))


    ODM = loadmat('Data/ODM.mat')
    ODM = np.array(ODM['ODM'])

    m = folium.Map([51.4545, -2.58], zoom_start=13)
       
    print('plotting clusters')

    for cluster_origin in range(1,293):
        
        cluster_origin_info = cluster_df[cluster_df['Cluster_ID']==cluster_origin]
        #print(cluster_origin_info)
        
        origin_lat = float(cluster_origin_info['Cluster_Lat'])
        origin_lng = float(cluster_origin_info['Cluster_Lng'])

        bikes_leaving_cluster = int(cluster_origin_info['Cluster_Begin_Number'])
        bikes_arriving_cluster = int(cluster_origin_info['Cluster_End_Number'])
        
        total = bikes_arriving_cluster + bikes_leaving_cluster
        difference = bikes_arriving_cluster - bikes_leaving_cluster

        if difference > 0:
            color ='#3186cc'
            cluster_type = 'Sink'
        else:
            color = '#cc3139'
            cluster_type = 'Source'

        circle_opacity = min(0.9,(abs(difference)/500))
        radius = min(20,20*np.sqrt((abs(total)/3000)))

        print(difference, circle_opacity, total, radius)
        
        trip_start_and_ends = float(cluster_origin_info['Cluster_Begin_End_Number'])
        # text = 'Cluster {}, {} Trip End or Starts. {} size {}'.format(str(cluster_origin), str(trip_start_and_ends),
                                                                        #cluster_type, str(difference))

        html = generateHTML(cluster_origin, total, cluster_type, difference, origin_lat, origin_lng)

        #iframe = folium.element.IFrame(html=html, width=500, height=300)
        #popup = folium.Popup(iframe, max_width=2650)

        
        #print(text)
     
        folium.CircleMarker(location=[origin_lat, origin_lng],
                            radius=radius,
                            color='#101010',
                            fill=True,
                            fill_color=color,
                            popup = html,
                            fill_opacity = circle_opacity).add_to(m)
        folium.Marker([origin_lat, origin_lng],
                      icon=DivIcon(
                      icon_size=(150,36),
                      icon_anchor=(0,0),
                      html='<div style="font-size: 12pt; font-weight: bold">{}</div>'.format(str(cluster_origin)),
                            )
                      ).add_to(m)
                        
    print('calculating polygons')

    points = [[float(cluster['Cluster_Lat']), float(cluster['Cluster_Lng'])] for ind, cluster in cluster_df.iterrows()]
    vor = Voronoi(points)
    print('drawing polygons')
    bristol_centre = ((51.454514, -2.587910))
    for vpair in vor.ridge_vertices:
        if vpair[0] >= 0 and vpair[1] >= 0:
            v0 = vor.vertices[vpair[0]]
            v1 = vor.vertices[vpair[1]]
            v0 = [float(v) for v in v0]
            v1 = [float(v) for v in v1]
            if vincenty(v0, bristol_centre).km < 10 and vincenty(v1, bristol_centre).km < 10:
            # Draw a line from v0 to v1.
                folium.PolyLine(([v0,v1]), opacity = 0.4, color='#101010').add_to(m)
    
    m.save('Maps/ClusterSinkSource.html') 

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
    #data_file = 'Data/date_formatted_bike_data.csv'
    #df = pd.read_csv(data_file)
    #df = df[df['End_Distance'] > 3]
    #plotUsedRoads(df)
    #plotDifferenecesonMap()
    #plotClusterAndPolygons()
    plotClusterDifferences()
    #plotLinksBetweenClusters()

if __name__ == '__main__':
    main()