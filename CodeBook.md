https://github.com/vpantea/GettingAndCleaningDataProject repository contains run_analysis.R script for generating
a tidy data set, tidy.data.txt.
This tidy dataset contains aggregated data from a Human Activity Recognition Experiment that tries to identify an activity type
based on 561 types of features / measurements performed with smartphone embedded accelerometer and gyroscope worn by experiment subjects.
run_analysis.R script reads experiment output data (several .txt files) and generates the tidy dataset with mean and standard deviation measurements 
aggregated by activity type and experiment subjects.

Output Tidy dataset columns are 
===============================
Group.activity,"Group.subjects","activity","subjects","tBodyAcc-mean()-X","tBodyAcc-mean()-Y","tBodyAcc-mean()-Z","tBodyAcc-std()-X","tBodyAcc-std()-Y",...
where:
Group.activity and "Group.subjects" are the 2 input data/keys by which are grouped mean and standard deviation related features (measurements)
For each of these mean and standard deviation related features run_analysis.R script computes the average for each activity and subject.
So finally, tidy dataset columns are:
  Group.activity                 : chr  "WALKING" "WALKING_UPSTAIRS" "WALKING_DOWNSTAIRS" "SITTING" ...
	represents activity type and one of the input grouping criteria; also this column is a by-product of aggregate() function 
  Group.subjects                 : int  1 1 1 1 1 1 2 2 2 2 ...
	represents experiment subjects index and the 2nd input grouping criteria by which measurements are averaged; also this column is a by-product of aggregate() function
  activity                       : chr  "WALKING" "WALKING_UPSTAIRS" "WALKING_DOWNSTAIRS" "SITTING" ...
	same info as  Group.activity but it's not a by-product being the original activity column
  subjects                       : num  1 1 1 1 1 1 2 2 2 2 ...
	same info as  Group.subjects but it's not a by-product being the original subjects column
  tBodyAcc-mean()-X              : num  0.277 0.255 0.289 0.261 0.279 ...
	one of the 79 aggregated/averaged measurements; representing the mean of the measured body acceleration along the X axis, averaged by activity and subject
  fBodyBodyGyroJerkMag-std()     : num  -0.382 -0.694 -0.392 -0.987 -0.995 ...
	another of the 79 aggregated/averaged measurements; representing the standard deviation of the processed Triaxial Angular velocity, averaged by activity and subject
	........
  fBodyBodyGyroJerkMag-meanFreq(): num  0.191 0.114 0.19 0.185 0.334 ...
	lastof t he 79 aggregated/averaged measurements; 
	
Input experiment data
=====================
There are 2 subsets of experiment measurements:
1. for training
2. for test
Each subset contains 3 input data files, whose rows correspond to experiment observations:
1. subject_train.txt / subject_test.txt contain observation subject id
2. X_train.txt / X_test.txt contain measured features
3. y_train.txt / y_test.txt contain measured activity type for each observation / row in input data file 

Besides these files there are the following description files:
1. activity_labels.txt		contains the mapping activity type <--> activity name
2. features.txt				the names of 561 features measured

Steps performed by run_analysis.R script to generate the tidy dataset from the input experiment data
====================================================================================================
For both the training and test subsets run_analysis.R reads the input data files and gather the activity, subjects and features in 1 data.frame:
dfTraining for training subset and dfTest for test subset
Each of these subsets have different observations/rows but the same columns (activity, subjects and measured features)
The feature columns receive  as column names  the features labels from features.txt

Having same columns, the 2 subsets are simply concatenated using:
df <- rbind(dfTraining, dfTest), obtaining only 1 big dataframe df

Next step is filtering dataframe features so we'll keep only features related to mean or standard deviation measurements. This is realized by detecting 
features whose labels contain "mean" or "std", retrieving their column indexes inside the data.frame and excluding all other columns minus first 2 columns
related to activity and subjects.
This filtering is performed by:
dfReduced <- df[,df_colnames]	where dfReduced is the new data.frame.
Computing the average of each remaining measurements by activity type and subject is done simply with:
aggdata <-aggregate(dfReduced, by=list(Group.activity=dfReduced$activity, Group.subjects=dfReduced$subjects), FUN=mean, na.rm=TRUE)
So the required tidy dataset is aggdata data.frame.
For more clarity, inside aggdata data.frame we replace each activity index with its label

  
 


