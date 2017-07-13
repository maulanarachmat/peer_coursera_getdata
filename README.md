# peer_coursera_getdata
This repository is for week 4 assignment of Getting and Cleaning Data Course on coursera


# About Data
This data is form the experiments that have been carried out with a group of 30 volunteers people wihtin age range of 19-48 years.Each person performed six activities wearing smartphone on the waist. 
The six activities that have been performed are:
1. Walking
2. Walking_Upstairs
3. Walking_Downstairs
6. Sitting
7. Standing
8. Laying

Using the smartphone, we record the data from its embedded accelerometer (Acc) and gyroscope (Gyro) on the 3-axial signals. As the accelerometer signal have body motion (Body) and gravitational (Gravity) signal, they were separated.

Furthermore, from the Body linear accelaration and angular velocity were derived in time to obtain Jerk signals (BodyAccJerk and BodyGyroJerk). Also using euclidean norm, the magnitude (Mag) of there three-dimensional signals were calculated.

These data were obtained on time domain (t) and frequecy domain (f) which the results of Fast Fourier Transform (FFT) that was applied on some signals

A full description is available at the site where the data was obtained :
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

and the data can be download here
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# Process of Getting and Cleaning the Data
In this part, I will explain how the script run_analysis.R works.
#### 1. I am using plyr and dplyr packages
#### 2. Set the directory and load the data
      NOTE : Please set your directory to where the data available
#### 3. Cleaning data

##### 3.1. Feature and x-test/train data

As We look into dimension of the data, we can see that feature is the header of x-test/train data. As feature data is in a vector of Row, I transform the x-test/train data, merge it, then transform it back and make the feature value as header of x-test/train data. Furthermore set the value of data frame as numeric to be able to calculate later.
    
      NOTE : I use temp header and temp header for easy use to merge and understanding
      
##### 3.2. Activity labels, subject-test/train and y-test/train data
  
As We look into dimension of the data, we can see that subject-test/train and y-test/train data corresponds each other and y-test/train data is a code number in the activity labels data. So, I combined subject-test/train and y-test/train data and add a column that convert the activities code number (actnumber) to activities labels (actnames)
    
      NOTE : Apply header to each data for easy use and understanding
      
##### 3.3. Filter the data
  
As we asked to only show the measurement of mean and standard deviation from each measurement. So we need to filter the data from step 3.1 to be only measurement of mean() and std() for test/train data
    
##### 3.4. Combine the result of step 3.2 and 3.3 for each test/train data
  
In this step, We gonna have two datasets (test and train) that already contained the data of subject, activities(numbers and names/labels) and the measurement of mean and standard deviaton
    
##### 3.5. Merge test and train data
  
In this step we merge the two datasets obtained from step 3.4 to get one dataset and the process of cleaning data is done.
    
#### 4. Create independent tidy data set with the average of each variable for each activity and each subject

To get this independent tidy dataset I use operation summarise_all with the the result data from step 3, with function mean and group the result data on subjects and activities label (actnames).

Finally, create the txt file from this data set using write.table to be save on current working directory.

To be able to read result of independent data on txt file in R, use the following

      data <- read.table(file_path, header = TRUE)
      View(data)
  
# Reference of Data
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
