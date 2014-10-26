Getting and cleaning data
========================================================
Course : getdata-008
Author : Aditya Pandit

run_analysis.R 
contains all the commands necessary to get the raw data
It does all the steps necessary to merge the training and test data sets
Downloads and unzips the raw data

The data is Merged using the following steps:
Load all the feature names
Load the activity labels
Loads test data subjects
Loads test data feature names
Loads test data
Appends Test data subjects and feature names to test data
The above is then repeated for training data
Loads training data
Loads feature name as activity name
Loads training data
Appends subject and activity name to loaded training data

Now combines the training and test data
Then it Labels all activity numbers with descriptive labels
Gets only mean and standard deviation of measurements
Loads dplyr library
Convert combinedDataMeanStdOnly to a tbl_df table
Group the table and compute average for each column
Converts tbl_df back to data frame
Finally Writes  out the data frame as a text file

