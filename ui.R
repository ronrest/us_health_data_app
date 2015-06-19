library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Health of the Nation"),
    sidebarPanel(
        h2('Something'), 
        selectInput("featureSel", "Choose a Feature", 
                    choices=c("bmi","weight","height","sodium"), 
                    selected = "bmi", width = NULL, size = NULL)
    ),
    mainPanel(
        h3('Plots')
    )
))