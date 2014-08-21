# Data Cleaning project
John Guthrie

## sample cleaning of data
### method
the raw data is made up of test and training data. each raw data file has 79 attributes, and they combine to make up over 10,000 rows. there is a parallel set of entries for the activity type measured - this is contained in test and training sets of 10,000+ rows and a single attribute. the attribute is an integer, which maps to a string "activity type", as explained in the raw data REAMEs

### resulting data
there are 79 types of measurements involving mean or standard deviation. there are over 10,000 measurements. therefore the raw data, neatly arranged, is a 10000 by 79 data frame. this is increased to 10000+ by 80 when we add the activity type (one of "LAYING" "SITTING" "STANDING" "WALKING" "WALKING_DOWNSTAIRS" "WALKING_UPSTAIRS"). the tidy data set takes the average (mean) of each of those 10000 measurements, grouped by the 6 activities. the result is therefore a 79 by 6 matrix (the 80th attribute being the one groupled by, activity type)


