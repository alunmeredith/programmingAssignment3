## ------------------------------
## 0. Initialise and reading data
## ------------------------------

rm(list = ls()) # Make sure the workspace starts clear
library(plyr) # Load R packages
library(dplyr)
library(tidyr)

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
activity_labels <- read.table("activity_labels.txt", col.names=c("Activity", "Activity_id"))
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt", col.names="Activity")
subject_test <- read.table("test/subject_test.txt", col.names="Subject")
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt", col.names="Activity")
subject_train <- read.table("train/subject_train.txt", col.names="Subject")



## --------------------------------------------------------
## 1. Merging training and test sets to create one data set
## --------------------------------------------------------

# Bind the y-test/train.txt and subject-test/train.txt columns to the end
merged <- rbind(
              cbind(subject_train, y_train, x_train), 
              cbind(subject_test, y_test, x_test)
              )

# label the variables (make.names used because some of the features are repeated and col.names must be unique)
names(merged) <- make.names(names=c("Subject", "Activity", as.character(features$feature)), unique=TRUE, allow_=TRUE)



## ------------------------------------------------------------------------------------------
## 2. Extracts only the measurements on the mean and standard deviation from each measurement
## ------------------------------------------------------------------------------------------

merged <- tbl_df(merged)
# select columns with lower case mean  or std in them as well as the subject id and activity id columns. 
# (upper case mean represents the additional vectors from averaging signal window samples on the angle variable)
# also ignores meanfrequency which is also not a measurement
subset <- select(merged, Subject, Activity, contains("mean.", ignore.case = FALSE), contains("std"))
rm(merged)

## --------------------------------------------------------------------------
## 3.0 Uses descriptive activity names to name the activities in the data set 
## --------------------------------------------------------------------------

# Set the subject and activity id to factors rather than int
subset$Subject <- as.factor(subset$Subject)
subset$Activity <- as.factor(subset$Activity)
# Maps the labels from activity_labels to the factors
subset$Activity <- mapvalues(subset$Activity, activity_labels$Activity, as.character(activity_labels$Activity_id))


## ---------------------------------------------------------------------
## 4.0 Appropriately labels the data set with descriptive variable names
## ---------------------------------------------------------------------

# gsub mumbo jumbo
#This has been done earlier :)
rm(features)

## ------------------------------------------------------------------------------------------------------------------
## 5.0 Create a second independent tidy data set with the average of each variable for each activity and each subject
## ------------------------------------------------------------------------------------------------------------------
# collapses the rows into groups of subject/activity combo taking a mean of each
tidy <-
  subset %>%
  group_by(Subject, Activity) %>%
  summarise_each(funs(mean), -Subject, -Activity)

# Melts the variable names (besides subject, activity) into key - value pairs 
melted <- melt(tidy)

# Uses grep to parse the variable names (now key) and release variable data
# Creates new variable columns for Device, Dimension, Motion and Domain
melted[grep("Acc", as.character(melted$variable)), "Device"] = "Accelerometer"
melted[grep("Gyro", as.character(melted$variable)), "Device"] = "Gyroscope"
melted[grep(".X", as.character(melted$variable)), "Dimension"] = "X"
melted[grep(".Y", as.character(melted$variable)), "Dimension"] = "Y"
melted[grep(".Z", as.character(melted$variable)), "Dimension"] = "Z"
melted[grep("Mag", as.character(melted$variable)), "Dimension"] = "Mag"
melted[grep("Body", as.character(melted$variable)), "Motion"] = "Body"
melted[grep("Gravity", as.character(melted$variable)), "Motion"] = "Gravitational"
melted[grep( "^t", as.character(melted$variable)), "Domain"] = "Time"
melted[grep("^f", as.character(melted$variable)), "Domain"] = "Fequency"
melted[grep( "std", as.character(melted$variable)), "Function"] = "Standard Deviation"
melted[grep("mean", as.character(melted$variable)), "Function"] = "Mean"
melted[grep( "Jerk", as.character(melted$variable)), "Jerk"] = 1
melted$Jerk[is.na(melted$Jerk)] <- 0

# coerces the new variables into factor form. 
melted$Device <- as.factor(melted$Device)
melted$Dimension <- as.factor(melted$Dimension)
melted$Motion <- as.factor(melted$Motion)
melted$Domain <- as.factor(melted$Domain)
melted$Jerk <- as.factor(melted$Jerk)

# Removes the variable names / key, puts the measured values at the end. 
melted <- select(melted, Subject, Activity, Domain, Motion, Jerk, Dimension, value)

done <- dcast(melted, Subject + Activity + Device + Dimension + Domain + Motion + Jerk ~ Function, value.var = "value")
done <- arrange(done, Subject, Activity, Domain, Motion, Jerk, Dimension)

# remove redundant variables
#rm(x_test, x_train, y_test, y_train, subject_test, subject_train, activity_labels, tidy, subset)
