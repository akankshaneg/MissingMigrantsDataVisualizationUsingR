
gdpData<-read.csv("Countries.csv",header = TRUE)
migrantsdata<-read.csv("missingmigrants-2014-2019_updated.csv",header = TRUE)
kaggledata<-read.csv("MissingMigrantsProject.csv",header = TRUE)

library(tidyverse)
library(dplyr)

#change column names to match to migrantsdata
colnames(kaggledata)[colnames(kaggledata)=="incident_region"] <- "Region.of.Incident"
colnames(kaggledata)[colnames(kaggledata)=="cause_of_death"] <- "Cause.of.Death"
colnames(kaggledata)[colnames(kaggledata)=="date"] <- "Reported.Date"
colnames(kaggledata)[colnames(kaggledata)=="lat"] <- "Lat"
colnames(kaggledata)[colnames(kaggledata)=="lon"] <- "Long"

#merging data
combinedmigrantdata<-left_join(migrantsdata,kaggledata,by=c("Region.of.Incident","Cause.of.Death","Reported.Date","Lat","Long"))

#getting not null relevant data where origin is there
dfnew<- combinedmigrantdata[!is.na(combinedmigrantdata$region_origin),]

#changing column name to match gdp dataset
colnames(dfnew)[colnames(dfnew)=="affected_nationality"] <- "Name"

#joiningdatset
affectednationalitygdp<-left_join(gdpData,dfnew,by=c("Name"))

#get not null data
dfnotempty<-affectednationalitygdp[!is.na(affectednationalitygdp$Number.Dead),]

#get animate library

library(ggplot2)
class(dfnotempty$GDPPC)


#bar with points
p<-ggplot(dfnotempty,aes(x=Name,y=GDPPC,fill=dfnotempty$Name),fill=dfnotempty$Name)+
  geom_bar(stat="identity")+
  geom_point(aes(size=Number.Dead))+
  geom_smooth(method = "loess", se=F)+
  labs(subtitle="GDP per capita with total number of dead Migrants ",
       y="GDP per capita",
       x="Affected Nationality",
       title="Scatterplot",
       caption="Source:"
  )
p








