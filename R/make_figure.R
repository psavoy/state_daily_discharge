#===============================================================================
#Make a combined map and plot of discharge
#Created 3/30/2026
#===============================================================================
make_figure <- function(huc_wgs84, huc_nhd, gauges, daily_discharge){
  #-------------------------------------------------
  #Setup
  #-------------------------------------------------
    #Reproject data
      huc_albers <- huc_wgs84 %>% 
        sf::st_transform(crs = 5070)
      
      nhd_albers <- huc_nhd %>% 
        sf::st_transform(crs = 5070)
      
      gauges_albers <- gauges %>% 
        sf::st_transform(crs = 5070)
    
    #Get huc number
      huc_num <- huc_albers %>% 
        pull(all_of(names(huc_albers)[grepl("huc" , names(huc_albers))]))
  
    #Get monitoring ids
      monitoring_ids <- gauges_albers %>% 
        filter(status == "active") %>% 
        pull(monitoring_location_id) %>% 
        unique()
    
    #Set color palette
      my_pal <- setNames(
        viridis(length(monitoring_ids)),
        levels(factor(monitoring_ids))
      )
      
  #-------------------------------------------------
  #Plot of daily discharge  
  #-------------------------------------------------
    discharge_plot <- ggplot(data = daily_discharge, aes(x = time, y = value, col = monitoring_location_id)) + 
      #Add lines
      geom_line(size = 1) + 
      scale_color_manual(values = my_pal) +
        
      #Theme elements
      ylab("Discharge") +
      xlab("Time") +
      ggtitle(paste0("Daily discharge for the past month in HUC ", huc_num)) +        
      theme_classic2() +
      theme(
        text = element_text(size = 9)
      )
      
  #-------------------------------------------------
  #Make a map of locations with daily discharge measurements in the past month
  #-------------------------------------------------
    #Specify some aesthetics
      width <- 0.25
      background_col <- "#EDEEEE" 
      water_col <- "#1B75B5" 
      
    #Make
      map_plot <- ggplot() +
        #Huc outline
        geom_sf(
          data = huc_albers,
          fill = background_col,
          color = background_col,
          linewidth = 0.75    
        ) +
        
        #Flowlines
        geom_sf(
          data = nhd_albers,
          color = water_col,
          aes(
            linewidth = factor(
              case_when(
                streamorde == 10 ~ "tenth",
                streamorde == 9 ~ "ninth",
                streamorde == 8 ~ "eigth",
                streamorde == 7 ~ "seventh",
                streamorde == 6 ~ "sixth",
                streamorde == 5 ~ "fifth",
                streamorde == 4 ~ "fourth",
                streamorde == 3 ~ "third",
                streamorde == 2 ~ "second",
                streamorde == 1 ~ "first"
              )
            )
          )
        ) +
        
        #Scale flowlines by stream order
        scale_linewidth_manual(
          values = c(
            tenth  = width * 5,
            ninth  = width * 4,
            eigth = width * 3.5,
            seventh  = width * 3,
            sixth  = width * 2.5,
            fifth = width * 2,
            fourth  = width * 1.5,
            third  = width ,
            second = width * 0.75,
            first  = width * 0.5
          ),
          guide = "none"
        ) +
        
        #Inactive
        geom_sf(
          data = gauges_albers %>% filter(status == "inactive"),
          col = "grey70",
          size = 0.5
        ) +
        
        #Active
        geom_sf(data = gauges_albers %>% filter(status == "active"), aes(col = monitoring_location_id)) +
        scale_color_manual(values = my_pal) +
        
        #Theme elements
        ggtitle("Locations with discharge measuremens in the past month") +
        theme_void() +
        theme(
          text = element_text(size = 9)
        )  
      
    #-------------------------------------------------
    #Make and export final plot
    #-------------------------------------------------
      #Arrange the final plot
        final_plot <- ggarrange(
          map_plot,
          discharge_plot,
          ncol = 2,
          common.legend = TRUE, 
          legend = "right"
        )

      #Export
        ggsave(
          plot = final_plot,
          filename = "C:/users/phil/desktop/test.jpg",
          width = 8,
          height = 3,
          dpi = 300,
          units = "in"
        )  
  
  } #end make_figure