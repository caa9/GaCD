# Code Book

## Data

The provided data files contain data for two different sets: **train** and **test**.  For each of these, the *X-* file contains the measured signals values, the *y-* file contains the activity type and the *subject-* file contains the test subject identity corresponding to each observation in the measured signals file.

The labels for the measured signals variables are contained in the provided *features.txt* file, and those for the activity types are in the provided *activity_labels.txt* file.

## Variables

As stated in the source documentation, the measured signals have been normalized and bounded within [-1,1].

When creating data frames, the original variable names have been left unchanged, with two exceptions:

- variable names have been made syntactically valid and unique
- variable names with a suffix indicating a dimensional axis have been modified in the subset data frame and the final tidy one, with the axis immediately appended to the variable name root --- e.g., "tBodyAcc-mean()-X" has become "tBodyAccX.mean".

See **Data Tidying** below for details.

## Data Tidying

### Reading data

The combined *train* and *test* data is read into the **signals** data frame.

Prior to adding the feature labels to the data frames, typos in the labels are corrected (viz., "BodyBody" strings in labels are changed to "Body").  Also, the labels are made syntactically valid and unique.

The activity labels are changed from uppercase to lowercase and are ingested as factor level labels (i.e., the *Activity* variable is reformatted as a factor).

### Mean / standard-deviation data

To determine which variables needs to be extracted in order to get the "mean and standard deviation for each measurement", the list of signals measured is slurped from the provided "features_info.txt" file.  This list becomes the basis for a regular expression used to find the relevant variables, which are subsequently extracted to form the new ***signals.summary_stats*** data frame.

### Averages of mean / standard-deviation data

To provide the tidy data set with the average of each extracted variable for each activity and each subject, the *melt* and *dcast* functions from the **reshape2** library are used.  The resulting data set is in the **signals.summary_stats.averages** data frame.
