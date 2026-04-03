#===============================================================================
#Get HUc boundary based on location and specified huc level
#Borrowing from https://waterdata.usgs.gov/blog/nhd-viz-demo/
#Created 3/30/3036
#===============================================================================
get_huc_boundary <- function(lat, lon, huc_level){
  #Put coordinates in a data frame
    coords <- data.frame(lat = lat, lon = lon)
  
  #Project the coordinates
    coords_wgs84 <- sf::st_as_sf(
      coords,
      coords = c("lat", "lon"),
      crs = 4326
    ) 
  
  #Get USGS basin from geoconnex
    base_url <- "https://reference.geoconnex.us/collections/"
  
  #Build query
    query <- paste0(
      "/items?f=json&filter=INTERSECTS(geometry, POINT(", 
      sf::st_coordinates(coords_wgs84)[1, "X"],
      " ",
      sf::st_coordinates(coords_wgs84)[1, "Y"],  
      "))"
    ) %>% 
      URLencode()
  
  #Build final url
    url <- paste0(base_url, huc_level, query)
  
  #Get huc boundary
    huc_wgs84 <- sf::st_read(url, quiet = TRUE)
  
  return(huc_wgs84)
    
} #end get_huc_boundary
