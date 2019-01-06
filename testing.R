
if(!require('MASS')){
  
  install.packages('MASS')
  
}

library('MASS')
if(!require('caret')){
  install.packages('caret')
}
library('caret')

library('tm')
if(!require('randomForest')){
  install.packages('randomForest')
  
}

library('randomForest')


if(!require('SnowballC')){
  install.packages('SnowballC')
}
library('SnowballC')

if(!require('tm')){
  
  install.packages('tm')
  
}

library('tm')

if(!require('quanteda')){
  install.packages('quanteda')
}
library('quanteda')

if (!require('wordcloud'))
{
  install.packages('wordcloud')
}
library('wordcloud')


getDTM <-function (col_name)
{
  print (col_name)
  sample.dataframe <- read.csv("zomato.csv",stringsAsFactors = F,header = T)
  #sample.dataframe[col_name] <- gsub(" City","_City",sample.dataframe[col_name])
  sampleCorpus <- Corpus(VectorSource(sample.dataframe[col_name]))
 
  return (sampleCorpus)   
}

X <-getDTM("City")

##insightsCleanUp <- function(){
dataZomato <- read.csv("zomato.csv",stringsAsFactors = F,header = T)
#head(dataZomato["Restaurant.ID"],5)
##taking features that matter
dataZomatoInsights <- dataZomato[,c(1,2,4,6,10,11,13:17,20:21)]
str(dataZomatoInsights)


#dataZomatoInsights[7:12] <- as.factor(dataZomatoInsights[7:12])
##PreProcessing For insights
dataZomatoInsights[,7] <- as.factor(dataZomatoInsights[,7])
dataZomatoInsights[,8] <- as.factor(dataZomatoInsights[,8])
dataZomatoInsights[,9] <- as.factor(dataZomatoInsights[,9])
dataZomatoInsights[,10] <- as.factor(dataZomatoInsights[,10])
dataZomatoInsights[,11] <- as.factor(dataZomatoInsights[,11])
dataZomatoInsights[,12] <- as.factor(dataZomatoInsights[,12])


dataZomato <- read.csv("zomato.csv",stringsAsFactors = F,header = T)
#head(dataZomato["Restaurant.ID"],5)
##taking features that matter
dataZomatoInsights <- dataZomato[,c(1,2,4,6,10,11,13:17,20:21)]
str(dataZomatoInsights)


#dataZomatoInsights[7:12] <- as.factor(dataZomatoInsights[7:12])
##PreProcessing For insights
dataZomatoInsights[,7] <- as.factor(dataZomatoInsights[,7])
dataZomatoInsights[,8] <- as.factor(dataZomatoInsights[,8])
dataZomatoInsights[,9] <- as.factor(dataZomatoInsights[,9])
dataZomatoInsights[,10] <- as.factor(dataZomatoInsights[,10])
dataZomatoInsights[,11] <- as.factor(dataZomatoInsights[,11])
dataZomatoInsights[,12] <- as.factor(dataZomatoInsights[,12])

borutoBank <-Boruta(dataZomatoInsights$Rating.text~.,data=dataZomatoInsights[,c(6:8,13,11)],doTrace=2)
x<-data.frame(borutoBank$finalDecision)
colnames(x) <- c("Important Feature Deision")
x['Features'] <- rownames(x)





dataofZomato <- read.csv("zomato.csv",stringsAsFactors = F,header = T)
dataforproc <- subset(dataofZomato[,c(1:2,4,11,20)],City %in% c("New_Delhi","Gurgaon","Noida")& Rating.text %in% c("Excellent","Very Good"))
dataforproc_good <- subset(dataforproc, City %in% c("New_Delhi","Gurgaon","Noida") & Rating.text %in% c("Excellent","Very Good") & Average.Cost.for.two <= 1000)

x <- dataforproc %>%
  group_by (City) %>%
  summarise(Num_Restaurants = n())

y <- dataforproc_good %>%
  group_by (City) %>%
  summarise(Num_Restaurants = n())

z <- as.data.frame(cbind(City=x$City , Tot=as.numeric(x$Num_Restaurants) , Goodones=as.numeric(y$Num_Restaurants)))










##}