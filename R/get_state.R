#===============================================================================
#Get state boundary
#Created 4/11/2026
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