library(dplyr)
library(stringr)

# set home folder and create data folder if needed
setwd("c:/users/cesar/onedrive/courses/clean data/finalproject")
if(!file.exists("./data")){dir.create("./data")}

#download data archive and store in ./data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dfile <- "./data/dataset.zip"
download.file(fileUrl, destfile=dfile, mode="wb")

#unzip archive to working directory
unzip(dfile)

#grab column names
columnNames = read.table("./UCI HAR Dataset/features.txt", header=FALSE, sep=" ", colClasses=c("NULL", "character"))
names(columnNames) <- c("colname")
#grab index numbers of column names containing either mean() or std()
colIndex <- grep("(-mean\\(\\))|(std\\(\\))", columnNames$colname)


#grab activity names:  activity# -> activity name
activityNames = read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, sep=" ", colClasses=c("NULL", "character"))
names(activityNames) <- "activity"

#prepare arguments for reading X file, colclasses and colnames
colclasses <- rep("NULL", 561)
colclasses[colIndex] <- rep("numeric", length(colIndex))
colnames1 <- columnNames[colIndex, 'colname']
#clean up colnames so they do not contain parentheses
colnames <- gsub("\\(\\)", "", colnames1, )


#new file containing frame
newFile <- "./data/all_values_by_subject_and_activity.txt"

#TEST DATA PROCESSING
#LOAD AND PROCESS TEST DATA, PRODUCING A DATA FRAME CONTAINING TEST-ONLY DATA

#define test file names
testSubjectsFile <- "./UCI HAR Dataset/test/subject_test.txt"
testMeasurementsFile <- "./UCI HAR Dataset/test/X_test.txt"
testActivitiesFile <- "./UCI HAR Dataset/test/y_test.txt"


#grab subject id
testSubjects <- read.table(testSubjectsFile)
names(testSubjects) <- "subjectId"
#grab y file
testActivities <- read.table(testActivitiesFile)
names(testActivities) <- "ActivityId"
#grab x file
allTestRows <- read.fwf(testMeasurementsFile, widths=rep(16,561), header=FALSE, col.names=columnNames$colname, colClasses=colclasses)
names(allTestRows) <- colnames

#add two columns to data frame: 'subjectId', 'activityName'
allTestRows$subjectId <- testSubjects[,'subjectId']
allTestRows$activityName <- activityNames[testActivities[,'ActivityId'],'activity']

#write new data frame to file and clean up memory
write.table(allTestRows, newFile, row.names=FALSE)
rm(allTestRows)


#LOAD AND PROCESS TRAIN DATA, PRODUCING A DATA FRAME CONTAINING TRAIN-ONLY DATA

#define train file names
trainSubjectsFile <- "./UCI HAR Dataset/train/subject_train.txt"
trainMeasurementsFile <- "./UCI HAR Dataset/train/X_train.txt"
trainActivitiesFile <- "./UCI HAR Dataset/train/y_train.txt"

#grab subject id
trainSubjects <- read.table(trainSubjectsFile)
names(trainSubjects) <- "subjectId"
#grab y file
trainActivities <- read.table(trainActivitiesFile)
names(trainActivities) <- "ActivityId"
#grab x file
allTrainRows <- read.fwf(trainMeasurementsFile, widths=rep(16,561), header=FALSE, col.names=columnNames$colname, colClasses=colclasses)
names(allTrainRows) <- colnames

#add two columns to data frame: 'subject', 'activity'
allTrainRows$subjectId <- trainSubjects[,'subjectId']
allTrainRows$activityName <- activityNames[trainActivities[,'ActivityId'],'activity']

#write new data frame to file and clean up memory
write.table(allTrainRows, newFile, append=TRUE, col.names=FALSE, , row.names=FALSE)
rm(allTrainRows)

#read new df into memory, containing both test and train data
newcol <- c(rep("numeric", 67), "character")
df1 <- read.table(newFile, header=TRUE, colClasses=newcol)
colnames2 <- c(colnames, "subjectId", "activityName")
names(df1) <- colnames2

#now create a new tidy data set containing averages of each variable per
#subject and activity
library(reshape2)
library(plyr)

melted <- melt(df1, id.vars=c("subjectId", "activityName"))
df2 <- ddply(melted, c("subjectId", "activityName", "variable"), summarise, mean=mean(value))

df3 <- dcast(df2, subjectId + activityName ~ ... )
newMeansFile <- "./data/means_by_subject_and_activity.txt"
write.table(df3, newMeansFile, append=FALSE, col.names=TRUE, row.names=FALSE)
