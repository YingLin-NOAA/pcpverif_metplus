#!/usr/bin/env python

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap, cm
#from matplotlib import GridSpec, rcParams, colors
from matplotlib import colors as c
from pylab import *
import numpy as np
import pygrib, datetime, time, os, sys, subprocess
import ncepy
from ncepgrib2 import Grib2Encode, Grib2Decode
from ncepy import gem_color_list
from netCDF4 import Dataset as NetCDFFile

# originally from Logan Dawson, 2019/06/12

infile=sys.argv[1]
nc = NetCDFFile(infile)
apcp = nc.variables['APCP_24'][:,:]
print 'min max values=', np.min(apcp),'   ', np.max(apcp)


# err msg:
#   latcorners = nc.variables['lat_ll'][:]
#   KeyError: 'lat_ll'
# latcorners = nc.variables['lat_ll'][:]
# loncorners = nc.variables['lon_ll'][:]

lons = nc.variables['lon'][:]
lats = nc.variables['lat'][:]
print 'min max lons=', np.min(lons),'   ', np.max(lons)
print 'min max lats=', np.min(lats),'   ', np.max(lats)

lon_0 = np.float(nc.lon_ll.split(' ')[0])
lat_0 = np.float(nc.lat_ll.split(' ')[0])
print 'lat_0,lon_0=', lat_0,lon_0

# Now Plot

fig = plt.figure(figsize=(6.9,4.9))
ax = fig.add_axes([0.1,0.1,0.8,0.8])

m = Basemap(llcrnrlon=-121.5,llcrnrlat=22.,urcrnrlon=-64.5,urcrnrlat=48.,\
               resolution='i',projection='lcc',\
               lat_1=32.,lat_2=46.,lon_0=-101.,area_thresh=1000.,ax=ax)

m.drawcoastlines()
m.drawstates(linewidth=0.25)
m.drawcountries()

#   xlons, xlats = np.meshgrid(loncorners,latcorners)
#   xlons, xlats = np.meshgrid(lon_0,lat_0)
xlons, xlats = np.meshgrid(lons,lats)
xi, yi = m(xlons,xlats)

# Set contour levels for precip    
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

# Set up the colormap and normalize it so things look nice
cf = m.contourf(xi,yi,apcp,clevs,cmap=mycmap,norm=norm,extend='max')
cf.set_clim(0,175) 
# add colorbar.
cbar = m.colorbar(cf,location='bottom',pad="5%",ticks=clevs,format='%.1f')    
cbar.ax.tick_params(labelsize=7.0)    
cbar.set_label('mm')

# get input file name w/o the leading directory path, to be used in plot
# title and png file name:
path, filename = os.path.split(infile)
plt.title(filename)
plt.savefig(filename+'.png',bbox_inches='tight')

plt.close()

