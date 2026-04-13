#Load packages required to define the pipeline:
library("targets")
library("tarchetypes")

#Set target options:
  tar_option_set(
    packages = c("sf", "nhdplusTools", "dplyr", "ggplot2", "ggpubr", "plotly",
      "leaflet", "crosstalk", "htmltools", "kableExtra", "tidyr", "reactable",
      "ggfx") 
  )

#Run the R scripts in the R/ folder with your custom functions:
  tar_source()

#Replace the target list below with your own:
list(
  tar_target(
    name = state_name,
    command = format_state(state = "ny")
  ),
  tar_target(
    name = state_wgs84,
    command = get_state(state_name)
  ),
  tar_target(
    name = counties_wgs84,
    command = get_counties(state_name)
  ),
  tar_target(
    name = gauges_wgs84,
    command = get_state_gauges(state_name)
  ),
  tar_target(
    name = daily_discharge,
    command = get_daily_discharge(gauges_wgs84)
  ),
  tar_render(
    download_report,
    "Rmd/download_report.Rmd"
  )
)

