# Coursera Getting and Cleaning Data Course Project - Week 4


######################################################
## Config

# Should the dataset be downloaded
download_dataset <- FALSE
dataset_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataset_local_path <- "UCI_HAR_Dataset.zip"


######################################################


# 0. Download dataset if not present
if (download_dataset){
  if(!file.exists(dataset_local_path)){
    download.file(dataset_url, dataset_local_path, mode = "wb")
    unzip(dataset_local_path)
  }
}

#####################################################################################
# 1. Merge the training and the test sets to create one data set
library(dplyr)


# 1.1. read training set

# prepare column names
featureNames <- read.csv("./UCI HAR Dataset/features.txt", sep = " ", header = FALSE, stringsAsFactors = FALSE)
# create single column
#featureNames <- paste0(featureNames[,1],featureNames[,2])
featureNames <- featureNames[,2]
# clean names
featureNames <- gsub('-mean', 'Mean', featureNames)
featureNames <- gsub('-std', 'Std', featureNames)
featureNames <- gsub('[-()]', '', featureNames)

# read main train set
train_set <- read.table ("./UCI HAR Dataset/train/X_train.txt", col.names = featureNames)
# read additional label
train_lbl <- read.csv("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
colnames(train_lbl) <- c("Activity")
# read subject
train_subject <- read.csv("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
colnames(train_subject) <- c("Subject")
train_set_complete <- cbind(train_subject, train_lbl, train_set)

# clean up
rm(train_lbl)
rm(train_set)
rm(train_subject)

# 1.2. read test set

# read main test set
test_set <- read.table ("./UCI HAR Dataset/test/X_test.txt", col.names = featureNames)
# read additional label
test_lbl <- read.csv("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
colnames(test_lbl) <- c("Activity")
# read subject
test_subject <- read.csv("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
colnames(test_subject) <- c("Subject")
test_set_complete <- cbind(test_subject, test_lbl, test_set)

# clean up
rm(test_lbl)
rm(test_set)
rm(test_subject)
rm(featureNames)

# 1.3. combine sets
new_set <- rbind(train_set_complete, test_set_complete)

# clean up
rm(test_set_complete)
rm(train_set_complete)


# 2 Extract only the measurements on the mean and standard deviation for each measurement. 
# Assumption: the desired columns contain the string "std" or "mean"
new_set <- new_set[,c(1,2,grep("Std|Mean", colnames(new_set)))]


# 3 Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", colClasses = "character")
new_set$Activity <- plyr::mapvalues(new_set$Activity, activity_labels[,1], activity_labels[,2])
rm(activity_labels)

# 4 Appropriately label the data set with descriptive variable names
# -> already done in step 1 before merging the data sets


# 5 From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.
new_set <- aggregate(new_set[,3:ncol(new_set)], by = list(new_set[,1], new_set[,2]), FUN = mean)
names(new_set)[1] <- "Subject"
names(new_set)[2] <- "Activity"

# write final data set
write.table(new_set, "UCI_HAR_Dataset_processed.txt", row.names = FALSE)
