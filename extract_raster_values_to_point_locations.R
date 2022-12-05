# for Abdul-Hassan: example script for simple extraction from raster data to point locations
# J. Chamberlin 220902

# set up
library(terra)
library(sp)
library(sf)

setwd("C:/projects/Abdul-Hassan/") # <-- CHANGE YOUR DIRECTORY HERE
list.files()

# bring in points
tmp <- read.csv(file="Location_data.csv") 
dim(tmp)
tmp <- na.omit(tmp) 
dim(tmp)
head(tmp)

vilpts <- SpatialPointsDataFrame(coords=tmp[,c(4,5)], data=tmp[,-c(4,5)], proj4string = CRS(" +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))
vilpts[1:10,]
names(vilpts)

#view points
plot(vilpts, axes=T)

# convert to SpatVector object
v <- st_as_sf(vilpts) ## need to first convert to sf object
v <- terra::vect(v)


# bring in raster data
list.files(path="C:/DATA/Ghana/spatial/WorldPop", pattern=".tif$")
r <- rast("C:/DATA/Ghana/spatial/WorldPop/gha_pd_2020_1km.tif") 
r

# plot to visualize
plot(r, axes=TRUE)
plot(v, add=TRUE)

# extract raster values at point locations
#v[["pd2020"]] <- terra::extract(r,v)
myext <- terra::extract(r,v)

# merge extracted values back into dataframe 
vilpts[["pd2020"]] <- myext[,2]
head(vilpts)

# write output to disk
write.csv(vilpts, file="Location_data_extracted.csv")
