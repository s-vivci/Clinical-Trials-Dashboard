# Clinical Trials Dashboard

## Overview
This R Shiny application visualizes clinical trial data from ClinicalTrials.gov for studies conducted in a user-inputted Country. The app loads trial data via a Python script that fetches completed clinical trials from the API, stores the data in a CSV file, and then processes it in R for interactive exploration.

## Features
- **Filter Clinical Trials**: Select trial Sponsor, or view stats/viz for the Country as a whole
- **Summary Table**: View detailed trial data with sorting and search functionality.
- **Most Common Conditions**: A bar chart displaying the top 5 most frequently observed conditions.
- **Trial Phases Distribution**: A bar chart displaying the number of trials per phase.
- **Enrollment Trends**: A line chart showing participant enrollment over time.

## Technologies Used
- **Python**: Requests API data and saves it as a CSV.
- **R Shiny**: Builds an interactive dashboard.
- **ggplot2 & dplyr**: Data visualization and transformation.
- **shinythemes**: Provides a modern UI theme.
- **reticulate**: Run python script within R
- **dslib**: Modernize the UI layout even more.
- **DataExplorer**: Used for the EDA of categorical variables on the main page.

## Installation
### Prerequisites
Ensure you have the following installed:
- **R (4.0 or later)** and RStudio
- **Python (3.7 or later)** with pip
- **R Packages:**
  ```r
  install.packages(c("shiny", "ggplot2", "dplyr", "DT", "shinythemes", "reticulate", "DataExplorer","bslib"))
  ```
- **Python Packages:**
  ```sh
  pip install requests pandas numpy
  ```

## Running the App
1. Clone the repository:
   ```sh
   git clone https://github.com/s-vivci/Clinical-Trials-Dashboard.git
   cd Clinical-Trials-Dashboard
   ```
2. Run the Python script to fetch data:
   ```sh
   Rscript -e "reticulate::py_run_file('script.py')"
   ```
3. Launch the Shiny app:
   ```r
   shiny::runApp("app.R")
   ```

## File Structure
```
clinical-trials-japan/
│── script.py                     # Fetches clinical trial data
│── clinical_trials_data_complete.csv  # Processed trial data
│── app.R                         # R Shiny dashboard
│── README.md                      # Project documentation
```

## Future Enhancements
- Specify more variables in the API call, to increase richness of data.
- Add more visualizations (e.g., intervention trends, sponsor distribution).
- Add more filters and conditions to the Dashboard, to customize the output further.
- Improve performance with data caching.
- Deploy the app on **shinyapps.io** or a cloud server.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

