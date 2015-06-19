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
#                                            Load the Data into Tidy Data Frames
#===============================================================================
# The first time this is run on a computer, it will load the tidy data from 
# all of the separated files and merge them together. It then caches the tidy 
# data in an rds file. Subsequent calls to this script simply load up the cached
# version of the tidy data to save computation time. 

merged_data_file = paste(dataDir, "merged_data.rds", sep="/")
if(!file.exists(merged_data_file)){
    #---------------------------------------------------------------------------
    #                            Load Data from each file into three data frames
    #---------------------------------------------------------------------------
    source("load_data.R")
    message("loading blood pressure data")
    blood_pressure <- load_blood_pressure_data(blood_pressure_files)
    
    message("loading body measures data")
    body_measures <- load_body_measures_data(body_measures_files)
    
    message("loading diet data")
    diet <- load_diet_data(diet_files)
    
    #---------------------------------------------------------------------------
    #                              Merge the data frames into a single dataframe
    #---------------------------------------------------------------------------
    # Each participant is identified by an id, which is in each dataframe. This 
    # along with the year will form the basis by which the rows are merged. 
    library(dplyr)
    message("Merging data into a single dataframe")
    merged_data = plyr::join_all(list(blood_pressure, body_measures, diet))
    
    #---------------------------------------------------------------------------
    #                                                 Cache the merged tidy data
    #---------------------------------------------------------------------------
    message(paste("Caching the tidy data frame as", merged_data_file))
    saveRDS(merged_data, merged_data_file)
    
} else {
    #---------------------------------------------------------------------------
    #                            Load the cached version of the merged tidy data
    #---------------------------------------------------------------------------
    message(paste("Loading the cached tidy data from", merged_data_file))
    merged_data <- readRDS(merged_data_file)
}
   
# NA information
#library(stat.convenience)
#na.summary(merged_data)




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