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

# Appropriately labels the data set with descriptive variable names.
feature_labels <- read.table(
  file        = "UCI HAR Dataset/features.txt",
  colClasses  = c("NULL", "character"),
)[ , 1]
feature_labels <- sub("BodyBody", "Body", feature_labels) # fix typos
names(activity)[3:563] <- make.names(feature_labels, unique = TRUE)

# Extracts only the measurements on the mean and standard deviation for each
# measurement.
signal_vars.label_root <- scan(
  file    = "UCI HAR Dataset/features_info.txt",
  what    = "character",
  skip    = 12,
  nlines  = 17
)
labels_regex <- sprintf(
  "^(%s)[.](mean|std)[.]",
  paste(sub("-XYZ", "", signal_vars.label_root), collapse = "|")
)
labels.vars_to_extract <- grep(
  labels_regex,
  names(activity),
  perl  = TRUE,
  value = TRUE
)
activity_summarized <- dplyr::select(activity, one_of(labels.vars_to_extract))
names(activity_summarized) <-gsub(
  "([.](?:mean|std))[.]{2}(?:[.]([XYZ]))?$",
  "\\2\\1",
  names(activity_summarized),
  perl = TRUE
)

# 5. From the data set in step 4, create a second, independent tidy data set
# with the average of each variable for each activity and each subject.
