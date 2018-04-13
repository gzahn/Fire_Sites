# This script is for importing and cleaning GeoDataCrawler variables for the selected Utah burn sites 


#### Libraries and aliases used: ####
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
"%ni%" <- Negate("%in%")

#### Loading ALL that GeoDataCrawler data ####

dat = read_excel("INIT20180405_100m_1.xlsx")
dat2 = read_excel("INIT20180405_100m_2.xlsx")
meta = read_excel("Geodata Crawler - Output Data Descriptions.xlsx")

#### Compare paired burned/un-burned sites across all variables for correlation (should be high) ####

  ## Subset burned and unburned sites
unique(dat$InOrOut)
burned = dat$InOrOut == "in"
unburned = dat$InOrOut == "out"

burned = dat[burned,]
unburned = dat[unburned,]

  ## Differing lengths ... find "pair" that is missing a partner
  
        # Find where mismatch begins
mismatches = unburned$ObjectID_1[order(unburned$ObjectID_1)] == burned$ObjectID_1[order(burned$ObjectID_1)]
first_mismatch = which(match(mismatches, FALSE) == 1)[1]
bad_object = dat[(first_mismatch-1),"ObjectID_1"]

        # re-subset to remove site with mismatch
burned = burned[burned$ObjectID_1 %ni% bad_object,]
unburned = unburned[unburned$ObjectID_1 %ni% bad_object,]
dat = dat[dat$ObjectID_1 %ni% bad_object,] # do this for main datasets too!
dat2 = dat2[dat2$ObjectID_1 %ni% bad_object,]         

        # reorder
burned = burned[order(burned$ObjectID_1),]
unburned = unburned[order(unburned$ObjectID_1),]
identical(burned$ObjectID_1,unburned$ObjectID_1) # check to see if subsets and orders are identical

  ## Plot paired Latitudes and elevations for sanity check .. should be very similar
plot(burned$Lat,unburned$Lat) # Looks good.
plot(burned$L100_ELEVATION_AVG,unburned$L100_ELEVATION_AVG) # Looks good.
plot(burned$L100_SOIL_DOM, unburned$L100_SOIL_DOM) # Looks good.


#### Clean up metadata and data and get them ordered logically ####
        
        # remove all those "L100_" tags from the column names
names(dat) = gsub("L100_","",names(dat), perl = TRUE) 

        # Convert M,D,Y to Dates
            # First, remove any rows that have a "0" in Y,M,orD
good_dates = !(dat$Year_ == 0 | dat$Month_ == 0 | dat$Day_ == 0)
dat = dat[good_dates,]
good_dates = !(dat2$Year_ == 0 | dat2$Month_ == 0 | dat2$Day_ == 0)
dat2 = dat2[good_dates,]

            # Now, extract dates from columns
year = dat$Year_
month = dat$Month_
day = dat$Day_

year2 = dat2$Year_
month2 = dat2$Month_
day2 = dat2$Day_

            # Add BurnDate column
burn_date = as.Date(paste(year,month,day, sep = "-"), format = "%Y-%m-%d")
dat$BurnDate = burn_date
burn_date2 = as.Date(paste(year2,month2,day2, sep = "-"), format = "%Y-%m-%d")
dat2$BurnDate = burn_date2

#### Merge dat and dat2 ####
dat = merge(dat,dat2)


# remove all those "L100_" tags from the column names (again!)
names(dat) = gsub("L100_","",names(dat), perl = TRUE) 


#### Trim down columns only to potentially important ones ####

# Let's get rid of all the OIL and GAS and WELLS, OTHER, FIRE, IMPERVIOUS stuff
good_cols = grep("^OIL_|^GAS_|^FIRE|^OTHER|^ROAD|^IMPERVIOUS|LIGHTS|^PESTICIDE", 
                 names(dat), invert = TRUE)

dat = (dat[,good_cols])


#### Select variables of interest
c("SOIL_DOM","SLOPE_AVG", "ELEVATION_AVG","ASPECT_DOM","LC2011_L2_DOM")



names(dat)




# L2_cols = grep("LC2011_L2",names(dat))
# dat[,L2_cols]

# 












dat$ObjectID_1 %in% burned$ObjectID_1
dat$ObjectID_1 %in% unburned$ObjectID_1

burned$ObjectID_1
unburned$ObjectID_1



  ## Compare a few obvious variables for sanity check
plot(burned$Lat, unburned$Lat)



