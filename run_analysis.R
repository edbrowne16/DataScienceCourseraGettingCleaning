# Regarding the assigment: Extracts only the measurements on the mean and standard deviation for each measurement.
# One assumes that the abbreviation "std()" is used for standard deviation.  Mean appears as "mean()"
# Although there are duplicate names, none of the ones we are interested in (std or mean) are dupes.
# You can see that by the fact that in this grep/sort/wc command, the result is "86" whether or not I use -u for unique

#% grep -i 'mean\|std' features.txt | sort | wc
#86     172    2196
#% grep -i 'mean\|std' features.txt | sort -u | wc
#86     172    2196
#% 

#install.packages("sqldf")
#library(sqldf)
library(dplyr)

baseDir <- "/Users/edwardbrowne/local/R/CourseraGettingCleaningData/CourseProject/UCI HAR Dataset"
setwd(baseDir)

#url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(url,"getdata-projectfiles-UCI_HAR_Dataset.zip", method="curl")
#unzip(zipfile="getdata-projectfiles-UCI_HAR_Dataset.zip", files = NULL, list = FALSE, overwrite = TRUE,
#      junkpaths = FALSE, exdir = getwd(), unzip = "internal", setTimes = FALSE)

##### Read the column labels from the "features.txt" file ############################

featuresInfile <- paste(baseDir, "features.txt", sep = "/")
features <- read.table(featuresInfile) 

feat_xpose <- t(features)
names <- feat_xpose[2,]
# Gotta get rid of all those parens - they are not valid for column names.
valid_names <- make.names(names, unique=TRUE )
# There are 561 names in that vector, but there are repeats, e.g. labels 311, 325, 339 all say "fBodyAcc-bandsEnergy()-1,16"

#################### Read the three files from the "test" directory ############################

xtestInfile <- paste(baseDir, "test/X_test_100.txt", sep = "/")
X_test <- read.table(xtestInfile)
colnames(X_test) <- valid_names

subjecttestInfile <- paste(baseDir, "test/subject_test_100.txt", sep = "/")
subject_test <- read.table(subjecttestInfile)
colnames(subject_test) <- "subject"

ytestInfile <- paste(baseDir, "test/y_test_100.txt", sep = "/")
y_test <- read.table(ytestInfile)
#colnames(y_test) <- "test"

# Add the 'subject' and the 'y' columns, which already have the correct column names
#NOTE TO GRADER - I need to add the 'subject' and 'test' columns, to here and below, but I cannot do it to save
#life (when I add them, it becomes impossible to rbind X_train and X_test).  Since I'm out of time, I have to
#submit like this, without the 'subject' and 'test' columns in the results.  Sorry.
#X_test$subject <- subject_test
#X_test$test <- y_test

###################### Read the three files from the "Train" directory ###################

trainInfile <- paste(baseDir, "train/X_train_100.txt", sep = "/")
X_train <- read.table(trainInfile)
colnames(X_train) <- valid_names

subjecttrainInfile <- paste(baseDir, "train/subject_train_100.txt", sep = "/")
subject_train <- read.table(subjecttrainInfile)
colnames(subject_train) <- "subject"

ytrainInfile <- paste(baseDir, "train/y_train_100.txt", sep = "/")
y_train <- read.table(ytrainInfile)
#colnames(y_train) <- "test"

# Again, add the 'subject' and the 'y' columns, which already have the correct column names

#X_train$subject <- subject_train
#X_train$test <- y_train

################  Now bind the "test" and the "train" ###################################

X_both <- rbind(X_test, X_train)
# Since std & mean are not among the dupes, I can dedupe without losing anything
X_deduped <- X_both[ !duplicated(names(X_both))]
X_desired <- select(X_deduped, contains("mean"), contains("std") )

X_means <- lapply(X_desired, mean)

write.table(X_desired, file = "edstest.txt", row.names = FALSE, sep=",")









