#### Run Analysis #### 
 ## This program collects, transforms, and cleans the UCI HAR Dataset. 
 

 ## The R script performs the following:  
 ## 1. Merges the training and the test sets to create one data set. 
 ## 2. Extracts only the measurements on the mean and standard deviation for each measurement.  
 ## 3. Uses descriptive activity names to name the activities in the data set 
 ## 4. Appropriately labels the data set with descriptive activity names.  
 ## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## Load requires packages 
require(reshape) 

mainwd <- "C:/Users/pr47993/Desktop/Data Science/3. Getting and Cleaning Data/Project" 
setwd(mainwd) 

rawdata <- "UCI HAR Dataset" 
train <- "train" 
test <- "test" 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
 
## Originally donwloaded on 2/17/2015 
download.file(url, file.path(mainwd,paste(rawdata,".zip",sep=""))) 
 
unzip(file.path(mainwd,paste(rawdata,".zip",sep="")))
 
## Load test files 
 filename <- file.path(mainwd,rawdata,test,"X_test.txt")  
 x_test <- read.table(filename) 
 
 filename <- file.path(mainwd,rawdata,test,"y_test.txt")  
 y_test <- read.table(filename) 
 
 filename <- file.path(mainwd,rawdata,test,"subject_test.txt")  
 subject_test <- read.table(filename) 

## Load train files 
 filename <- file.path(mainwd,rawdata,train,"X_train.txt")  
 x_train <- read.table(filename) 
 
filename <- file.path(mainwd,rawdata,train,"y_train.txt")  
 y_train <- read.table(filename) 

filename <- file.path(mainwd,rawdata,train,"subject_train.txt")  
subject_train <- read.table(filename) 

## Load features 
filename <- file.path(mainwd,rawdata,"features.txt")  
features <- read.table(filename) 

## activity_labels 
filename <- file.path(mainwd,rawdata,"activity_labels.txt")  
activity_labels <- read.table(filename) 

## assign colnames, in the case of x_test and x_train 
#3.Uses descriptive activity names to name the activities in the data set
colnames(x_test) <- features[,c("V2")] 
colnames(x_train) <- features[,c("V2")] 

## Note that this relates to: 
 ## 2. Extracts only the measurements on the mean and standard deviation for each measurement.  
 x_test <- x_test[,grepl("mean|std", colnames(x_test))] 
 x_train <- x_train[,grepl("mean|std", colnames(x_train))] 
 
colnames(y_test) <- "activity" 
colnames(y_train) <- "activity" 
 
colnames(subject_test) <- "subject" 
colnames(subject_train) <- "subject" 

## Merge test data 
 testdb <- cbind(y_test,subject_test,x_test) 
 
## Merge train data 
traindb <- cbind(y_train,subject_train,x_train) 

#1.Merges the training and the test sets to create one data set.
Data <- rbind(testdb,traindb )

## 3. Uses descriptive activity names to name the activities in the data set 
## 4. Appropriately labels the data set with descriptive activity names.  
Data$activity <- factor(Data$activity,levels = 1:6,labels = activity_labels$V2) 

## 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject.  
dbmelted <- melt(Data,id.vars = c("activity","subject")) 
dbcasted <- dcast(dbmelted, activity + subject ~ variable,mean) 

## Write Results 
tidydataout <- dbcasted 
write.csv(tidydataout, file = "tidydataout.txt",row.names = FALSE) 









