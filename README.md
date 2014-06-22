GetCleanData
============

Getting and Cleaning Data Class Project

**Data**

The data used for this project is in a zip file located [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

**Code**

R source code: *run_analysis.R*

* Loads the individual data files (test, training, features, and activities)
* Merge the test and training data together into a single table
* Add column for the subject id (participant identifier, 1-30)
* Add column for the activity id (STANDING, WALKING, etc)
* Extract the mean and std measurements into a separate table
* Create a summary of the extracted data set grouped by participant and activity
* Write the summarized, extracted data to a separate file
* Return the summarized, extracted data
