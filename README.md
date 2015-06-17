## programmingAssignment3 - Human Activity Recognition Using Smartphones Dataset
This project records the gyroscopic and accelerometer measurements of 30 volunteers age 19-48 performing six activities while wearing a smart phone on the waist. This script downloads the data and cleans it from its original form to produce an independent long tidy data set, which describes the mean and standard deviation of each measurement and meets the principles of a long form tidy data set.  

#### Use 
To run the script, ensure that the reshape, plyr, dplyr and tidyr packages are installed (script loads them automatically) and set the working directory to the place you want to extract the tidy data set to and run the script.

#### Documentation
1. Codebook can be [found here](https://github.com/alunmeredith/programmingAssignment3/blob/master/codebook.md)  
2. Experiment documentation  [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).  
3. Original dataset [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip )  

####Process
0. Initialises the workspace
	- loads libraries
	- downloads and unzips the dataset
	- reads relevant files into data.frames
1. Merges training and test sets to create one data set
	- Uses cbind to connect the subject and activity variables to the accelerometer and gyroscope measurements.
	- Uses rbind to connect the test and training data sets. 
	- labels the headers using features.txt
2. Extracts only the measurements on mean and standard deviation from each measurement. 
	- Parses the column headings to find all variables containing "mean." or "std"
	    - Doesn't include angle() variables
	    - Doesn't include meanfreq() variables
3. Uses descriptive activity names to name the activities in the data set
	- numerical activity labels replaced using the index "activity_labels.txt"
4. Create a second independent tidy data set with the average of each variable for each activity and each subject.
    - Groups dataset by subject and activity.
		- Uses summarise_each() to compress data to the mean of each variable for each activity/subject 
	- Melts the wide dataset into a key-value pair. 
	- Uses grep to parse the variable(key) names and extract the variables from them. 
		- Stores new variables based on grep parsing
		- Appropriately labels new variables with descriptive names.
		- Coerces new variables to factor form. 
	- Casts the function variable (mean/std) 
	- Removes redundant variables from data frame. 
	- Arranges variables; fixed then measured variables. 
	- Deletes redundant variables from the workspace. 
	- Writes tidy data set to file. 
  
####Decision reasoning
A long(tall) dataset option has been chosen. The reasons for this are because a lot of variables are stored in the header names in the wide dataset. With so many variables it is difficult to parse and apply analysis functions to without using logical expressions to parse the variable names. Because all of the assignment data has been normalised it also strengthens the argument for long/tall data because they can now be directly compared. 

The meanFreq() and angle() means were excluded because these are a weighted average and the angle() variables are means over a signal window sample. In essense these variables are too far extracted from the raw data to be considered measurements, and no longer measure the same instantaneous frequency/time domain measurements of the other variables.  

