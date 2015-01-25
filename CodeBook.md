# Code Book

## Variables

## Data

## Tidying work

### Building a single data set

The script starts off by reading the *train* and *test* data sets into separate data frames.  Then it adds two additional variables to each of these data sets:

1. a **dataset** variable indicating whether the observation belongs to the train or test dataset, with values manually populated.
1. an **activity** variable, with values obtained from reading the corresponding *y-* data file.

The *train* and *test* datasets are combined into the ***activity*** data frame.
