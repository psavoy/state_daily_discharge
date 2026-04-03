#Load packages required to define the pipeline:
library("targets")
library("tarchetypes")

#Set target options:
  tar_option_set(
    packages = c("sf", "nhdplusTools", "dplyr", "ggplot2", "ggpubr", "plotly",
      "leaflet", "crosstalk", "htmltools", "kableExtra", "tidyr") 
  )

#Run the R scripts in the R/ folder with your custom functions:
  tar_source()

# Replace the target list below with your own:
list(
  tar_target(
    name = huc_wgs84,
    command = get_huc_boundary(
      lat = -78.878738,
      lon = 42.880230,
      huc_level = "hu08"
    )
  ),
  tar_target(
    name = gauges,
    command = get_gauges(huc_wgs84)
  ),
  tar_target(
    name = daily_discharge,
    command = get_daily_discharge(gauges)
  ),
  tar_render(
    download_report,
    "Rmd/download_report.Rmd"
  )
)

