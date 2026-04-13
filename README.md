This is a simple targets pipeline to download all daily USGS discharge data in the past 30 days within a state. The pipeline will identify active gauges, pull in the state and county boundaries, download daily discharge data, and produce a simple report about the downloaded data.

This is a work in progress and only currently has limited functionality. I'm mostly using this as a place to experiment with pulling in and visualizing data in real time and eventually automating the workflow to deploy regularly.

**Using this code**

- Modify lat and lon on line 19 in _targets.R to a state. Note multiple state formats are accepted such as "NY", "ny", "New York", "new york".

- In the console run targets::tar_make()

- The output report is located in ./Rmd/download_report.html
