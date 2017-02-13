
# Step 1
# Merge the training and test sets to create one data set
###############################################################################
library(tidyr)

## Reading Test and Train text files of x, y,subject, as data frames into R
X_TRAIN <- read.table("train/X_train.txt")
Y_TRAIN <- read.table("train/y_train.txt")
SUBJECT_TRAIN <- read.table("train/subject_train.txt")
X_TEST <- read.table("test/X_test.txt")
Y_TEST <- read.table("test/y_test.txt")
SUBJECT_TEST <- read.table("test/subject_test.txt")

##Binding or Merging Rows of Text and Train files
library(dplyr)
X_DATA <- bind_rows(X_TRAIN,X_TEST)
Y_DATA <- bind_rows(Y_TRAIN,Y_TEST)
SUBJECT_DATA <- bind_rows(SUBJECT_TEST,SUBJECT_TRAIN)

# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
###############################################################################

## Reading features text file as data frame into R
TAB_FEATURES <- read.table("features.txt")

# Selecting rows with having mean() and std() from features file
MEAN_STD_FEATURES <- grep("-(mean|std)\\(\\)", TAB_FEATURES[, 2])

# subsetting X_DATA  for mean and std columns
X_MEAN_STD <- X_DATA[, MEAN_STD_FEATURES]

# Changing column names
names(X_MEAN_STD) <- TAB_FEATURES[MEAN_STD_FEATURES, 2]

# Step 3
# Use descriptive activity names to name the activities in the data set
###############################################################################

## Reading activities text file as data frame into R
TAB_ACTIVITIES <- read.table("activity_labels.txt")

# Update values with correct activity names
Y_DATA[, 1] <- TAB_ACTIVITIES[Y_DATA[, 1], 2]

# Changing column name
names(Y_DATA) <- "Activity"

# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

#Changing Column names
names(SUBJECT_DATA) <- "Subject"

# bind all the data in a single data set
X_Y_SUBJECT <- cbind(X_MEAN_STD, Y_DATA, SUBJECT_DATA)

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# 66 <- 68 columns but last two (activity & subject)

## loading plyr for ddply function
library(plyr)
AVERAGES_DATA <- ddply(X_Y_SUBJECT, .(Subject, Activity), function(x) colMeans(x[, 1:66]))
write.table(AVERAGES_DATA, "AVERAGES_DATA.txt", row.name=FALSE)