library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Data Products Project"),
    sidebarPanel(
        h2('Sidebar Heading level 2')
    ),
    mainPanel(
        h3('Main Panel heading level 3')
    )
))