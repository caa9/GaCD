# Code Book

## Variables

## Data

## Tidying work
To determine which variables needs to be extracted in order to get the "mean and standard deviation for each measurement", the list of signals measured is slurped from the provided "features_info.txt" file.  This list becomes the basis for a regular expression used to find the relevant variables, which are subsequently extracted to form the new ***activity_summarized*** data frame.

### Building a single data set

The script starts off by reading the *train* and *test* data sets into separate data frames.  Then it adds three additional variables to each of these data sets:

1. a **Subject** variable, with values obtained from reading the corresponding *subject-* data file. 
1. a **dataset** variable indicating whether the observation belongs to the train or test dataset, with values manually populated.
1. an **activity** variable, with values obtained from reading the corresponding *y-* data file.

The *train* and *test* datasets are combined into the ***activity*** data frame.

### Adding descriptive variable labels / values

The **Activity Type** variable was reformatted as a factor, with the labels uploaded from the "activity_labels.txt" file provided in the data files set and converted to lowercase.

The feature labels are read from the provided "features.txt" file and subsequently made syntactically valid and unique.  Also, a "BodyBody" typo is fixed across a subset of labels.

For the extracted set of variables, the variable labels are cleaned up a bit.

### Averages of Measurements Summary Variables data set

To provide the tidy data set with the average of each extracted variable for each activity and each subject, the *melt* and *dcast* functions from the **reshape2** library are used.
