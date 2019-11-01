#!/bin/env python
import matplotlib
from mpl_toolkits.basemap import Basemap, cm
from ncepy import gem_color_list
# Plot precip from netCDF files.  
# requires netcdf4-python (netcdf4-python.googlecode.com)
# YL: example from https://matplotlib.org/basemap/users/examples.html
#   with minor changes.  
#   Note that it does not work with current AHPS netCDF files such as
#   nws_precip_1day_20180512_conus.nc
# 2018/05/18: Jacob got it to work for nc sum of ST4 from pcp_combine!
# 2019/09/12: YL modified to work for LCC projection
#
# 1st argument: nc file
# 2nd argument: domain
#   wexp, conus, nw, colo    
#   conus plot in lcc projection, the others are in cyl.  

from netCDF4 import Dataset as NetCDFFile
import numpy as np
import matplotlib.pyplot as plt
import sys

# 

print "Number of arguments: ", len(sys.argv)
print "0th argument: ", sys.argv[0]
print "1st argument: ", sys.argv[1]
print "2st argument: ", sys.argv[2]
infile=sys.argv[1] # read file from cmd line
domain=sys.argv[2] # read file from cmd line


varname='APCP_24'

nc =  NetCDFFile(infile) 

data = nc.variables[varname][:,:] #i think this is already mm
print 'min max values=', np.min(data),'   ', np.max(data)
lats = nc.variables['lat'][:,:]
lons = nc.variables['lon'][:,:]
#lon_0 = np.float(nc.lon_orient.split(' ')[0]) # was tiny bit trickier since a string was stored with the float
#lat_0=np.float(nc.scale_lat.split(' ')[0]) # was tiny bit trickier since a string was stored with the float

# create figure and axes instances
fig = plt.figure(figsize=(8,8))
ax = fig.add_axes([0.1,0.1,0.8,0.8])
# create polar stereographic Basemap instance.
if domain == 'wexp':
  llcrnrlon=-139
  llcrnrlat=18
  urcrnrlon=-58
  urcrnrlat=58
  m = Basemap(projection='cyl',llcrnrlon=llcrnrlon,llcrnrlat=llcrnrlat,
                               urcrnrlon=urcrnrlon,urcrnrlat=urcrnrlat,
                               resolution='l')
elif domain == 'conus':
  llcrnrlon=-120
  llcrnrlat=19
  urcrnrlon=-57
  urcrnrlat=50
  m = Basemap(projection='lcc', llcrnrlon=llcrnrlon,llcrnrlat=llcrnrlat,
                               urcrnrlon=urcrnrlon,urcrnrlat=urcrnrlat,
                               resolution='l',lat_1=33,lat_2=45,lon_0=-95)

if domain == 'nw':
  llcrnrlon=-128
  llcrnrlat=35
  urcrnrlon=-107
  urcrnrlat=55
  m = Basemap(projection='cyl',llcrnrlon=llcrnrlon,llcrnrlat=llcrnrlat,
                               urcrnrlon=urcrnrlon,urcrnrlat=urcrnrlat,
                               resolution='l')

elif domain == 'colo':
  llcrnrlon=-112
  llcrnrlat=35
  urcrnrlon=-100
  urcrnrlat=45
  m = Basemap(projection='cyl',llcrnrlon=llcrnrlon,llcrnrlat=llcrnrlat,
                               urcrnrlon=urcrnrlon,urcrnrlat=urcrnrlat,
                               resolution='l')

# draw coastlines, state and country boundaries, edge of map.
m.drawcoastlines()
m.drawstates()
m.drawcountries()
# draw parallels.
parallels = np.arange(0.,90,10.)
m.drawparallels(parallels,labels=[1,0,0,0],fontsize=10)
# draw meridians
meridians = np.arange(180.,360.,10.)
m.drawmeridians(meridians,labels=[0,0,0,1],fontsize=10)
#ny = data.shape[0]; nx = data.shape[1]
#lons, lats = m.makegrid(nx, ny) # get lat/lons of ny by nx evenly space grid.
#x, y = m(lons, lats) # compute map proj coordinates.
# draw filled contours.
clevs = [0,0.1,2,5,10,15,20,25,35,50,75,100,125,150,175]
#Use gempak color table for precipitation
gemlist=gem_color_list()
pcplist=[31,23,22,21,20,19,10,17,16,15,14,29,28,24,25]
#Extract these colors to a new list for plotting
pcolors=[gemlist[i] for i in pcplist]
# Set up the colormap and normalize it so things look nice
mycmap=matplotlib.colors.ListedColormap(pcolors)
norm = matplotlib.colors.BoundaryNorm(clevs, mycmap.N)

cs = m.contourf(lons,lats,data,clevs,cmap=mycmap,norm=norm,latlon=True)
# add colorbar.
cbar = m.colorbar(cs,location='bottom',pad="5%")
cbar.set_label('mm')
# add title
plt.title(infile)
#plt.show()
plt.savefig(infile+'.png',bbox_inches='tight')
