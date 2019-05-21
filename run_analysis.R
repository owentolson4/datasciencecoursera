##Prep Work
setwd("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset")
library(dplyr)

features <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activity <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
xtrain <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
ytrain <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/train/y_train.txt", col.names = "code")
subjectTrain <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
xtest <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
ytest <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subjectTest <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

## 2. Merges the training and the test sets to create one data set.
xdata <- rbind(xtrain, xtest)
ydata <- rbind(ytrain, ytest)
subjectData <- rbind(subjectTrain, subjectTest)
mergeData <- cbind(subjectData, xdata, ydata)

## 3. Extracts only the measurements on the mean and standard deviation for each measurement.
extractData <- mergeData %>% 
               dplyr::select(subject, code, contains("mean"), contains("std"))
               
names(extractData)
## 4. Uses descriptive activity names to name the activities in the data set.
extractData$code <- activity[extractData$code, 2]

## 5. Appropriately labels the data set with descriptive variable names.
names(extractData)[2] = "activity"
names(extractData)<-gsub("Acc", "Accelerometer", names(extractData))
names(extractData)<-gsub("Gyro", "Gyroscope", names(extractData))
names(extractData)<-gsub("BodyBody", "Body", names(extractData))
names(extractData)<-gsub("Mag", "Magnitude", names(extractData))
names(extractData)<-gsub("^t", "Time", names(extractData))
names(extractData)<-gsub("^f", "Frequency", names(extractData))
names(extractData)<-gsub("tBody", "TimeBody", names(extractData))
names(extractData)<-gsub("-mean()", "Mean", names(extractData), ignore.case = TRUE)
names(extractData)<-gsub("-std()", "STD", names(extractData), ignore.case = TRUE)
names(extractData)<-gsub("-freq()", "Frequency", names(extractData), ignore.case = TRUE)
names(extractData)<-gsub("angle", "Angle", names(extractData))
names(extractData)<-gsub("gravity", "Gravity", names(extractData))

names(extractData)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
secondData <- extractData %>% 
     dplyr::group_by(activity, subject) %>% 
     dplyr::summarise_all(list(mean))

write.table(secondData, "secondData.txt", row.name = FALSE)


