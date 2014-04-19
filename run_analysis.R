testing = T # limit number of rows/columns during development

library(reshape2)

measurements <- read.table('UCI HAR Dataset/features.txt', colClasses = c('numeric', 'character'), comment.char = '')
colnames(measurements) <- c('id', 'name')

# apply dev limit
line_limit <- if (testing) 100 else -1
measurement_count <- if (testing) 3 else length(measurements$id)
if (testing) {
	measurements <- measurements[1:measurement_count,]
}

train <- read.fwf('UCI HAR Dataset/train/X_train.txt', widths = rep(c(-1, 15), measurement_count), colClasses = 'numeric', comment.char = '', n = line_limit)
train$y <- read.fwf('UCI HAR Dataset/train/y_train.txt', widths = 1, colClasses = 'numeric', comment.char = '', n = line_limit)[, 1]
train$subject <- read.fwf('UCI HAR Dataset/train/subject_train.txt', widths = 2, colClasses = 'numeric', comment.char = '', n = line_limit)[, 1]

test <- read.fwf('UCI HAR Dataset/test/X_test.txt', widths = rep(c(-1, 15), measurement_count), colClasses = 'numeric', comment.char = '', n = line_limit)
test$y <- read.fwf('UCI HAR Dataset/test/y_test.txt', widths = 1, colClasses = 'numeric', comment.char = '', n = line_limit)[, 1]
test$subject <- read.fwf('UCI HAR Dataset/test/subject_test.txt', widths = 2, colClasses = 'numeric', comment.char = '', n = line_limit)[,1]

# 1. Merge the training and the test sets to create one data set
# (merge by columns, since training and test data contain same variables for same kind of observations for different volunteers)
all <- merge(train, test, all = T)

# 2. Extract only the measurements on the mean and standard deviation for each measurement
# (and also keep additional data
measurements_wanted <- grep('-(mean|std)', measurements$name)
all <- all[, c(measurements_wanted, (measurement_count+1):(measurement_count+2))]

# 3. Use descriptive activity names to name the activities in the data set
activities <- read.table('UCI HAR Dataset/activity_labels.txt', colClasses = c('numeric', 'character'), comment.char = '')
colnames(activities) <- c('id', 'name')
all$activity <- factor(all$y, levels = activities$id, labels = activities$name)

# 4. Appropriately label the data set with descriptive activity names
measurement_indexes <- 1:length(measurements_wanted)
measurement_names <- measurements[measurements_wanted, 'name']
colnames(all)[measurement_indexes] <- measurement_names

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject
molten <- melt(all, measure.vars = measurement_names)
averages <- dcast(molten, y + subject + activity ~ variable, mean)
colnames(averages)[-(1:3)] <- paste("Average.", colnames(averages)[-(1:3)], sep = '')
