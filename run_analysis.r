setwd("./UCI HAR Dataset")
train1<-read.table("./train/X_train.txt")
train2<-read.table("./train/subject_train.txt")
train3<-read.table("./train/y_train.txt")
train_data<-cbind(train1,train2)
train_data<-cbind(train_data,train3)

test1<-read.table("./test/X_test.txt")
test2<-read.table("./test/subject_test.txt")
test3<-read.table("./test/y_test.txt")
test_data<-cbind(test1,test2)
test_data<-cbind(test_data,test3)

#Merge the training data and test data together
all_data<-rbind(train_data,test_data)

#Extracts only the measurements on the mean and standard deviation for each measurement. 
#the number of column should be extracted
col_index<-c(1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,122,123,124,125,126,201,202,214,215,228,229,240,241,253,254,266,267,268,269,270,271,345,346,347,348,349,350,424,425,426,427,428,429,503,504,516,517,529,530,542,543,562,563)
data<-all_data[,col_index]

#Uses descriptive activity names to name the activities in the data set
activity_names<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
for (i in seq_along(activity_names))
{ 
  x<-data$V1.2==i
  data$V1.2[x]<-activity_names[i]
}

#Appropriately labels the data set with descriptive variable names. 
feature_names<-read.table("features.txt")
descriptive_names<-feature_names[,2][col_index]
#the total length of descriptive names is 62
descriptive_names<-as.character(descriptive_names)
descriptive_names[61]<-"subject"
descriptive_names[62]<-"activity"
names(data)<-descriptive_names

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
c<-rep('',180)  #30 subject * 6 activity
tidy_data<-data.frame(c)
for (i in 1:60)
{
  frame<-aggregate(data[,i]~data$subject+data$activity,data,mean)  #combine by two factors
  tidy_data<-cbind(tidy_data,frame[,3])
}
tidy_data<-cbind(tidy_data,frame[,1:2])
tidy_data<-tidy_data[,2:63]
names(tidy_data)<-descriptive_names

write.table(tidy_data,file="tidydata.txt",row.name=FALSE)
                    
