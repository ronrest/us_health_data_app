library(shiny)

# Dependencies: 
# shiny
# Hmisc
# dplyr
# file.convenience
# scales

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


#===============================================================================
#                                                               YEARLY SUMMARIES
#===============================================================================
by_year <- split(merged_data, merged_data$year)
excluded_columns = c("id", "year")
column_names = names(merged_data)[-which(names(merged_data) %in% excluded_columns)]

#-------------------------------------------------------------------------------
#                                              Initialise Yearly Means Dataframe
#-------------------------------------------------------------------------------
# A dataframe is created which will store a summary of the mean values for each 
# feature in a particular year. Each feature is a column of this data frame. 
# Each row represents a different year. 
yearly_means <- matrix(NA,nrow=length(by_year),ncol=length(column_names))
yearly_means <- as.data.frame(yearly_means)
names(yearly_means) <- column_names
rownames(yearly_means) <- names(by_year)

#-------------------------------------------------------------------------------
#                               Initialise Yearly Confidence Intervals Dataframe
#-------------------------------------------------------------------------------
# Two dataframes are created. Each will store a summary for either the upper 
# or lower confidence interval for the estimate of the mean for a particular 
# feature given a particular year. Each feature is a column of this data frame. 
# Each row represents a different year. 
confidence = 0.95                       # 95% confidence interval is used
z_interval = qnorm(confidence/2 + 0.5)  # Z value for confidence interval

yearly_ci_low <- yearly_means
yearly_ci_high <- yearly_means

#-------------------------------------------------------------------------------
#                                           Populate Yearly Summaries Dataframes
#-------------------------------------------------------------------------------
# Actually calculate the means and confidence intervals for each feature, for 
# each year. 
for (feature in column_names){
    feature_means = c()   # temporary vector stores yearly means for a feature
    feature_ci_low = c()  # yearly lower confidence interval for a feature
    feature_ci_high = c() # yearly upper confidence interval for a feature
    
    # For each year, calculate the means and confidence intervals for 
    # the current feature. 
    for (year in names(by_year)){
        # Extract the data for the feature, removing missing values
        feature_data = by_year[[year]][,feature]
        feature_data = feature_data[complete.cases(feature_data)]
        
        #----------------------------------------------------------
        #                                                     Means
        #----------------------------------------------------------
        mean = mean(feature_data, na.rm=T)
        feature_means = c(feature_means, mean)
        
        #----------------------------------------------------------
        #                                       Confidence Interval
        #----------------------------------------------------------
        sd = sd(feature_data, na.rm=T)  # Standard Deviation
        n = length(feature_data)        # Number of items
        se = sd / sqrt(n)               # Standard Error
        ci = mean + c(-1, 1) * z_interval * se # Confidence Interval
        
        feature_ci_low = c(feature_ci_low, ci[1])
        feature_ci_high = c(feature_ci_high, ci[2])
    }
    #----------------------------------------------------------------
    #           Append the results to the relevant summary dataframes
    #----------------------------------------------------------------
    yearly_means[,feature] = feature_means
    yearly_ci_low[,feature] = feature_ci_low
    yearly_ci_high[,feature] = feature_ci_high
} 

#===============================================================================
#                                                                    Plot Labels
#===============================================================================
# A labelled list of string vectors. Each element of the list is for each 
# feature. This element is a vector contianing two strings. 
#  - The first one is the string to be used for the main heading in the 
#    Timeline plot. 
#  - The second one is the string to be used for the Y axis label in the 
#    Timeline plot. 
plot_labels = list("systolic" = c("Systolic Blood Pressure in the USA", 
                                  "Systolic Blood Pressure (mm Hg)"),
    "diastolic" = c("Diastolic Blood Pressure in the USA", 
                    "Diastolic Blood Pressure (mm Hg)"),
    "bmi" = c("Body Mass Index in the USA", "BMI"),
    "weight" = c("Weight in the USA", "Weight (kg"),
    "height" = c("Height the USA", "Height (cm)"),
    "energy" = c("Daily Energy Intake in the USA", "Energy (kcal"),
    "protein" = c("Daily Protein Intake in the USA", "Protein (gm)"),
    "carbs" = c("Daily Carbohydrates Intake in the USA", 
                "Carbohydrates (gm)"),
    "fibre" = c("Daily Fibre Intake in the USA", "Fibre (gm)"),
    "fat_total" = c("Daily Total Fats Intake in the USA", 
                    "Total Fats (gm)"),
    "fat_saturated" = c("Daily Saturated Fats Intake in the USA", 
                        "Saturated Fats (gm)"),
    "cholesterol" = c("Daily Cholesterol Intake in the USA", 
                      "Cholesterol (mg)"),
    "calcium" = c("Daily Calcium Intake in the USA", "Calcium (mg)"),
    "sodium" = c("Daily Sodium Intake in the USA", "Sodium (mg)"),
    "potassium" = c("Daily Potassium Intake in the USA", "Potassium (mg)"),
    "caffeine" = c("Daily Caffeine Intake in the USA", "Caffeine (mg)"))


#===============================================================================
#                                                                  Timeline plot
#===============================================================================
# Plot a timeline plot for a specified feature, with a shaded confidence 
# interval for the mean. 
plot_timeline <- function(feature){
    x = as.numeric(rownames(yearly_means))
    
    #-------------------------------------------------------------------
    #                                                Initialise the Plot
    #-------------------------------------------------------------------
    plot(x=x, 
         y= yearly_means[,feature], 
         type="o", 
         main=paste("Mean", plot_labels[[feature]][1], 
                    "\n(With 95% Confidence Interval)"),
         xlab="Year", 
         ylab=plot_labels[[feature]][2])
    grid(nx = NULL, ny = NULL, col = "gray", lty = "dotted",
         lwd = 1, equilogs = TRUE)
    
    #-------------------------------------------------------------------
    #                                Plot the Shaded Confidence Interval
    #-------------------------------------------------------------------
    poly_x = c(x, rev(x))
    poly_y = c(yearly_ci_low[,feature], rev(yearly_ci_high[,feature]))
    polygon(poly_x,poly_y, col=scales::alpha("#FFCC00", 0.6), border=0)
    
    #-------------------------------------------------------------------
    #                                       Plot the Means Per Year Line
    #-------------------------------------------------------------------
    lines(x=x, 
         y= yearly_means[,feature], 
         type="b", 
         lwd=2,
         col="#0066FF", 
         pch=19)
}

#===============================================================================
#                                           Overlayed Density Distribution Plots
#===============================================================================
# Create Density Distribution Plots for each year, and overlay them on top of 
# each other, with each one plotted in a different color. 
plot_distributions <- function(feature, by_year){
    #-------------------------------------------------------------------
    #                                                    Initialise Plot
    #-------------------------------------------------------------------
    color = (as.numeric(names(by_year)) - 1998)/2 # Color by order of year
    
    # Tidy the Data
    all_years_data = merged_data[,feature]
    all_years_data = all_years_data[complete.cases(all_years_data)]
    
    # Set the plot dimensions
    plot(density(all_years_data), 
         main=paste("Density Distribution for", plot_labels[[feature]][1], 
                    "\n(Color Coded by Year)"), 
         xlab="Year",
         ylab=NA,
         xlim=quantile(all_years_data, c(0.01, 0.99)), # Zoom to relevant area
         type="n")
    
    #-------------------------------------------------------------------
    #                                             Draw each Density Plot
    #-------------------------------------------------------------------
    for (i in 1:length(by_year)){
        yearly_data = by_year[[i]][,feature]
        lines(density(yearly_data, na.rm=T), col=color[i])
        abline(v = mean(yearly_data, na.rm=T), col=color[i])
    }
    legend("topright", pch=19, 
           col=color, legend=names(by_year))
}


################################################################################
#                                                           THE SERVER BEHAVIOUR
################################################################################
shinyServer(
    function(input, output) {
        #something here
        # Code inside here that is not inside a reactive statement will get 
        # called ONCE for every new user hit / page refresh. 
        
        # COde in eractive functions get called repeatedly as needed when values
        # are updated. 
        
        output$timelinePlot <- renderPlot({
            plot_timeline(input$feature)
        }) 
        
        output$densityPlot <- renderPlot({
            plot_distributions(input$feature, by_year)
        })
        
    }
)