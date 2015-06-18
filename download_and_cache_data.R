#===============================================================================
#                                         DOWNLOAD AND CACHE BLOOD PRESSURE DATA
#===============================================================================
download_and_cache_blood_pressure_data <- function(dataDir){
    require("file.convenience")
    
    #---------------------------------------------------------------------------
    #                                                             Blood Pressure
    #---------------------------------------------------------------------------
    # Codebook: http://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/BPX_B.htm#BPQ150A
    blood_pressure_urls = list(
        "2000" = "http://wwwn.cdc.gov/Nchs/Nhanes/1999-2000/BPX.XPT",
        "2002" = "http://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/BPX_B.XPT",
        "2004" = "http://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/BPX_C.XPT",
        "2006" = "http://wwwn.cdc.gov/Nchs/Nhanes/2005-2006/BPX_D.XPT",
        "2008" = "http://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/BPX_E.XPT",
        "2010" = "http://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/BPX_F.XPT",
        "2012" = "http://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/BPX_G.XPT")
    
    blood_pressure_files = c("bp_2000.xpt", "bp_2002.xpt", "bp_2004.xpt", 
                             "bp_2006.xpt", "bp_2008.xpt", "bp_2010.xpt", 
                             "bp_2012.xpt")
    
    # Downloads the data from the url the first time, then future times this 
    # script is called, it loads from the local version of the data. 
    for (i in 1:length(blood_pressure_urls)){
        cache_download(blood_pressure_urls[[i]], dataDir=dataDir, 
                       localName=blood_pressure_files[i])
    } 
}
#===============================================================================
#                                          DOWNLOAD AND CACHE BODY MEASURES DATA
#===============================================================================
download_and_cache_body_measures_data <- function(dataDir){
    require("file.convenience")
    # Codebook: http://wwwn.cdc.gov/Nchs/Nhanes/1999-2000/BMX.htm
    body_measures_urls = list(
        "2000" = "http://wwwn.cdc.gov/Nchs/Nhanes/1999-2000/BMX.XPT",
        "2002" = "http://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/BMX_B.XPT",
        "2004" = "http://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/BMX_C.XPT",
        "2006" = "http://wwwn.cdc.gov/Nchs/Nhanes/2005-2006/BMX_D.XPT",
        "2008" = "http://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/BMX_E.XPT",
        "2010" = "http://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/BMX_F.XPT",
        "2012" = "http://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/BMX_G.XPT")
    
    body_measures_files = c("bm_2000.xpt", "bm_2002.xpt", "bm_2004.xpt", 
                            "bm_2006.xpt", "bm_2008.xpt", "bm_2010.xpt", 
                            "bm_2012.xpt")
    
    # Downloads the data from the url the first time, then future times this 
    # script is called, it loads from the local version of the data. 
    for (i in 1:length(body_measures_urls)){
        cache_download(body_measures_urls[[i]], dataDir=dataDir, 
                       localName=body_measures_files[i])
    }
}
#===============================================================================
#                                                   DOWNLOAD AND CACHE DIET DATA
#===============================================================================
download_and_cache_diet_data <- function(dataDir){
    require("file.convenience")
    # Codebook: http://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/DR1TOT_C.htm
    diet_urls = list(
        "2000" = "http://wwwn.cdc.gov/Nchs/Nhanes/1999-2000/DRXTOT.XPT",
        "2002" = "http://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/DRXTOT_B.XPT",
        "2004" = "http://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/DR1TOT_C.XPT",
        "2006" = "http://wwwn.cdc.gov/Nchs/Nhanes/2005-2006/DR1TOT_D.XPT",
        "2008" = "http://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/DR1TOT_E.XPT",
        "2010" = "http://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/DR1TOT_F.XPT",
        "2012" = "http://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/DR1TOT_G.XPT")
    
    diet_files = c("diet_2000.xpt","diet_2002.xpt","diet_2004.xpt", 
                   "diet_2006.xpt", "diet_2008.xpt", "diet_2010.xpt", 
                   "diet_2012.xpt")
    
    # Downloads the data from the url the first time, then future times this 
    # script is called, it loads from the local version of the data. 
    for (i in 1:length(diet_urls)){
        cache_download(diet_urls[[i]], dataDir=dataDir, 
                       localName=diet_files[i])
    } 
}