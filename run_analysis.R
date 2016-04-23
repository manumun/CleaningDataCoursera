library(dplyr)

# Read the names of the 561 features and keep them as vector (column 2)
features=read.table("features.txt", stringsAsFactors = F)[,2]

# Read the names of the 6 ativities 
actNames=read.table("activity_labels.txt")[,2]

# Read and append (using rbind) the files with the activities
activs=rbind(read.table("train/y_train.txt"), read.table("test/y_test.txt"))[,1]

# Read and append the files with the subjects
subjects=rbind(read.table("train/subject_train.txt"), read.table("test/subject_test.txt"))[,1]

# Read and append the files with the real values
values=rbind(read.table("train/X_train.txt"), read.table("test/X_test.txt"))

# Create the data frame with all the information
total=data.frame(subjects, activs, values)

# Put column names, subject and activity are the first and the second, and then the features read from the file
colnames(total)=c("subject", "activity", features)

# Get the features that contain mean() or std()
# I assume the last in the file, gravityMean etc are NOT required, just the mean() columns
featuresMeanOrStd=union(grep("mean\\(\\)", features, value = T) , grep("std\\(\\)", features, value = T))

# subset the data frame for only those columns
total=total[, c("subject", "activity", featuresMeanOrStd)]

# change number to real name of the activity
total$activity=actNames[total$activity]

# clean up
rm(values)

# chain to group and then summarize each column
tidy=tbl_df(total) %>% group_by(subject, activity) %>% summarise_each(funs(mean))
