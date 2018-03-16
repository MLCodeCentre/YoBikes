import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.pyplot as plt
import seaborn as sns
from geopy.distance import vincenty
import folium
import folium.plugins as plugins
import numpy as np
#sns.palplot(sns.color_palette("Blues_d"))


def formatDates():

    data_file = 'Data/Riding Data for U. of Bristol.csv'
    print('loading data')
    df = pd.read_csv(data_file)
    #df = df.head(20)
    print(df.head())
    print('formatting dates')
    df['Begin_Time'] = pd.to_datetime(df['Begin_Time'], format='%d/%m/%y %H:%M')
    df['End_Time'] = pd.to_datetime(df['End_Time'], format='%d/%m/%y %H:%M')
    #df["Begin_Time"] = df["Begin_Time"].astype("datetime64[ns]")
    #df["End_Time"] = df["End_Time"].astype("datetime64[ns]")
    

    # getting months, weekdays, and duration of trip
    df['Month'] = df["Begin_Time"].dt.month
    df['Weekday'] = df["Begin_Time"].dt.dayofweek
    df['Hour'] = df["Begin_Time"].dt.hour
    df['Year'] = df["Begin_Time"].dt.year
    df['DoY'] = df["Begin_Time"].dt.dayofyear
    
    seasons = []
    bristol_centre = (51.454514, -2.587910)
    begin_distances = []
    end_distances = []

    for ind, row in df.iterrows():
        if row.Month in [12, 1, 2]:
            season = 'Winter'
        elif row.Month in [3, 4, 5]:
            season = 'Spring'
        elif row.Month in [6, 7, 8]:
            season = 'Summer'
        elif row.Month in [9, 10, 11]:
            season = 'Autumn'	
        seasons.append(season)

        end_distances.append(vincenty((row.End_Lat, row.End_Lng), bristol_centre).km)
        begin_distances.append(vincenty((row.Begin_Lat, row.Begin_Lng), bristol_centre).km)

    seasons = pd.Series(seasons)
    df['Season'] = seasons.values

    end_distances = pd.Series(end_distances)
    df['End_Distance'] = end_distances
    begin_distances = pd.Series(begin_distances)
    df['Begin_Distance'] = begin_distances
   
    
    df['Duration'] = (df["End_Time"] - df["Begin_Time"]).astype('timedelta64[m]')
    df['Distance'] = (abs(df['End_Distance'] - df['Begin_Distance']))
    df['Speed'] = 60 * df['Distance'] / df['Duration']
    print(df.head())
    print('saving data')
    df.to_csv('Data/date_formatted_bike_data.csv')


def plotTripHist(df):
    
    plt.figure()
    df['Duration'].hist(bins=60, edgecolor='black')
    plt.xlabel('Trip Duration [m]')
    plt.ylabel('Percentage of Trips')
    plt.title('Trip Duration Histogram')


def plotSeasonalBarplot(df):

    plt.figure()
    df2 = df.groupby(['Hour', 'Season'])['Hour'].count().unstack('Season')
    df2[['Winter','Spring','Summer','Autumn']].plot.bar(stacked=False)
    plt.xlabel('Hour of the day')
    plt.ylabel('Total Number of Trips')
    plt.title('Trips at each hour of the day for each Season')


def plotDistancesFromCentre(df):

    plt.figure()
    df = df[df['Begin_Distance'] < 20]
    df['Begin_Distance'].hist(bins=100, edgecolor='black')
    plt.xlabel('Trip Begin Distance from Centre [m]')
    plt.ylabel('Number of Trips')
    plt.title('Trip Begin Distance from Centre Histogram')
    #plt.ylim([0,0.1])


def plotHourBarPlot(df):

    plt.figure()
    df = df[df['Begin_Distance'] < 3]
    df = df[df['Begin_Distance'] > 1]
    df['Hour'].value_counts().sort_index().plot.bar()
    plt.xlabel('Hour of the day')
    plt.ylabel('Number of Trips')

def plotTripHistOutsideCentre(df, distance):

    plt.figure()
    df = df[df['Distance'] > distance]
    df['Duration'].hist(bins=60, edgecolor='black')
    plt.xlabel('Trip Duration [m]')
    plt.ylabel('Number of Trips')
    plt.title('Trip Duration Histogram outside the City Centre')
    plt.ylim([0,0.1])


def plotTripHistInsideCentre(df, distance):

    plt.figure()
    df = df[df['Distance'] < distance]
    df['Duration'].hist(bins=60, edgecolor='black', normed=1)
    plt.xlabel('Trip Duration [m]')
    plt.ylabel('Percentage of Trips')
    plt.title('Trip Duration Histogram inside the City Centre')
    plt.ylim([0,0.1])


def main():

    formatDates()
    # data_file = 'Data/date_formatted_bike_data.csv'
    # df = pd.read_csv(data_file)
    
    # # showing usageage histogram
    # df = df[df['Duration'] < 120]
    # df = df[df['Duration'] > 5]
    
    # print(df.head())
    #plotTripHistOutsideCentre(df,3)
    #plotTripHistInsideCentre(df,3)
    #plotDistancesFromCentre(df)
    #plotHourBarPlot(df)
    #plotMapOverTime(df)
    #plt.show()


if __name__ == '__main__':
    main()
