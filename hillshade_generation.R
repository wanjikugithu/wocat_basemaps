# Generate hill shade for SLM Maps in several countries
# Countries - BEN, BFA, ETH, IND, KEN, MDG, TUN
library(terra)
library(geodata)

countries <- c ("BEN", "BFA", "ETH", "IND", "KEN", "MDG", "TUN")

# Download elevation data for the 7 countries

downloadElev <- function(country){
  
  e <- elevation_30s(country, path=".", mask=TRUE)
  writeRaster(e, paste0("data/", country, ".tif"))
}

lapply(countries, downloadElev)

# Generate hill shade for all the countries
# Requires slope and aspect layers

generateHill <- function(country){
  
  r <- rast(paste0("data/", country, ".tif"))
  s <- terrain(r, v="slope")
  a <- terrain(r, v="aspect")
  
  # hill shade
  h <- shade(slope = s, aspect = a, angle = 40, direction = 270)
  plot(h)
  
  writeRaster(h, paste0("data/hillshade/", country, ".tif"))
}

lapply(countries, generateHill)
