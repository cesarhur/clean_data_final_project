# clean_data_final_project
Final project for Clean Data course


The submitted code contains only one script.  At a high level, this script reads and combines test and training data, extracts relevant columns, and calculates means on these columns by subject and activity.

In more detail, this script:
1. Downloads the original data set from the website.
2. Reads column names and other useful data, such as activity ID->activity Name mapping.
3. Reads test data into a data frame, consuming only relevant columns: means and std's.
4. New columns for subject ID and for activity name are added.
5. The test data is saved into file "all_values_by_subject_and_activity.txt".  The data frame is then removed from memory.
6. Training data is read similarly to test data.
7. Training data is appended to file "all_values_by_subject_and_activity.txt".  The training data frame is removed from memory.
8. The file "all_values_by_subject_and_activity.txt" now contains the combination of test and training data.  It is then read into a new data frame.
9. The data frame is transformed by Melting data into a new data frame containing SubjectId, ActivityName, variable name, and value.
10.  The melted data is cast into a new 2-dimensional data frame, using average to summarize the data by subjectId and activityName.  The newly cast data frame has 68 columns, where the first 2 columns identify rows uniquely using (subjectId, activityName) pairs, and where the remaining 66 columns are the names of the variables that were averaged.
11.  The melted data is then stored into filename "means_by_subject_and_activity.txt".
