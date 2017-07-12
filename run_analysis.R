library(plyr)
library(dplyr)

# Set your directory to match where the datasets are!
## Load data label data (feature and activity)
setwd("~/Getdata/Peer/UCI HAR Dataset")
feat <- read.table("features.txt")
act <- read.table("activity_labels.txt")

## Load test data
setwd("~/Getdata/Peer/UCI HAR Dataset/test")
subtest <- read.table("subject_test.txt")
xtest <- read.table("x_test.txt")
ytest <- read.table("y_test.txt")

## Load train data
setwd("~/Getdata/Peer/UCI HAR Dataset/train")
subtrain <- read.table("subject_train.txt")
xtrain <- read.table("x_train.txt")
ytrain <- read.table("y_train.txt")

# Collect and Clean data
#########################################################################################################
## Test Data
#########################################################################################################
### Make x-test data to have header column which corresponds to features data
#########################################################################################################

#### Create temp header for feature data
colnames(feat) <- c("IDF","value")

#### Transform x-test data and add temp column to match ID of feature data
xtesttrans  <- as.data.frame(t(xtest))          
xtesttrans  <- mutate(xtesttrans, ID = 1:561)       

#### Merge x-test data then remove temp header and column then transform it back              
xfeattest <- merge(feat,xtesttrans, by.x = "IDF", by.y = "ID") 
xfeattest$IDF <- NULL                               
xfeattest <- as.data.frame(t(xfeattest))

#### Make the header for the data and set the value of data frame as numeric to be able to calculate later
colnames(xfeattest) <- as.character(unlist(xfeattest[1,]))
xfeattest <- xfeattest[-1,]
xfeattest[] <- lapply(xfeattest, function(x) as.numeric(as.character(x)))

### Make subject data and their activity
#######################################################################################################
#### Create header to each for easy use
colnames(subtest) <- c("subjects")
colnames(ytest) <- c("actnumber")
colnames(act) <- c("actnumber","actnames")

#### Combine subject data and their activity number then relate it to activity names
subacttest <- cbind(subtest,ytest)
subactnamestest <- join(subacttest, act, by = "actnumber")

### Filter data to be only mean and std data then complete the test data
########################################################################################################
testtemp <- xfeattest[,grep("mean()|std()", names(xfeattest))]
testtemp <- testtemp[,-grep("meanFreq", names(testtemp), fixed = TRUE)]
test_data <- cbind(subactnamestest, testtemp)
########################################################################################################
#######################################################################################################

## Train data
#########################################################################################################
### Make x-train data to have header column which corresponds to features data
#########################################################################################################

#### Transform x-train data and add temp column to match ID of feature data (temp header for feature-
#### alredy declared previously)
xtraintrans  <- as.data.frame(t(xtrain))
xtraintrans  <- mutate(xtraintrans, ID = 1:561)

#### Merge x-train data then remove temp header and column then transform it back  
xfeattrain <- merge(feat,xtraintrans, by.x = "IDF", by.y = "ID")
xfeattrain$IDF <- NULL
xfeattrain <- as.data.frame(t(xfeattrain))

#### Make the header for the data and set the value of data frame as numeric to be able to calculate later
colnames(xfeattrain) <- as.character(unlist(xfeattrain[1,]))
xfeattrain <- xfeattrain[-1,]
xfeattrain[] <- lapply(xfeattrain, function(x) as.numeric(as.character(x)))

### Make subject data and their activity
#######################################################################################################
#### Create header to each for easy use
colnames(subtrain) <- c("subjects")
colnames(ytrain) <- c("actnumber")
colnames(act) <- c("actnumber","actnames")

#### Combine subject data and their activity number then relate it to activity names
subacttrain <- cbind(subtrain,ytrain)
subactnamestrain <- join(subacttrain, act, by = "actnumber")

### Filter data to be only mean and std data then complete the train data
########################################################################################################
traintemp <- xfeattrain[,grep("mean()|std()", names(xfeattrain))]
traintemp <- traintemp[,-grep("meanFreq", names(traintemp), fixed = TRUE)]
train_data <- cbind(subactnamestrain, traintemp)
########################################################################################################
########################################################################################################

# Make test and train data to be one datasets
########################################################################################################
alldata <- rbind(train_data,test_data)

# Create independent data for average of each activity
#######################################################################################################
activity_average <- alldata %>% group_by(actnames) %>% summarise_all(funs(if(is.numeric(.)) mean(., na.rm = TRUE) else first(.))) %>% select(-subjects, -actnumber)

# Create independent data for average of each subjects
#######################################################################################################
subjects_average <- alldata %>% group_by(subjects) %>% summarise_all(funs(if(is.numeric(.)) mean(., na.rm = TRUE) else first(.))) %>% select(-actnames, -actnumber)