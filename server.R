library(shiny)

#===============================================================================
#                                                               HELPER FUNCTIONS
#===============================================================================
# Whaatever functions, you need to calculated values, analysis, etc. 

# Loose code you put here will be called only ONCE when you do runApp(), unless 
# it is a function that gets called throughout the user intereaction. 

# This means that if you want values to persist across multiple sessions/page 
# refreshes, initialise the variables here globally eg: 
#     a <<- 45
# And assign new values in the session using the double arrows as well. 


#===============================================================================
#                                              Download And Cache The Data Files
#===============================================================================
dataDir <- "data"
#library("file.convenience")
source("download_and_cache_data.R")
blood_pressure_files <- download_and_cache_blood_pressure_data(dataDir)
body_measures_files  <- download_and_cache_body_measures_data(dataDir)
diet_files           <- download_and_cache_diet_data(dataDir)




#===============================================================================
#                                                           THE SERVER BEHAVIOUR
#===============================================================================
shinyServer(
    function(input, output) {
        #something here
        # Code inside here that is not inside a reactive statement will get 
        # called ONCE for every new user hit / page refresh. 
        
        # COde in eractive functions get called repeatedly as needed when values
        # are updated. 
    }
)