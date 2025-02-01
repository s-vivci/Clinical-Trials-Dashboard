#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
# TITLE: Clinical Trials Landscape App
# DESCRIPTION: This R Shiny App loads runs a Python script which makes an API
#              call to clinicaltrials.gov based on Country and outputs data as a CSV, then
#              loads the resulting CSV and creates a dashboard of basic plots and tables.
# AUTHOR: Vivek Golla
# DATE_OF_CREATION: 1/29/2025
# LAST_UPDATE: 1/31/2025
#

#Libraries Loading
library(shiny)
library(ggplot2)
library(reticulate)
library(DT)
library(shinythemes)
library(dplyr)
library(DataExplorer)
library(bslib)

#py_install("requests", pip = TRUE)
#py_install("pandas", pip = TRUE)
#py_install("numpy", pip = TRUE)

#Running the Python script to call API and output csv file
#REQUIRES USER INPUT FOR COUNTRY
py_run_file("script.py")

#Reading csv file
df <- read.csv("clinical_trials_data_complete.csv", stringsAsFactors = FALSE)

#Converting Start Date and End Date type
df$Start.Date <- as.Date(df$Start.Date, format="%Y-%m-%d")
df$End.Date <- as.Date(df$End.Date, format="%Y-%m-%d")


ui <- fluidPage(
  theme = shinytheme("sandstone"),
  titlePanel(paste0("Clinical Trials Landscape In ",df$Country[1])),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("sponsor", "Select Sponsor Company", choices = c("All",unique(df$Lead.Sponsor))),
      actionButton("apply", "Apply Filters")
    ),
    
    mainPanel(
      plotOutput("catplot"),
      navset_tab(
        nav_panel("Summary Table", dataTableOutput("table")),
        nav_panel("Trial Phases", plotOutput("phasePlot")),
        nav_panel("Most Popular Conditions", plotOutput("conditionPlot")),
        nav_panel("Enrollment Trends", plotOutput("enrollmentPlot"))
      )
    )
  )
)

server <- function(input, output, session) {
  filtered_data <- reactive({
    req(input$apply)
    if (input$sponsor == "All"){
      df
    }
    else {
      df %>%
        filter(Lead.Sponsor == input$sponsor)
    }
    })
  
  output$catplot <- renderPlot({
    print(DataExplorer::plot_bar(filtered_data()))
  })
  output$table <- renderDataTable({
    filtered_data()
    }, options = list(pageLength = 10))
  
  output$phasePlot <- renderPlot({
    ggplot(filtered_data(), aes(x = Phases)) +
      geom_bar(fill = "#0073C2") +
      theme_linedraw() +
      labs(title = "Distribution of Trials by Phase", x = "Phase", y = "Count")+
      coord_flip()
    
  })
  output$conditionPlot <- renderPlot({
    
    conditions.tbl <- table(filtered_data()$Conditions) %>%
      sort(decreasing=FALSE)
    
    conditions.df <- top_n(as.data.frame(conditions.tbl), 5)
    
    ggplot(conditions.df, aes(x=Var1, y=Freq))+
      geom_bar(stat="identity", fill = "#E46") +
      theme_dark() +
      labs(title = "Most common conditions", x = "Conditions", y = "Count")+
      coord_flip()

  })
  output$enrollmentPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = Start.Date, y = Enrollment)) +
      geom_line(color = "#E69F00") +
      theme_linedraw() +
      labs(title = "Enrollment Trends Over Time", x = "Start Date", y = "Enrollment")
  })
}

shinyApp(ui = ui, server = server)
