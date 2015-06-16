## ------------------------------
## 0. Initialise and reading data
## ------------------------------

rm(list = ls()) # Make sure the workspace starts clear
library(plyr) # Load R packages
library(dplyr)

## !!!!!!!!!! improve this so it doesn't have my username (generalise!)
wd = "C:/Users/Alun/Documents/Work/Coding/Coursera/Data Cleaning/"
setwd(wd) # Set working directory

## download and extract zip
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(url, dest="dataset.zip", mode="wb")
unzip("dataset.zip")
wd = "C:/Users/Alun/Documents/Work/Coding/Coursera/Data Cleaning/UCI HAR Dataset"
setwd(wd)
rm(url)

# Read variables/data frames
features <- read.table("features.txt", col.names=c("feature_id", "feature"))
activity_labels <- read.table("activity_labels.txt", col.names=c("activity", "activity"))
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt", col.names="activity")
subject_test <- read.table("test/subject_test.txt", col.names="subject")
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt", col.names="activity")
subject_train <- read.table("train/subject_train.txt", col.names="subject")



## --------------------------------------------------------
## 1. Merging training and test sets to create one data set
## --------------------------------------------------------

# Bind the y-test/train.txt and subject-test/train.txt columns to the end
merged <- rbind(
              cbind(subject_train, y_train, x_train), 
              cbind(subject_test, y_test, x_test)
              )

# label the variables (make.names used because some of the features are repeated and col.names must be unique)
names(merged) <- make.names(names=c("subject", "activity", as.character(features$feature)), unique=TRUE, allow_=TRUE)



## ------------------------------------------------------------------------------------------
## 2. Extracts only the measurements on the mean and standard deviation from each measurement
## ------------------------------------------------------------------------------------------

merged <- tbl_df(merged)
# select columns with lower case mean  or std in them as well as the subject id and activity id columns. 
# (upper case mean represents the additional vectors from averaging signal window samples on the angle variable)
# also ignores meanfrequency which is also not a measurement
subset <- select(merged, subject, activity, contains("mean.", ignore.case = FALSE), contains("std"))
rm(merged)

## --------------------------------------------------------------------------
## 3.0 Uses descriptive activity names to name the activities in the data set 
## --------------------------------------------------------------------------

# Set the subject and activity id to factors rather than int
subset$subject <- as.factor(subset$subject)
subset$activity <- as.factor(subset$activity)
# Maps the labels from activity_labels to the factors
subset$activity <- mapvalues(subset$activity, activity_labels$activity, as.character(activity_labels$activity))
rm(activity_labels)

## ---------------------------------------------------------------------
## 4.0 Appropriately labels the data set with descriptive variable names
## ---------------------------------------------------------------------

# gsub mumbo jumbo
#This has been done earlier :)
rm(features)

## ------------------------------------------------------------------------------------------------------------------
## 5.0 Create a second independent tidy data set with the average of each variable for each activity and each subject
## ------------------------------------------------------------------------------------------------------------------
library(tidyr)
# collapses the rows into groups of subject/activity combo taking a mean of each
tidy <-
  subset %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean), -subject, -activity) %>%
  
  gather(Key, value, -subject, -activity) %>%
  extract(key, c("Device", "rest"), "/acc/")
  
  gather(Accelerometer, acc_value, contains("acc"), -subject, -activity) %>%
  gather(Gyroscope, gyro_value, contains("gyro"), -subject, -activity, -acc_value, -Accelerometer)

# remove redundant variables
rm(x_test, x_train, y_test, y_train, subject_test, subject_train)

## testing git