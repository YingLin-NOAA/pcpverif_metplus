#!/usr/bin/env python
import netCDF4
import numpy as np
import os, sys, datetime, time, subprocess
import re, csv, glob
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap, cm
import matplotlib.pyplot as plt
import ncepy
from ncepy import gem_color_list

infile = str(sys.argv[1])
path, filename = os.path.split(infile)

nc = netCDF4.Dataset(infile,'r')

#read 2D lat/lon data
grid_lats = nc.variables['lat'][:]
grid_lons = nc.variables['lon'][:]
data = nc.variables['APCP_24'][:]


fig = plt.figure(figsize=(10.9,8.9))

ax = fig.add_axes([0.1,0.1,0.8,0.8])

#m = Basemap(llcrnrlon=-121.5,llcrnrlat=22.,urcrnrlon=-64.5,urcrnrlat=48.,\
#            resolution='i',projection='lcc',\
#            lat_1=32.,lat_2=46.,lon_0=-101.,area_thresh=1000.,ax=ax)

m = Basemap(llcrnrlon=-123,llcrnrlat=17.,urcrnrlon=-55,urcrnrlat=51.,\
            resolution='i',projection='lcc',\
            lat_1=32.,lat_2=46.,lon_0=-101.,area_thresh=1000.,ax=ax)

m.drawcoastlines()
m.drawstates(linewidth=0.75)
m.drawcountries()
latlongrid = 10.
parallels = np.arange(-90.,91.,latlongrid)
m.drawparallels(parallels,labels=[1,0,0,0],fontsize=10)
meridians = np.arange(0.,360.,latlongrid)
m.drawmeridians(meridians,labels=[0,0,0,1],fontsize=10)


clevs = [0,0.1,2,5,10,15,20,25,35,50,75,100,125,150,175]
#Use gempak color table for precipitation
gemlist=gem_color_list()
# Use gempak fline color levels from pcp verif page
colorlist=[31,23,22,21,20,19,10,17,16,15,14,29,28,24,25]
#Extract these colors to a new list for plotting
pcolors=[gemlist[i] for i in colorlist]

# Set up the colormap and normalize it so things look nice
mycmap=matplotlib.colors.ListedColormap(pcolors)
norm = matplotlib.colors.BoundaryNorm(clevs, mycmap.N)

#contourf
fill = m.contourf(grid_lons,grid_lats,data,clevs,latlon=True,cmap=mycmap,norm=norm,extend='max')

cbar = plt.colorbar(fill,ax=ax,ticks=clevs,orientation='horizontal',pad=0.04,shrink=0.75,aspect=20)
cbar.ax.tick_params(labelsize=10)
cbar.set_label('mm/day')
plt.title(filename)
plt.savefig(filename+'.png',bbox_inches='tight',figsize=(4.8,3.2))
plt.close()



