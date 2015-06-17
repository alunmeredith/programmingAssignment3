---
title: "Programming Assignment 3 -- Codebook"
author: "Alun Meredith"
date: "27/06/2015"
output:
  html_document:
    keep_md: yes
---
 
## Project Description
Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

##Study design and data processing
 
###Collection of the raw data
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

###Notes on the original (raw) data 
The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals. Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm. Finally a Fast Fourier Transform (FFT) was applied to some of these signals. 

###Measurements in the raw data
For each record in the dataset it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

    tBodyAcc-XYZ           tBodyGyroJerk-XYZ        tBodyGyroMag             fBodyGyro-XYZ
    tGravityAcc-XYZ        tBodyAccMag              tBodyGyroJerkMag         fBodyAccMag
    tBodyAccJerk-XYZ       tGravityAccMag           fBodyAcc-XYZ             fBodyAccJerkMag
    tBodyGyro-XYZ          tBodyAccJerkMag          fBodyAccJerk-XYZ         fBodyGyroMag
    fBodyGyroJerkMag                                                        



#### Variables estimated from these signals: 

- mean(): Mean value
- std(): Standard deviation
- mad(): Median absolute deviation 
- max(): Largest value in array
- min(): Smallest value in array
- sma(): Signal magnitude area
- energy(): Energy measure. Sum of the squares divided by the number of values. 
- iqr(): Interquartile range 
- entropy(): Signal entropy
- arCoeff(): Autorregresion coefficients with Burg order equal to 4
- correlation(): correlation coefficient between two signals
- maxInds(): index of the frequency component with largest magnitude
- meanFreq(): Weighted average of the frequency components to obtain a mean frequency
- skewness(): skewness of the frequency domain signal 
- kurtosis(): kurtosis of the frequency domain signal 
- bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
- angle(): Angle between to vectors.

####Additional vectors 
Obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

- gravityMean
- tBodyAccMean
- tBodyAccJerkMean
- tBodyGyroMean
- tBodyGyroJerkMean

##Creating the tidy datafile
 
###Guide to create the tidy data file
The script downloads and extracts the zipfile to your current workind directory, please first navigate to desired directory  

 - Download the zip file "UCI HAR Dataset" to the working directory  
 - Unzip the zip file and move working directory into the UCI HAR Dataset directory  
 - reads test and training data sets to x_test, x_train.   
 - reads activity labels and column labels to activity_labels, features.   
 - reads subject id and activity id to subject_test, subject_train, y_test, y_train.   
 
###Cleaning of the data
 - Combines subject and activity id to training and test sets then merges to create one dataset
 - Adds the descriptive column labels indexed by features.txt to the data set
 - Selects only variables describing mean/std variables of observations.
    * This means means from the _additional vectors_ listed above which are obtained through signal windows on the angle variable are ignored along with other non-mean, non-standard deviation variables obtained from the signals. 
 - Changes the names of the activity factors to descriptive names as indexed in activity_labels
 - Collapses the rows into groups of subject and activity describing the mean of the variables for these groups.
 - Melts the features, then using grep parses the feature names to extract the variables "Device", "Dimension", "Motion", "Domain", "Jerk" and "function"
 - Converts these variables to factors, removes the feature names column and orders the variables fixed then observed.
 - Casts the Function variable giving two measurements, mean and standard deviation, orders the variables by the fixed variables in order of left to right.
 
See [readme](https://github.com/alunmeredith/programmingAssignment3/blob/master/README.md) for more information
 
##Variables in tidy data set
 - 5940 obs. of 9 variables
 - Variables: Subject, Activity, Device, Dimension, Domain, Motion, Jerk, Mean, Standard Deviation

####Subject:    
- Unique identifier for the person recording
- Factor: 30 levels 1:30  
- No unit of measurement (counts people) 
 
####Activity:   
- Activity person was engadged in while recording
- Factor: 6 levels: "WALKING", "WALKING_UPSTAIRS", "WALKING DOWNSTAIRS", "SITTING", "STANDING", "LAYING"
- No unit of measurement (descriptor)

####Device:     
- Which measuring device was recording, accelerometer or gyroscope
- Factor: 2 levels: "Accelerometer", "Gyroscope"
- No unit of measurement (descriptor)

####Dimension:  
- Each measurement is broken down into its magnitude along each unit vector.
- Mag is the magnitude along the unit vector describing current motion. 
- Factor: 4 levels: "X", "Y", "Z", "Mag"
- Units of measurement for each factor X:i-hat, Y:j-hat, Z:k-hat and Mag(unknown)
              
####Domain:     
- Frequency or time domain measurements
- Factor: 2 levels: "Frequency", "Time"
- Unit of measurement: Frequency Hz, Time: s
            
####Motion:     
- Body or gravitational source of motion based on a frequency filter.
- Factor: 2 levels: "Body", "Gravitational"
- No unit of measurement (descriptor)
            
####Jerk:       
- Was this a measurement of Jerk
- Factor: 2 levels: Not a Jerk measurement - "0", Jerk measurement - "1"
- No unit of measurement (descriptor)

####Mean:
- Mean of this measurement calculated
- Numeric
- No units as the data has been normalised between -1:1

####Standard Deviation:
- Standard Deviation of this measurement calculated
- Numeric
- No units as the data has been normalised between -1:1
 
##Sources
[http://vita.had.co.nz/papers/tidy-data.pdf](_Hadley Wickham_ Paper on *Tidy Data*)  
[https://class.coursera.org/getdata-015/forum/thread?thread_id=27](_David Hood_ forum post on *Tidy data and the Assignment**)  
[https://class.coursera.org/getdata-015/forum/thread?thread_id=26](_David Hood_ forum post on **David's personal course project FAQ**)  
[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](Data Source)  
[https://gist.github.com/JorisSchut/dbc1fc0402f28cad9b41](_Joris Schut_ codebook template)  


