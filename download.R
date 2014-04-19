# download and unzip the dataset
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
file <- 'dataset.zip'
if (!file.exists(file)) download.file(url, file, method = 'curl')
unzip(file)
