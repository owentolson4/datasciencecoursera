---
title: "README"
author: "Owen Tolson"
date: "May 21, 2019"
output: html_document
---

## Prep Work

 - The first step in this analysis ensured the working directory was set properly, all necessary librarys were available, and the data (8 dataframes) were imported. 
 
## 1. Assign each data to variables
```{r include = FALSE}
library(dplyr)
features <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activity <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
xtrain <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
ytrain <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/train/y_train.txt", col.names = "code")
subjectTrain <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
xtest <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
ytest <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subjectTest <- read.table("C:/Users/Owen.Tolson/Desktop/R Practice/Getting and Cleaning Data/WK4/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
```

`features` dataframe is "features.txt"
`activity` dataframe is "activity_labels.txt"
`xtrain` dataframe is "X_train.txt"
`ytrain` dataframe is "y_train.txt"
`subjectTrain` dataframe is "subject_train.txt"
`xtest` dataframe is "X_test.txt"
`ytest` dataframe is "y_test.txt"
`subjectTest` dataframe is "subject_test.txt"

## 2. Merges the training and the test sets to create one data set.

```{r echo = FALSE}
xdata <- rbind(xtrain, xtest)
ydata <- rbind(ytrain, ytest)
subjectData <- rbind(subjectTrain, subjectTest)
mergeData <- cbind(subjectData, xdata, ydata)
```
Here we combined like items with `xdata` being the combined rows of `xtrain` and `xtest`, `ydata` being the combined rows of `ytrain` and `ytest`, and `subjectData` being the combined rows of `subjectTrain` and `subjectTest`.

Once we had these three variables we merged the columns together to `mergeData`

## 3. Extracts only the measurements on the mean and standard deviation for each measurement.

Using dplyr select feature we can create `extractData` by searching for character strings within the variable names ("mean" and "std"). 

```{r, echo = FALSE}
extractData <- mergeData %>% 
               dplyr::select(subject, code, contains("mean"), contains("std"))
```

## 4. Uses descriptive activity names to name the activities in the data set.
Here we replace the `code` variable (a number) information with the appropriate `activity` variable information.

```{r echo = FALSE}
extractData$code <- activity[extractData$code, 2]
```

## 5. Appropriately labels the data set with descriptive variable names.
In this section we renamed all of the abbreviated variable names (Acc, Gyro, BodyBody, Mag, f, and t) with their descriptive variable names. 

## 6. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```{r echo = false}
secondData <- extractData %>% 
     dplyr::group_by(activity, subject) %>% 
     dplyr::summarise_all(list(mean))

write.table(secondData, "secondData.txt", row.name = FALSE)
```

`secondData` is created by grouping and summarizing the mean of all activity and subject data. This is stored to the working directory using the write table function. 

