function run_analysis
{
    ##
    ##  Read the files into local tables
    ##
    
    ##  Features: id and names of 561 collected items for each time period
    #   Size = 561 x 2
    f_features = "./data//UCI HAR Dataset//features.txt"
    df_features <- read.table(f_features)
    
    ## Activity labels
    # Size = 6 x 2
    f_activity = "./data//UCI HAR Dataset//activity_labels.txt"
    df_activity <- read.table(f_activity)
    
    ##  Training data
    ##  labels
    #   Values = {1..6}, Size = 7352 x 1
    f_ytrain = "./data//UCI HAR Dataset//train//y_train.txt"
    df_ytrain <- read.table(f_ytrain)

    ##  Subjects
    #   Values = {1..30}, Size = 7352 x 1
    f_subject_train = "./data//UCI HAR Dataset//train//subject_train.txt"
    df_subject_train <- read.table(f_subject_train)

    ##  Measurements
    #   Size = 7352 x 561
    f_xtrain = "./data//UCI HAR Dataset//train//x_train.txt"
    df_xtrain <- read.table(f_xtrain, col.names = make.names(df_features[,2], unique=TRUE))

    #   Add a flag indicating this is training data (in case we want to back it out later)
    df_xtrain$train.flag <- factor(TRUE, c("FALSE","TRUE"))
    
    
    ##  Test data
    ##  labels
    #   Values = {1..6}, Size = 2947 x 1
    f_ytest = "./data//UCI HAR Dataset//test//y_test.txt"
    df_ytest <- read.table(f_ytest)
    
    ##  Subjects
    #   Values = {1..30}, Size = 2947 x 1
    f_subject_test = "./data//UCI HAR Dataset//test//subject_test.txt"
    df_subject_test <- read.table(f_subject_test)
        
    ##  Measurements
    #   Size = 2947 x 561
    f_xtest = "./data//UCI HAR Dataset//test//x_test.txt"
    df_xtest <- read.table(f_xtest, col.names = make.names(df_features[,2], unique=TRUE))
    # Add a flag indicating this is test data (in case we want to back it out later)
    df_xtest$train.flag <- factor(FALSE, c("FALSE","TRUE"))

    
    ##
    ##  Merge the training and test measurements into a single set
    ##
    df_fullset <- rbind(df_xtrain, df_xtest)
    #   Add activity field (factor with descriptive activity name)
    df_fullset$activity <- factor(as.numeric(unlist(rbind(df_ytrain, df_ytest))), levels = df_activity[,1], labels = df_activity[,2])
    #   Add a subject id to identify the subject collecting the measurements
    df_fullset$subject.id <- factor(as.numeric(unlist(rbind(df_subject_train, df_subject_test))), levels = 1:30)
    
    
    ##
    ## Extract only the measurements on the mean and std
    ##
    # Indices for columns with mean and std measurements
    col_mean_std <- c(grep("mean()", colnames(df_fullset)), grep("std()", colnames(df_fullset)))
    
    # Extract only mean and std measurements
    df_mean_std <- df_fullset[,col_mean_std]
    df_mean_std$activity <- df_fullset$activity
    df_mean_std$subject.id <- df_fullset$subject.id

    #   Load plyr library required by ddply
    library(plyr)
    #   Tidy data set summarized
    df_tidy <- ddply(df_mean_std, c("activity","subject.id"), numcolwise(mean))
    
    #  Write out tidy data file
    write.table(df_tidy, "./data/tidy_data.txt")
}
