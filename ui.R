library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Health of the Nation"),
    sidebarPanel(
        h2('Something'), 
        selectInput("feature", "Choose a Feature", 
                    choices=c("bmi",
                              "systolic", 
                              "diastolic", 
                              "weight",
                              "height",
                              "energy",
                              "protein",
                              "fat",
                              "cholesterol",
                              "sodium",
                              "potassium",
                              "calcium"), 
                    selected = "bmi", width = NULL, size = NULL)
        
                     
    ),
    mainPanel(
        h3('Plots'), 
        plotOutput("timelinePlot"),
        plotOutput("densityPlot")
    )
))