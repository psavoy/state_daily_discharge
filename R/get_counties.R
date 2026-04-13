#===============================================================================
#Get counties
#Created 4/11/2026
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