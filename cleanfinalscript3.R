library(dplyr)
library(tidyr)

#read in dataframes of txt files
activity <- read.table("cleaningfinal/UCI HAR Dataset/activity_labels.txt")
features <- read.table("cleaningfinal/UCI HAR Dataset/features.txt")
testx <- read.table("cleaningfinal/UCI HAR Dataset/test/X_test.txt")
testy <- read.table("cleaningfinal/UCI HAR Dataset/test/y_test.txt")
trainx <- read.table("cleaningfinal/UCI HAR Dataset/train/X_train.txt")
trainy <- read.table("cleaningfinal/UCI HAR Dataset/train/y_train.txt")
test_subject <- read.table("cleaningfinal/UCI HAR Dataset/test/subject_test.txt")
train_subject <- read.table("cleaningfinal/UCI HAR Dataset/train/subject_train.txt")

#convert dataframes into tables
activity <- tbl_df(activity)
features <- tbl_df(features)
testx <- tbl_df(testx)
testy <- tbl_df(testy)
trainx <- tbl_df(trainx)
trainy <- tbl_df(trainy)
test_subject <- tbl_df(test_subject)
train_subject <- tbl_df(train_subject)
                    
# find index of duplicated columns
names <- features$V2
dup_index <- which(duplicated(names))

#remove duplicated columns
utestx <- testx[,-dup_index]
utrainx <- trainx[,-dup_index]

#remove duplicated column names
unames <- names[-dup_index]

#add correct column names
names(utrainx) <- unames
names(utestx) <- unames

#add in trail type column
tutestx <- mutate(utestx, trail_type = "test")
tutrainx <- mutate(utrainx, trail_type = "train")

#remove unwanted tables
rm("utestx", utrainx)

#add subject vectors to data sets
vtest_subject <- test_subject$V1
stutestx <- mutate(tutestx, subject = vtest_subject)
vtrain_subject <- train_subject$V1
stutrainx <- mutate(tutrainx, subject = vtrain_subject)

#remove unwanted tables
rm("tutestx", "tutrainx")

#add activty vectors to data sets
vtrainy <- trainy$V1
vtesty <- testy$V1
astutestx <- mutate(stutestx, activity = vtesty)
astutrainx <- mutate(stutrainx, activity = vtrainy)

#remove unwanted tables
rm("stutestx", "stutrainx")

#change activty no.s into words
testactnames <-  case_when(
  astutestx$activity == 1 ~ "walking",
  astutestx$activity == 2 ~ "walking up stairs",
  astutestx$activity == 3 ~ "walking down stairs",
  astutestx$activity == 4 ~ "sitting",
  astutestx$activity == 5 ~ "standing",
  astutestx$activity == 6 ~ "laying"
  )
nastutestx <- mutate(astutestx, activity = testactnames)

trainactnames <- case_when(
astutrainx$activity == 1 ~ "walking",
astutrainx$activity == 2 ~ "walking up stairs",
astutrainx$activity == 3 ~ "walking down stairs",
astutrainx$activity == 4 ~ "sitting",
astutrainx$activity == 5 ~ "standing",
astutrainx$activity == 6 ~ "laying"
)
nastutrainx <- mutate(astutrainx, activity = trainactnames)

#remove unwanted tables
rm("astutestx", "astutrainx")

#unite test and trail set together
alldata <- rbind(nastutestx, nastutrainx)

#remove unwanted tables
rm("nastutestx", "nastutrainx", "activity", "features", "test_subject", "train_subject", "testx", "testy", "trainx", "trainy")

#now use grep to pull out columns with mean and SD ("mean()" and "std()"), along with added columns
index<- grep("\\bmean()\\b|\\bstd()\\b|\\bsubject\\b|\\bactivity\\b|\\btrail_type\\b", names(alldata))
subdata <- alldata[,index]

#now need average of each variable by subject and activity( returns NA for trail_type)
avdata <- subdata %>% group_by(subject, activity) %>% summarise_all(funs(mean))