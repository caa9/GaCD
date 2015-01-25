## run_analysis

# Merges the training and the test sets to create one data set.

train_data <- read.table("UCI HAR Dataset/train/X_train.txt")
train_data.activity <- read.table(
  file        = "UCI HAR Dataset/train/y_train.txt",
  colClasses  = "integer",
  col.names   = "Activity.Type"
)
train_data <- data.frame(
  Dataset = rep(c("train"), nrow(train_data)),
  train_data.activity,
  train_data,
  stringsAsFactors = FALSE
)

test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
test_data.activity <- read.table(
  file        = "UCI HAR Dataset/test/y_test.txt",
  colClasses  = "integer",
  col.names   = "Activity.Type"
)
test_data <- data.frame(
  Dataset = rep(c("test"), nrow(test_data)),
  test_data.activity,
  test_data,
  stringsAsFactors = FALSE
)

activity <- rbind(train_data, test_data)

# Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table(
  file        = "UCI HAR Dataset/activity_labels.txt",
  colClasses  = c("NULL", "character"),
)[ , 1]

activity$Activity.Type <- factor(
  activity$Activity.Type,
  labels = tolower(activity_labels)
)

# 2. Extract only the measurements on the mean and standard deviation for each
# measurement.

# 4. Appropriately label the data set with descriptive variable names. 

# 5. From the data set in step 4, create a second, independent tidy data set
# with the average of each variable for each activity and each subject.
