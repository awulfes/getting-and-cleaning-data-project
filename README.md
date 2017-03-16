# Coursera Getting and Cleaning Data Course Project - Week 4

This is my submission for the course project in the 'Getting and Cleaning Data' course.

The is based on the Human Activity Recognition Using Smartphones Data Set in: [The UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

For this dataset the following processing steps are executed via the `run_analysis.R` script:

1. Merge the original training and the test sets to create one data set
2. Extract only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The end result is written to a new file 'UCI_HAR_Dataset_processed.txt'
