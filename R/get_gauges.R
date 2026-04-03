#===============================================================================
#Get USGS stream gauges
#https://waterdata.usgs.gov/blog/dataretrieval/
#Created 3/30/3036
#===============================================================================
get_gauges <- function(huc_wgs84){
  #Identify "active" sites
    active_sites <- dataRetrieval::read_waterdata_ts_meta(
      last_modified = "P1M",
      parameter_name = "Discharge",
      properties = c("monitoring_location_id", "computation_period_identifier")
    ) 
    active_list <- unique(active_sites$monitoring_location_id)
  
  #Get huc number
    huc_num <- huc_wgs84 %>% 
      pull(all_of(names(huc_wgs84)[grepl("huc" , names(huc_wgs84))]))
    
  #Download all streamgage monitoring locations in the huc
    gauges <- dataRetrieval::read_waterdata_monitoring_location(
      hydrologic_unit_code = huc_num, 
      site_type = "Stream",
      properties = c("monitoring_location_id", "monitoring_location_name", "site_type")
    ) %>% 
      filter(monitoring_location_id %in% active_list)

  return(gauges)
    
} #end get_gauges
