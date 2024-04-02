# With raster package 
library(raster)

countries <- c ("BEN", "BFA", "ETH", "IND", "KEN", "MDG", "TUN")

downloadAlt <- function(country){
  
  alt <- getData(name = "alt", country = country, path=".", mask=TRUE)
  writeRaster(alt, paste0("data/", country, ".tif"))
}

lapply(countries, downloadAlt)

# Generate hill shade for all the countries
# Requires slope and aspect layers

generateHill <- function(country){
  
  r <- raster(paste0("data/", country, ".tif"))
  s <- raster::terrain(r, opt="slope")
  a <- raster::terrain(r, opt="aspect")
  
  # hill shade
  h <- raster::hillShade(slope = s, aspect = a, 40, 270)
  plot(h)
  
  writeRaster(h, paste0("data/hillshade/", country, ".tif"))
}

lapply(countries, generateHill)

# Correcting India hillshade to suit HDX boundary
countries <- c("CHN", "PAK")
lapply(countries, downloadAlt)

# Merging rasters from China and Pakistan
r <- raster("data/hillshade/CHN.tif")
r1 <- raster("data/hillshade/IND.tif")
r2 <- raster("data/hillshade/PAK.tif")

x <- list(r, r1, r2)
rr <- do.call(merge, x)
writeRaster(rr, "data/hillshade/india.tif")

# alt = getData('alt', ken)
# slope = terrain(alt, opt='slope')
# aspect = terrain(alt, opt='aspect')
# hill = hillShade(slope, aspect, 40, 270)
# plot(hill, col=grey(0:100/100), legend=FALSE, main='KENYA')
# plot(alt, col=rainbow(25, alpha=0.35), add=TRUE)