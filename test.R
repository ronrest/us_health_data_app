
dataDir = "data"
#library("file.convenience")
source("download_and_cache_data.R")
download_and_cache_data(dataDir)





#===============================================================================
#                                                                Load Data Files
#===============================================================================
library(Hmisc)
library(dplyr)

#-------------------------------------------------------------------------------
#                                                                 Blood Pressure
#-------------------------------------------------------------------------------
# Create a blank dataframe
tidy = matrix(NA, nrow=0, ncol=4)
tidy = as.data.frame(tidy)

for (i in 1:length(blood_pressure_urls)){
    file <- paste("data",blood_pressure_files[i], sep="/") 
    data <- sasxport.get(file)
    
    # narrow down columns. 
    # using 1st reading of blood presssure.
    # TODO: average the 4 readings out. 
    data <- data[,c("seqn","bpxsy1", "bpxdi1")]
    
    # Remove rows containing NAs
    data <- data[complete.cases(data),]
    
    # Remove rows containing diastolic records of 0
    data <- data[data$bpxdi1 != 0, ]    
    
    # Add year column
    data$year <- rep(names(blood_pressure_urls[i]), length(nrow(data)))
    
    tidy <- rbind(tidy, data)
}

# Setting names comes last because other wise they are overwritten by the first
# call to rbind
names(tidy) <- c("id", "systolic", "diastolic", "year")

tidy$year <- as.factor(tidy$year)
tidy$id <- as.integer(tidy$id)
tidy$systolic <- as.integer(tidy$systolic)
tidy$diastolic <- as.integer(tidy$diastolic)



by_year <- group_by(tidy, year)
compressed <-summarise(by_year, 
                       mean_sys = mean(systolic), 
                       mean_dia = mean(diastolic), 
                       sd_sys = sd(systolic), 
                       sd_dia = sd(diastolic))

compressed
plot_by_cat(x=tidy$systolic, y=tidy$diastolic, cat=tidy$year )




#-------------------------------------------------------------------------------
#                                                              Body Measurements
#-------------------------------------------------------------------------------
# Create a blank dataframe
tidy_bm = matrix(NA, nrow=0, ncol=5)
tidy_bm = as.data.frame(tidy_bm)
for (i in 1:length(body_measures_urls)){
    file <- paste("data",body_measures_files[i], sep="/") 
    data <- sasxport.get(file)
    
    # narrow down columns. 
    data <- data[,c("seqn","bmxwt", "bmxht", "bmxbmi")]
    
    # Remove rows containing NAs
    data <- data[complete.cases(data),]
    
    # Add year column
    data$year <- rep(names(body_measures_urls[i]), length(nrow(data)))
    
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

bm_by_year <- group_by(tidy_bm, year)
bm_compressed <-summarise(bm_by_year, 
                       mean_weight = mean(weight), 
                       mean_height = mean(height), 
                       mean_bmi = mean(bmi), 
                       sd_bmi = sd(bmi))

bm_compressed
plot_by_cat(x=tidy$systolic, y=tidy$diastolic, cat=tidy$year )


plot_bm <- function(y){
    plot(x=as.numeric(levels(bm_compressed$year)), y=bm_compressed[,y][[1]], type="l")    
}
manipulate(plot_bm(y), 
           y = picker("mean_weight", "mean_height", "mean_bmi", "sd_bmi", 
                      initial = "mean_bmi"))

#par(mfrow=c(1,1), mar=c(5.1, 4.1, 4.1, 2.1), 
#            mgp = c(3, 1, 0), tck = NA, oma=c(0, 0, 0, 0))
#as.numeric(levels(bm_compressed$year))
#bm_compressed[,"mean_bmi"][[1]]


#-------------------------------------------------------------------------------
#                                                                           Diet
#-------------------------------------------------------------------------------
# Create a blank dataframe
tidy_diet = matrix(NA, nrow=0, ncol=13)
tidy_diet = as.data.frame(tidy_diet)
for (i in 1:length(diet_urls)){
    file <- paste("data",diet_files[i], sep="/") 
    data <- sasxport.get(file)
    
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
    data$year <- rep(names(diet_urls[i]), length(nrow(data)))
    
    # Setting names comes last because other wise they are overwritten by 
    # call to rbind
    # It is donw in the loop instead of outside because we are taking columns 
    # with different names due to differences in 2002 and 2004 column names, 
    # which causes issues with rbind if the names do not match. 
    names(data) <- c("id", "energy", "protein", "carbs",
                          "fibre", "fat_total", "fat_saturated", "cholesterol", 
                          "calcium", "sodium", "potassium", "caffeine", "year")
    
    print("about to bind")
    tidy_diet <- rbind(tidy_diet, data)
}

tidy_diet$year <- as.factor(tidy_diet$year)
tidy_diet$id <- as.integer(tidy_diet$id)

for (i in 2:(length(tidy_diet)-1)){
    tidy_diet[,i] <- as.numeric(tidy_diet[,i])    
}

diet_by_year <- group_by(tidy_diet, year)
diet_compressed <-summarise(diet_by_year, 
                          mean_energy =  mean(energy), 
                          mean_protein = mean(protein), 
                          mean_sodium =  mean(sodium), 
                          sd_potassium = mean(potassium))

diet_compressed

str(diet_compressed)

head(tidy_diet)

#plot_by_cat(x=tidy$systolic, y=tidy$diastolic, cat=tidy$year )



#===============================================================================
# Merged Data
#===============================================================================
library(dplyr)
megadf = plyr::join_all(list(tidy_diet, tidy_bm, tidy))
head(megadf)

library(stat.convenience)
na.summary(megadf)

megadf <- megadf[complete.cases(megadf),]
str(megadf)


##################################################
#                                CACHE THE MEGADF
##################################################
# TODO: create code to create the tidy folder
saveRDS(megadf, "data/tidy/megadf.rds")

# Load the megadf file
# TODO: use an if else to check if it exists. 
megadf = readRDS("data/tidy/megadf.rds")



##################################################
#                            SUMMARY AND COMRESSED
##################################################
# SUMMARY OF NUMBERS PER YEAR
mega_by_year <- group_by(megadf, year)
mega_summary <-summarise(mega_by_year, 
                         n = length(id), 
                         id_min = min(id), 
                         id_max =  max(id))

# COMPRESSED
mega_compressed <- summarise(mega_by_year, 
                             mean_energy =  mean(energy), 
                             mean_protein = mean(protein),
                             mean_fat = mean(fat_total), 
                             mean_cholesterol = mean(cholesterol),
                             mean_sodium =  mean(sodium), 
                             mean_potassium = mean(potassium),
                             mean_calcium = mean(calcium),
                             mean_weight = mean(weight), 
                             mean_height = mean(height), 
                             mean_bmi = mean(bmi), 
                             sd_bmi = sd(bmi), 
                             mean_sys = mean(systolic), 
                             mean_dia = mean(diastolic), 
                             sd_sys = sd(systolic), 
                             sd_dia = sd(diastolic))


##################################################
#                                 CORRELATION PLOT
##################################################
#install.packages("corrplot")
library(corrplot)
library(stat.convenience)
library(manipulate)

plot_cors <- function(year){
    df = megadf[megadf$year==year,]
    corrs = cor(filter.columns(df, c("id", "year"), exclude=T, method="list"))    
    corrplot(corrs, method="color")
}

manipulate(plot_cors(year), 
           year = slider(2000, 2012, step=2, initial=2000))



#################################################
#                               PLOT YEARLY TRENDS  
#################################################
# TODO: plot either confidence intervals, or the sd as shaded regions. 
plot_mega <- function(y){
    plot(x=as.numeric(levels(mega_compressed$year)), 
         y=mega_compressed[,y][[1]], 
         type="l")    
}

manipulate(plot_mega(y), 
           y = picker("mean_bmi", 
                      "sd_bmi", 
                      "mean_weight", 
                      "mean_height", 
                      "mean_sys", 
                      "mean_dia", 
                      "sd_sys", 
                      "sd_dia",  
                      "mean_energy", 
                      "mean_protein",
                      "mean_fat",
                      "mean_cholesterol",
                      "mean_sodium", 
                      "mean_potassium",
                      "mean_calcium",
                      initial = "mean_bmi"))



