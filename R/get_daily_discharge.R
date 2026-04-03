#===============================================================================
#Get daily discharge for active gauges within the past 2 weeks
#Created 3/30/3036
#===============================================================================
get_daily_discharge <- function(gauges){
  #Determine start and end date
    end_date <- Sys.Date()
    start_date <- Sys.Date() - 30

  #Download daily discharge from the past month
    daily_discharge <- dataRetrieval::read_waterdata_daily(
      monitoring_location_id = gauges %>% pull("monitoring_location_id"),
      parameter_code = c("00060"),
      statistic_id = "00003",
      time = c(start_date, end_date),
      properties = c("monitoring_location_id", "parameter_code", "time", 
                     "value", "approval_status")
    ) %>% 
      arrange(monitoring_location_id, time)  
    
  return(daily_discharge)
    
} #end get_daily_discharge 
