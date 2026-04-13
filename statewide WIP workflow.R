#===============================================================================
#WIP rebuilding to statewide
#===============================================================================
#libraries "reactable"
state = "ny"
#===============================================================================
#Get state name in the necessary format
#===============================================================================
format_state <- function(state){
  #Error catch to return state name in the necessary format
  if(nchar(state) == 2){
    state_name <- state.name[match(toupper(state), state.abb)]
  } else{
    state_name <- tools::toTitleCase(state)
  } #end if statement
  
  return(state_name)
} #end format_state

state_name <- format_state(state)

#===============================================================================
#Get state boundary
#===============================================================================
get_state <- function(state_name){
  #Get state boundary
    sf_use_s2(FALSE)
    state_boundary <- sf::st_as_sf(
      maps::map("state", region = state_name, plot = FALSE, fill = TRUE)
    ) %>% 
      sf::st_transform(., 4326) %>% 
      sf::st_make_valid()
    sf_use_s2(TRUE) 
    
  return(state_boundary)
} #end get_state

state_wgs84 <- get_state(state_name)

#===============================================================================
#Get counties
#===============================================================================
get_counties <- function(state_name){
  #Get county boundaries
    sf_use_s2(FALSE)
    county_boundaries <- sf::st_as_sf(
      maps::map("county", region = state_name, plot = FALSE, fill = TRUE)
    ) %>% 
      sf::st_transform(., 4326) %>% 
      sf::st_make_valid() %>% 
      mutate(
        .after = ID,
        county = sub("^[^,]*,", "", ID)
      )
    sf_use_s2(TRUE)  
    
  return(county_boundaries)
}

counties_wgs84 <- get_counties(state_name)

#===============================================================================
#Get USGS stream gauges
#https://waterdata.usgs.gov/blog/dataretrieval/
#Created 3/30/3036
#===============================================================================
get_state_gauges <- function(state_name){
  # #Error catch to return state name in the necessary format
  #   if(nchar(state) == 2){
  #     state_name <- state.name[match(toupper(state), state.abb)]
  #   } else{
  #     state_name <- tools::toTitleCase(state)
  #   } #end if statement

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
    
} #end get_gauges

gauges_wgs84 <- get_state_gauges("New York")

#===============================================================================

#===============================================================================
daily_discharge <- get_daily_discharge(gauges_wgs84)
