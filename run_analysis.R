## run_analysis

library(plyr)
library(dplyr)
library(reshape2)

# Get features labels
feature_labels <- read.table(
  file        = "UCI HAR Dataset/features.txt",
  colClasses  = c("NULL", "character"),
)[ , 1]
feature_labels <- sub("BodyBody", "Body", feature_labels)   # fix typos
feature_labels <- make.names(feature_labels, unique = TRUE) # make compliant

# Get training data set
train_signals <- read.table(
  file      = "UCI HAR Dataset/train/X_train.txt",
  col.names = feature_labels
)
train_signals.activity <- read.table(
  file        = "UCI HAR Dataset/train/y_train.txt",
  colClasses  = "integer",
  col.names   = "Activity"
)
train_signals.subjects <- read.table(
  file        = "UCI HAR Dataset/train/subject_train.txt",
  colClasses  = "integer",
  col.names   = "Subject"
)
train_signals <- data.frame(
  train_signals.subjects,
  Dataset = rep(c("train"), nrow(train_signals)),
  train_signals.activity,
  train_signals,
  stringsAsFactors = FALSE
)

# Get test data set
test_signals <- read.table(
  file      = "UCI HAR Dataset/test/X_test.txt",
  col.names = feature_labels
)
test_signals.activity <- read.table(
  file        = "UCI HAR Dataset/test/y_test.txt",
  colClasses  = "integer",
  col.names   = "Activity"
)
test_signals.subjects <- read.table(
  file        = "UCI HAR Dataset/test/subject_test.txt",
  colClasses  = "integer",
  col.names   = "Subject"
)
test_signals <- data.frame(
  test_signals.subjects,
  Dataset = rep(c("test"), nrow(test_signals)),
  test_signals.activity,
  test_signals,
  stringsAsFactors = FALSE
)

# Make single combined data set
signals <- rbind(train_signals, test_signals)
rm(list = ls(pattern = "(test|train|feature)")) # clean up

# Make 'activity' a well-described factor
activity_labels <- read.table(
  file        = "UCI HAR Dataset/activity_labels.txt",
  colClasses  = c("NULL", "character"),
)[ , 1]
signals$Activity <- factor(
  signals$Activity,
  labels = tolower(activity_labels)
)
rm(list = ls(pattern = "activity_labels")) # clean up

# Extract mean and standard deviation measurements into new data frame
vars.label_root <- scan(
  file    = "UCI HAR Dataset/features_info.txt",
  what    = "character",
  skip    = 12,
  nlines  = 17,
  quiet   = TRUE
)
labels_regex <- sprintf(
  "^(%s)[.](mean|std)[.]",
  paste(sub("-XYZ", "", vars.label_root), collapse = "|")
)
vars_to_extract.labels <- grep(
  labels_regex,
  names(signals),
  perl  = TRUE,
  value = TRUE
)
signals.summary_stats <- dplyr::select(
  signals,
  one_of(c("Subject", "Activity", vars_to_extract.labels))
)
names(signals.summary_stats) <-gsub(
  "([.](?:mean|std))[.]{2}(?:[.]([XYZ]))?$",
  "\\2\\1",
  names(signals.summary_stats),
  perl = TRUE
) # slight label formatting for variable names referencing dimension axes
rm(list = ls(pattern = "(labels|vars)")) # clean up

# Make independent tidy data set with  average of each variable,
# for each activity and each subject.
signals.melt <- melt(
  signals.summary_stats,
  id.vars = c("Subject", "Activity"),
)
signals.summary_stats.averages <- dcast(
  signals.melt,
  Activity + Subject ~ variable,
  mean
)

# Write final tidy set to file
write.table(
  x = signals.summary_stats.averages,
  file = "tidy_data.txt",
  row.names = FALSE
)
