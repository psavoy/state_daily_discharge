This is a simple targets pipeline to download all daily USGS discharge data in the past 30 days within a watershed (HUC8) based on a latitude and longitude. The pipeline will identify active gauges, pull in the watershed boundary, download daily discharge data, and produce a simple report with linked html widgets showing gauge locations and the downloaded data.

This is a work in progress and only currently has limited functionality. I'm mostly using this as a place to experiment with pulling in and visualizing data in real time and eventually automating the workflow to deploy regularly.

**Using this code**

- Modify lat and lon on lines 19-20 in _targets.R to a location in the continental US.

- In the console run targets::tar_make()

- The output report is located in ./Rmd/download_report.html


