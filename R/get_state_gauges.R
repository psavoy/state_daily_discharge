#===============================================================================
#Get USGS stream gauges
#https://waterdata.usgs.gov/blog/dataretrieval/
#Created 4/11/2026
#===============================================================================
get_state_gauges <- function(state_name){
  #Identify "active" sites
    active_sites <- dataRetrieval::read_waterdata_ts_meta(
      last_modified = "P1M",
      parameter_code = "00060",
      statistic_id = "00003",
      state_name = state_name,
      properties = c("monitoring_location_id", "computation_period_identifier")
    ) 
    
  #Get string of location_ids
    active_ids <- unique(active_sites$monitoring_location_id)
    
  #Download all streamgage monitoring locations in the huc
    gauges <- dataRetrieval::read_waterdata_monitoring_location(
      monitoring_location_id = active_ids,
      properties = c("monitoring_location_id", "monitoring_location_name", "site_type"),
      skipGeometry = FALSE
    )
    
  #Check if a sf object was returned, if not convert to sf
  if(class(gauges) == "data.frame"){
    gauges <- sf::st_as_sf(gauges)
  }

  return(gauges)
    
} #end get_state_gauges