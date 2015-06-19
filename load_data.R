#===============================================================================
#                                                       LOAD BLOOD PRESSURE DATA
#===============================================================================
#' @description Takes a labelled list of XPT files to load the blood pressure 
#'              data from and returns a tidy dataframe with just the relevant 
#'              columns
#' @return Returns the tidy data frame for blood pressure data containing 
#'         systolic and diastolic data for the years 2000 - 2012 
#===============================================================================
load_blood_pressure_data <- function(filesList){
    #require(Hmisc)

    # Create a blank dataframe
    tidy = matrix(NA, nrow=0, ncol=4)
    tidy = as.data.frame(tidy)
    
    for (i in 1:length(filesList)){
        file <- filesList[[i]] 
        data <- Hmisc::sasxport.get(file)
        
        # narrow down columns. 
        # using 1st reading of blood presssure.
        data <- data[,c("seqn","bpxsy1", "bpxdi1")]
        
        # Remove rows containing NAs
        data <- data[complete.cases(data),]
        
        # Remove rows containing diastolic records of 0
        data <- data[data$bpxdi1 != 0, ]    
        
        # Add year column
        data$year <- rep(as.integer(names(filesList[i])), length(nrow(data))) 
        
        tidy <- rbind(tidy, data)
    }
    
    # Setting names comes last because other wise they are overwritten by the first
    # call to rbind
    names(tidy) <- c("id", "systolic", "diastolic", "year")
    
    tidy$year <- as.factor(tidy$year)
    tidy$id <- as.integer(tidy$id)
    tidy$systolic <- as.integer(tidy$systolic)
    tidy$diastolic <- as.integer(tidy$diastolic)
    
    return(tidy)
}



#===============================================================================
#                                                        LOAD BODY MEASURES DATA
#===============================================================================
#' @description Takes a labelled list of XPT files to load the body measures  
#'              data from and returns a tidy dataframe with just the relevant 
#'              columns
#' @return Returns the tidy data frame for body measures data containing 
#'         weight, height, and bmi data for the years 2000 - 2012 
#===============================================================================
load_body_measures_data <- function(filesList){
    # Create a blank dataframe
    tidy_bm = matrix(NA, nrow=0, ncol=5)
    tidy_bm = as.data.frame(tidy_bm)
    
    for (i in 1:length(filesList)){
        file <- filesList[[i]] 
        data <- Hmisc::sasxport.get(file)
        
        # narrow down columns. 
        data <- data[,c("seqn","bmxwt", "bmxht", "bmxbmi")]
        
        # Remove rows containing NAs
        data <- data[complete.cases(data),]
        
        # Add year column
        data$year <- rep(as.integer(names(filesList[i])), length(nrow(data))) 
        
        tidy_bm <- rbind(tidy_bm, data)
    }
    
    # Setting names comes last because other wise they are overwritten by the first
    # call to rbind
    names(tidy_bm) <- c("id", "weight", "height", "bmi", "year")
    
    tidy_bm$year <- as.factor(tidy_bm$year)
    tidy_bm$id <- as.integer(tidy_bm$id)
    tidy_bm$height <- as.integer(tidy_bm$height)
    tidy_bm$weight <- as.integer(tidy_bm$weight)
    tidy_bm$bmi <- as.integer(tidy_bm$bmi)
    
    return(tidy_bm)
}

#===============================================================================
#                                                                 LOAD DIET DATA
#===============================================================================
#' @description Takes a labelled list of XPT files to load the diet data from   
#'              and returns a tidy dataframe with just the relevant columns.
#' @return Returns the tidy data frame for diet data containing data for  
#'         energy, protein, carbs, sodium, calcium, fat, etc, for the years 
#'         2000 - 2012 
#===============================================================================
load_diet_data <- function(filesList){
    # Create a blank dataframe
    tidy_diet = matrix(NA, nrow=0, ncol=13)
    tidy_diet = as.data.frame(tidy_diet)
    for (i in 1:length(filesList)){
        file <- filesList[[i]]
        data <- Hmisc::sasxport.get(file)
        
        if (i >=1 & i <= 2){
            # narrow down columns. 
            # energy in kilo-calories
            data <- data[,c("seqn","drxtkcal", "drxtprot","drxtcarb", 
                            "drxtfibe", "drxttfat", "drxtsfat", "drxtchol", 
                            "drxtcalc", "drdtsodi", "drxtpota", "drxtcaff")]
        }else{
            # narrow down columns. 
            # energy in kilo-calories
            data <- data[,c("seqn","dr1tkcal", "dr1tprot","dr1tcarb", 
                            "dr1tfibe", "dr1ttfat", "dr1tsfat", "dr1tchol", 
                            "dr1tcalc", "dr1tsodi", "dr1tpota", "dr1tcaff")]
        }
        
        # Remove rows containing NAs
        data <- data[complete.cases(data),]
        
        # Add year column
        data$year <- rep(as.integer(names(filesList[i])), length(nrow(data))) 
        
        # Setting names comes last because other wise they are overwritten by 
        # call to rbind
        # It is donw in the loop instead of outside because we are taking columns 
        # with different names due to differences in 2002 and 2004 column names, 
        # which causes issues with rbind if the names do not match. 
        names(data) <- c("id", "energy", "protein", "carbs",
                         "fibre", "fat_total", "fat_saturated", "cholesterol", 
                         "calcium", "sodium", "potassium", "caffeine", "year")
        
        tidy_diet <- rbind(tidy_diet, data)
    }
    
    tidy_diet$year <- as.factor(tidy_diet$year)
    tidy_diet$id <- as.integer(tidy_diet$id)
    
    for (i in 2:(length(tidy_diet)-1)){
        tidy_diet[,i] <- as.numeric(tidy_diet[,i])    
    }
    
    return(tidy_diet)
}

