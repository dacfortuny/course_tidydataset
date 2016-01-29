# 1 MERGING THE TRAINING AND THE TEST DATA SETS TO CREATE ONE DATA SET

# Folder names
mainFolder <- "UCI HAR Dataset"
trainFolder <- "train"
testFolder <- "test"

# Read the features data
featuresPath <- file.path(mainFolder,"features.txt")
features <- read.table(featuresPath)
features <- features[,2]

# Read subject data from train
subjectTrainPath <- file.path(mainFolder,trainFolder,"subject_train.txt")
subjectTrain <- read.table(subjectTrainPath)
names(subjectTrain) <- "subject"

# Read activity data from train
yTrainPath <- file.path(mainFolder,trainFolder,"y_train.txt")
yTrain <- read.table(yTrainPath)
names(yTrain) <- "activity"

# Read mean and std measurements from train
xTrainPath <- file.path(mainFolder,trainFolder,"X_train.txt")
xTrain <- read.table(xTrainPath)
names(xTrain) <- features

# Creating one data set for train
train <- cbind(subjectTrain,yTrain,xTrain)

# Read subject data from test
subjectTestPath <- file.path(mainFolder,testFolder,"subject_test.txt")
subjectTest <- read.table(subjectTestPath)
names(subjectTest) <- "subject"

# Read activity data from test
yTestPath <- file.path(mainFolder,testFolder,"y_test.txt")
yTest <- read.table(yTestPath)
names(yTest) <- "activity"

# Read mean and std measurements from test
xTestPath <- file.path(mainFolder,testFolder,"X_test.txt")
xTest <- read.table(xTestPath)
names(xTest) <- features

# Creating one data set for test
test <- cbind(subjectTest,yTest,xTest)

# Merging the train and test data sets
data <- rbind(train,test)


# 2 EXTRACTING ONLY THE MEASUREMENTS OF THE MEAN AND STANDARD DEVIATION

data <- data[,c(1,2,grep("mean\\(\\)|std\\(\\)",names(data)))]


# 3 NAMING THE ACTIVITIES IN THE DATA SET

activityLabelsPath <- file.path(mainFolder,"activity_labels.txt")
activityLabels <- read.table(activityLabelsPath)
activityLabels <- activityLabels[,2]
activityLabels <- tolower(activityLabels)
activityLabels <- sub("_"," ",activityLabels)

data$activity <- factor(data$activity,labels=activityLabels)


#4 LABELLING THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES

names(data) <- sub("^t","time",names(data))
names(data) <- sub("^f","frequency",names(data))
names(data) <- sub("Acc","Accelerometer",names(data))
names(data) <- sub("Gyro","Gyroscope",names(data))
names(data) <- sub("Mag","Magnitude",names(data))
names(data) <- sub("-mean\\(\\)-X","X.mean",names(data))
names(data) <- sub("-mean\\(\\)-Y","Y.mean",names(data))
names(data) <- sub("-mean\\(\\)-Z","Z.mean",names(data))
names(data) <- sub("-std\\(\\)-X","X.std",names(data))
names(data) <- sub("-std\\(\\)-Y","Y.std",names(data))
names(data) <- sub("-std\\(\\)-Z","Z.std",names(data))
names(data) <- sub("-mean\\(\\)",".mean",names(data))
names(data) <- sub("-std\\(\\)",".std",names(data))


#5 CREATING A NEW DATA SET WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND SUBJECT

library(dplyr)

data <- group_by(data,subject,activity)
dataSummary <- summarise_each(data, funs(mean))
names(dataSummary)[3:68] <- paste0(names(dataSummary)[3:68],".mean")
