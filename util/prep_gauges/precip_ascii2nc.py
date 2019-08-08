#############################################################################
##### Import python modules
import os
import numpy as np
import subprocess
#############################################################################
##### Read in data and set variable 
precip_obs_dir = os.environ['gauge_dir']
DATA_OUTgauge = os.environ['DATA_OUTgauge']
model_var = os.environ['model_var']
vyyyymmdd = os.environ['vday']
#############################################################################
##### Set file specifications
usa_dlyprcp_file = str(precip_obs_dir)+'/good-usa-dlyprcp-'+str(vyyyymmdd)
usa_dlyprcp_file_ascii2nc_format = str(DATA_OUTgauge)+'/good-usa-dlyprcp-'+str(vyyyymmdd)+'_formatted'
usa_dlyprcp_file_nc = str(DATA_OUTgauge)+'/good-usa-dlyprcp-'+str(vyyyymmdd)+'.nc' 
#############################################################################
##### Read data file and put in array
data = list()
l = 0
nstations = 0
print('READING: '+str(usa_dlyprcp_file)+'\n')
with open(usa_dlyprcp_file) as f:
   for line in f:
#       if l > 1:
#   Original usa-dlyprcp files have a 2-line header.  QC'd dlyprcp has no 
#   header line at all, so we start with line '0'. 
       if l > -1:
          nstations += 1
          line_split = line.split()
          col = len(line_split)
          if col != 5:
             print('BAD LINE at '+str(nstations)+', number of columns not what was expected (5). Please check data file, '+usa_dlyprcp_file)
             exit()
          data.append(line_split)
       l+=1
print('NUMBER OF STATIONS: '+str(nstations)+'\n')
data_array = np.asarray(data)
station_lat = data_array[:,0]
station_lon = data_array[:,1]  
station_lon[:] = ['-'+x for x in station_lon]
#print station_lon
print 'first station_lon', station_lon[0]
print '101-th station_lon', station_lon[100]
station_prcp = data_array[:,2] # unit of precip amt is inches
station_id = data_array[:,3]
station_hour = data_array[:,4]
date = vyyyymmdd  # vyyyymmdd exported from calling script
print('FORMATTING FOR METS ASCII2NC TOOL'+'\n')
#format example, ADPSFC PECA2 20171210_180000 57.96 -136.23 45 APCP 24 0 NA 1.61
for n in range(nstations):
    #column 1
    message_type_now = 'ADPSFC'
    #column 2
    station_id_now = station_id[n].strip()
    #column 3
    station_hour_now = station_hour[n]
    station_hour_now_HHMM = station_hour_now.strip().zfill(4)
    valid_time_now = date+'_'+station_hour_now_HHMM+'00'
    #column 4
    lat_now = station_lat[n].strip()
    #column 5
    lon_now = station_lon[n].strip()
    #column 6
    #elev_now = station_elev[n].strip()
    #if elev_now == '--':
    #   elev_now = 'NA'
    elev_now = '-9999.00'
    #column 7
    variable_name_now = '61'
    #column 8
    level_now = '24'
    #column 9 
    #height_now = '0'
    height_now = '-9999.00'
    #column 10
    qc_string_now = 'NA'
    #column 11
    observation_value_now = str(float(station_prcp[n].strip()) * 25.4) #CHANGE UNITS TO MM
    #write to file
    if os.path.exists(usa_dlyprcp_file_ascii2nc_format):
         append_write = 'a' # append if already exists
    else:
         append_write = 'w' # make a new file if not
    usa_dlyprcp_file_ascii2nc_format_openfile = open(usa_dlyprcp_file_ascii2nc_format,append_write)
    usa_dlyprcp_file_ascii2nc_format_openfile.write(message_type_now+' '+station_id_now+' '+valid_time_now+' '+lat_now+' '+lon_now+' '+elev_now+' '+variable_name_now+' '+level_now+' '+height_now+' '+qc_string_now+' '+observation_value_now+'\n')
    usa_dlyprcp_file_ascii2nc_format_openfile.close()
print('FORMATTED FILE SAVED TO: '+str(usa_dlyprcp_file_ascii2nc_format)+'\n')
os.system("ascii2nc "+usa_dlyprcp_file_ascii2nc_format+" "+usa_dlyprcp_file_nc)
#p = subprocess.Popen(["ascii2nc", usa_dlyprcp_file_ascii2nc_format, usa_dlyprcp_file_nc], stdout=subprocess.PIPE)
#out, err = p.communicate()
print('ASCII2NC FILE SAVED TO: '+str(usa_dlyprcp_file_nc)+'\n')
