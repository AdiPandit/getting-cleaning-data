#Downloads the raw data to a local directory
downloadRawData <- function(downloadUrl,localDir) {
    temp <- tempfile()
    download.file(downloadUrl,temp,method="curl")
    unzip(temp,exdir=localDir)
}

downloadUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
localDir <- "raw-data"
downloadRawData(downloadUrl,localDir)

#Merges the training and the test sets to create one data set.

#load the featureNames information that we will use to label the dataset column names later
featureNames <- read.table("raw-data/UCI HAR DataSet/features.txt", col.names = c("featureNumber","featureName"))
#load the activity labels
activityLabels <- read.table("raw-data/UCI HAR DataSet/activity_labels.txt", col.names = c("activityName","activityLabel"))

#loadTestData with descriptive column names and activity label codes
testDataSubjects <- read.table("raw-data/UCI HAR DataSet/test/subject_test.txt",col.names=c("subject"))
testData <- read.table("raw-data/UCI HAR DataSet/test/X_test.txt", col.names=featureNames$featureName)
testDataActivities <- read.table("raw-data/UCI HAR DataSet/test/y_test.txt",col.names=c("activityName"))
testData <- cbind(testData,testDataActivities)
testData <- cbind(testData,testDataSubjects)

#loadTrainingData with descriptive column names and activity label codes
trainDataSubjects <- read.table("raw-data/UCI HAR DataSet/train/subject_train.txt",col.names=c("subject"))
trainData <- read.table("raw-data/UCI HAR DataSet/train/X_train.txt", col.names=featureNames$featureName)
trainDataActivities <- read.table("raw-data/UCI HAR DataSet/train/y_train.txt",col.names=c("activityName"))
trainData <- cbind(trainData,trainDataActivities)
trainData <- cbind(trainData,trainDataSubjects)

#combine the two
combinedData <- rbind(testData,trainData)

#uncomment the following and install qdap if not installed 
combinedData$activityName[combinedData$activityName == 1] <- "WALKING"
combinedData$activityName[combinedData$activityName == 2] <- "WALKING_UPSTAIRS"
combinedData$activityName[combinedData$activityName == 3] <- "WALKING_DOWNSTAIRS"
combinedData$activityName[combinedData$activityName == 4] <- "SITTING"
combinedData$activityName[combinedData$activityName == 5] <- "STANDING"
combinedData$activityName[combinedData$activityName == 6] <- "LAYING"

#only mean and standard deviation of measurements
combinedDataMeanStdOnly <- combinedData[,grepl("*mean*|*std*|subject|activityName", names(combinedData))]

library(dplyr)
combinedDataTable <- tbl_df(combinedDataMeanStdOnly)
groupedActivityAverages <- combinedDataTable %.% group_by(activityName,subject) %.% summarise_each(funs(mean))
#convert tbl_df back to data frame
groupedActivityAveragesDF <- as.data.frame(groupedActivityAverages)
write.table(groupedActivityAveragesDF,file="groupedActivityAverages.txt",row.names=FALSE)

