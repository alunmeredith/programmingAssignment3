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

!!!!!!!!!!See 'features_info.txt' for more details.

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
 - Changes the names of the activity factors to descriptive names as indexed in activity_labels
 - Collapses the rows into groups of subject and activity describing the mean of the variables for these groups.
 - Melts the features, then using grep parses the feature names to extract the variables "Device", "Dimension", "Motion", "Domain", "Jerk" and "function"
 - Converts these variables to factors, removes the feature names column and orders the variables fixed then observed.
 - Casts the Function variable giving two measurements, mean and standard deviation, orders the variables by the fixed variables in order of left to right.
 [link to the readme document that describes the code in greater detail]()
 
##Description of the variables in the tiny_data.txt file
General description of the file including:
 - 5940 obs. of 9 variables
 - Subject, Activity, Device, Dimension, Domain, Motion, Jerk, Mean, Standard Deviation
 
Subject:    Unique identifier for the person recording
            Factor: 30 levels 1:30
            No unit of measurement (counts people) 
 
Activity:   Activity person was engadged in while recording
            Factor: 6 levels: "WALKING", "WALKING_UPSTAIRS", "WALKING DOWNSTAIRS", "SITTING", "STANDING", "LAYING"
            No unit of measurement (descriptor)

Device:     Which measuring device was recording, accelerometer or gyroscope
            Factor: 2 levels: "Accelerometer", "Gyroscope"
            No unit of measurement (descriptor)

Dimension:  Each measurement is broken down into its magnitude along each unit vector.
            Mag is the magnitude along the unit vector describing current motion. 
            Factor: 4 levels: "X", "Y", "Z", "Mag"
            Units of measurement for each factor X:i-hat, Y:j-hat, Z:k-hat and Mag(unknown)
              
Domain:     Frequency or time domain measurements
            Factor: 2 levels: "Frequency", "Time"
            Unit of measurement: Frequency Hz, Time: s
            
Motion:     Body or gravitational source of motion based on a frequency filter.
            Factor: 2 levels: "Body", "Gravitational"
            No unit of measurement (descriptor)
            
Jerk:       Was this a measurement of Jerk
            Factor: 2 levels: Not a Jerk measurement - "0", Jerk measurement - "1"
            No unit of measurement (descriptor)

Mean:       Mean of this measurement calculated
            Numeric
            Units: Hz if frequency is measured, seconds if time is measured. 
 
##Sources
Sources you used if any, otherise leave out.
