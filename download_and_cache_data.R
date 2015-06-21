#===============================================================================
#                                         DOWNLOAD AND CACHE BLOOD PRESSURE DATA
#===============================================================================
#' @description Downloads and caches the blood pressure data from the 
#'              wwwn.cdc.gov website. 
#' @return Returns a labelled list with the file paths to the downloaded files.
#'         The label for each element is the year that the data file is from. 
#===============================================================================
download_and_cache_blood_pressure_data <- function(dataDir){
    # Codebook: http://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/BPX_B.htm#BPQ150A
    blood_pressure_urls = list(
        "2000" = "http://wwwn.cdc.gov/Nchs/Nhanes/1999-2000/BPX.XPT",
        "2002" = "http://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/BPX_B.XPT",
        "2004" = "http://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/BPX_C.XPT",
        "2006" = "http://wwwn.cdc.gov/Nchs/Nhanes/2005-2006/BPX_D.XPT",
        "2008" = "http://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/BPX_E.XPT",
        "2010" = "http://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/BPX_F.XPT",
        "2012" = "http://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/BPX_G.XPT")
    
    blood_pressure_files = list("2000" = "bp_2000.xpt", 
                                "2002" = "bp_2002.xpt", 
                                "2004" = "bp_2004.xpt",
                                "2006" = "bp_2006.xpt", 
                                "2008" = "bp_2008.xpt", 
                                "2010" = "bp_2010.xpt", 
                                "2012" = "bp_2012.xpt")
    
    # Downloads the data from the url the first time, then future times this 
    # script is called, it loads from the local version of the data. 
    for (i in 1:length(blood_pressure_urls)){
        cache_download(blood_pressure_urls[[i]], dataDir=dataDir, 
                       localName=blood_pressure_files[[i]])
    } 
    fullpaths = as.list(paste(dataDir, blood_pressure_files, sep="/"))
    names(fullpaths) = names(blood_pressure_files)
    return(fullpaths)
}

#===============================================================================
#                                          DOWNLOAD AND CACHE BODY MEASURES DATA
#===============================================================================
#' @description Downloads and caches the body measures data from the 
#'              wwwn.cdc.gov website. 
#' @return Returns a labelled list with the file paths to the downloaded files.
#'         The label for each element is the year that the data file is from. 
#===============================================================================
download_and_cache_body_measures_data <- function(dataDir){
    # Codebook: http://wwwn.cdc.gov/Nchs/Nhanes/1999-2000/BMX.htm
    body_measures_urls = list(
        "2000" = "http://wwwn.cdc.gov/Nchs/Nhanes/1999-2000/BMX.XPT",
        "2002" = "http://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/BMX_B.XPT",
        "2004" = "http://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/BMX_C.XPT",
        "2006" = "http://wwwn.cdc.gov/Nchs/Nhanes/2005-2006/BMX_D.XPT",
        "2008" = "http://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/BMX_E.XPT",
        "2010" = "http://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/BMX_F.XPT",
        "2012" = "http://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/BMX_G.XPT")
    
    body_measures_files = list("2000" = "bm_2000.xpt", 
                               "2002" = "bm_2002.xpt", 
                               "2004" = "bm_2004.xpt",
                               "2006" = "bm_2006.xpt",
                               "2008" = "bm_2008.xpt",
                               "2010" = "bm_2010.xpt",
                               "2012" = "bm_2012.xpt")
    
    # Downloads the data from the url the first time, then future times this 
    # script is called, it loads from the local version of the data. 
    for (i in 1:length(body_measures_urls)){
        cache_download(body_measures_urls[[i]], dataDir=dataDir, 
                       localName=body_measures_files[[i]])
    }
    fullpaths = as.list(paste(dataDir, body_measures_files, sep="/"))
    names(fullpaths) = names(body_measures_files)
    return(fullpaths)
}
#===============================================================================
#                                                   DOWNLOAD AND CACHE DIET DATA
#===============================================================================
#' @description Downloads and caches the diet data from the wwwn.cdc.gov website
#' @return Returns a labelled list with the file paths to the downloaded files.
#'         The label for each element is the year that the data file is from. 
#===============================================================================
download_and_cache_diet_data <- function(dataDir){
    # Codebook: http://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/DR1TOT_C.htm
    diet_urls = list(
        "2000" = "http://wwwn.cdc.gov/Nchs/Nhanes/1999-2000/DRXTOT.XPT",
        "2002" = "http://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/DRXTOT_B.XPT",
        "2004" = "http://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/DR1TOT_C.XPT",
        "2006" = "http://wwwn.cdc.gov/Nchs/Nhanes/2005-2006/DR1TOT_D.XPT",
        "2008" = "http://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/DR1TOT_E.XPT",
        "2010" = "http://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/DR1TOT_F.XPT",
        "2012" = "http://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/DR1TOT_G.XPT")
    
    diet_files = list("2000" = "diet_2000.xpt",
                      "2002" = "diet_2002.xpt",
                      "2004" = "diet_2004.xpt",
                      "2006" = "diet_2006.xpt", 
                      "2008" = "diet_2008.xpt", 
                      "2010" = "diet_2010.xpt", 
                      "2012" = "diet_2012.xpt")
    
    # Downloads the data from the url the first time, then future times this 
    # script is called, it loads from the local version of the data. 
    for (i in 1:length(diet_urls)){
        cache_download(diet_urls[[i]], dataDir=dataDir, 
                       localName=diet_files[[i]])
    } 
    fullpaths = as.list(paste(dataDir, diet_files, sep="/"))
    names(fullpaths) = names(diet_files)
    return(fullpaths)
}

#===============================================================================
#                                                                 CACHE DOWNLOAD
#===============================================================================
# The following function is taken from my repository 
# https://github.com/ronrest/convenience_functions_R
# It is part of a package called file.convenience but is copied and pasted here 
# because shinyapps.io does not allow this package to be installed on their 
# server. 
#' cache_download
#' 
#' Downloads a file from the internet, and caches it locally. So future calls to 
#' the same function simply load the local file instead of downloading all over 
#' again. 
#' 
#' @param url (string) the URL to download from
#' @param dataDir (string) The directory where the local file will be 
#'        stored in
#' @param localName (string) The name you want the file to be called locally
#' @author Ronny Restrepo
#' @note This function has only been tested on Linux, it might not work on other 
#'       operating systems yet. 
#' @import curl
#' @export cache_download
cache_download <- function(url, dataDir, localName){
    print("Using local version of cache_download")
    require("curl")
    # TODO: Handle circumstances where dataDir is "" or "." or "./"
    # TODO: include option to override existing local file, eg, if there may be 
    #       reason to believe that the data has changed. 
    
    # TODO: Possibly modify handling of file separator, it may not work on Windows. 
    localPathToFile = paste(dataDir, localName, sep="/")
    
    #---------------------------------------------------------------------------
    #                     Create a new data directory if it doesnt already exist
    #---------------------------------------------------------------------------
    if(!file.exists(dataDir)){
        message("Creating a new data directory '", dataDir, "'")
        dir.create(dataDir)
    }
    
    #---------------------------------------------------------------------------
    #                     Download the file if it hasn't already been downloaded
    #---------------------------------------------------------------------------
    if(file.exists(localPathToFile)){
        dateDownloaded <- NA    # TODO: Load a datestamp from a file, so that it
        # can be loaded up on start up
        message("Using existing ", localPathToFile, " file downloaded on ",
                dateDownloaded)
    } else {
        message("Downloading and saving data as ", localPathToFile)
        download.file(url, destfile=localPathToFile, method="curl")
        
        # Create a datestamp of the time the download was made
        dateDownloaded <- date()
        message("Download made on ", dateDownloaded)
        # TODO: save the datestamp as a file, so it can be loaded up next time 
        #       the script is run
    }
}
