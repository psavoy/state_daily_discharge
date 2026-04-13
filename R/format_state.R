#===============================================================================
#Get state name in the necessary format
#Created 4/11/2026
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