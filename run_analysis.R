#setwd("C:\\Coursera\\Getting and Cleaning Data\\GettingAndCleaningDataProject")

# 1. Merges the training and the test sets to create one data set.
#	=============================================================

# read training features
features_train <- read.table(file="./X_train.txt", header = FALSE, sep = "",  stringsAsFactors=FALSE)
# read features labels
features_labels <- read.table(file="./features.txt", header = FALSE, sep = "",  stringsAsFactors=FALSE)
# 4. Appropriately labels the data set with descriptive activity names. 
colnames(features_train) <- features_labels[,2]
# read training activity
activity_train <- read.table(file="./y_train.txt", header = FALSE, sep = "",  stringsAsFactors=FALSE) 
colnames(activity_train) <- c("activity")
# read activity labels, common for training & test sets
activity_labels <- read.table(file="./activity_labels.txt", header = FALSE, sep = "",  stringsAsFactors=FALSE) 
colnames(activity_labels) <- c("ndx", "activity")
# read training set persons
subjects_train <- read.table(file="./subject_train.txt", header = FALSE, sep = "",  stringsAsFactors=FALSE) 
colnames(subjects_train) <- c("subjects")
# merge training subjects & activities
dfTraining <- cbind(activity_train, subjects_train)	
# merge training features	
dfTraining <- cbind(dfTraining, features_train)
#tail(dfTraining)

# read test features
features_test <- read.table(file="./X_test.txt", header = FALSE, sep = "",  stringsAsFactors=FALSE)
# 4. Appropriately labels the data set with descriptive activity names. 
colnames(features_test) <- features_labels[,2]
# read test activity
activity_test <- read.table(file="./y_test.txt", header = FALSE, sep = "",  stringsAsFactors=FALSE) 
colnames(activity_test) <- c("activity")
# read test set persons
subjects_test <- read.table(file="./subject_test.txt", header = FALSE, sep = "",  stringsAsFactors=FALSE) 
colnames(subjects_test) <- c("subjects")
# merge test subjects & activities
dfTest <- cbind(activity_test, subjects_test)	
# merge testing features	
dfTest <- cbind(dfTest, features_test)
#tail(dfTest)
#ncol(dfTest)
#nrow(dfTest)
# finally merge training & test sets
df <- rbind(dfTraining, dfTest)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# ==========================================================================================
# get indexes of the columns containing "mean" in their names 
mean_ndxs <- grep("mean", colnames(df), ignore.case=TRUE, fixed=TRUE)
# get indexes of the columns containing "std" in their names
std_ndxs <- grep("std", colnames(df), ignore.case=TRUE, fixed=TRUE)
# construct a logical vector of {TRUE,FALSE} for filtering columns only for the measurements on the mean and standard deviation 
df_colnames <- rep(FALSE, ncol(df))
for(n in mean_ndxs)	
	df_colnames[n] <- TRUE
for(n in std_ndxs)	df_colnames[n] <- TRUE
df_colnames[1] <- TRUE
df_colnames[2] <- TRUE
dfReduced <- df[,df_colnames]

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# ====================================================================================================================

aggdata <-aggregate(dfReduced, by=list(Group.activity=dfReduced$activity, Group.subjects=dfReduced$subjects), FUN=mean, na.rm=TRUE)
#ncol(aggdata)
#nrow(aggdata)

# 3. Uses descriptive activity names to name the activities in the data set
# =========================================================================
# replace activity codes with their labels
for(actNdx in activity_labels$ndx)
{
	aggdata$activity[aggdata$activity == actNdx] <- activity_labels$activity[actNdx]
	aggdata$Group.activity[aggdata$Group.activity == actNdx] <- activity_labels$activity[actNdx]
}

# 6. persist tidy dataset into the file tidy.data.txt including column names and "," as column separator 
write.table(aggdata, file="tidy.data.txt", sep=",", col.names = TRUE, row.names = FALSE)

