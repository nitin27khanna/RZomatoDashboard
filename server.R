if(!require (shiny))
{  install.packages("shiny")
}

library(shiny)

if(!require (ggplot2))
{  install.packages("ggplot2")
}
library("ggplot2")
if(!require (grid))
{  install.packages("grid")
}
library("grid")
if(!require (gridBase))
{  install.packages("gridBase")
}
library("gridBase")


if(!require(shinydashboard))
{
  install.packages("shinydashboard")
}

if(!require(ggplot2))
{
  install.packages("ggplot2")
}

library(ggplot2)

library(shinydashboard)

if(!require(wordcloud))
{
  install.packages("wordcloud")
}
library(wordcloud)

if(!require(tm))
{
  install.packages("tm")
}
library(tm)

library( dplyr )

if (!require("forcats")){
install.packages("forcats")
}
library("forcats")
#Function to get Corpus Object to plot word Clouds

getDTM <-function (col_name)
{
  ##print (col_name)
  sample.dataframe <- read.csv("zomato.csv",stringsAsFactors = F,header = T)
  #sample.dataframe[col_name] <- gsub(" City","_City",sample.dataframe[col_name])
  sampleCorpus <- Corpus(VectorSource(sample.dataframe[col_name]))
  
  return (sampleCorpus)   
}

#function to get term matrix to plot frequency graphs

gettm <-function(col_name)
{
  sample.dataframe <- read.csv("zomato.csv",stringsAsFactors = F,header = T)
  
  cuisinesCorpus <- Corpus(VectorSource(sample.dataframe[col_name])) 
  dtm <- TermDocumentMatrix(cuisinesCorpus)
  m <- as.matrix(dtm)
  v <- sort(rowSums(m),decreasing=T)
  d <- data.frame(word = names(v) ,freq = v )
 # str(d)
  return ((d))
}

importanceMatrix <- function()
{
  dataZomato <- read.csv("zomato.csv",stringsAsFactors = F,header = T)
  #head(dataZomato["Restaurant.ID"],5)
  ##taking features that matter
  dataZomatoInsights <- dataZomato[,c(1,2,4,6,10,11,13:17,20:21)]
  
  
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
  return (x)
  }

#relate online vs non-online resturants with ratings
getratingOnline <- function()
{
  dataZomato <- read.csv("zomato.csv",stringsAsFactors = F,header = T)
  #head(dataZomato["Restaurant.ID"],5)
  ##taking features that matter
  dataZomatoInsights <- dataZomato[,c(1,2,4,6,10,11,13:17,20:21)]
  str(dataZomatoInsights)
  dataZomatoInsightsOnl <- subset(dataZomatoInsights, City %in% c("New_Delhi","Noida" , "Gurgaon") & Rating.text %in% c("Excellent","Very Good"))
  
  ##group by operation on online delivery and City
  x <- dataZomatoInsightsOnl %>%
        group_by (City,Has.Online.delivery) %>%
        summarise(Num_Restaurants = n()) %>%
        mutate(freq = Num_Restaurants/ sum(Num_Restaurants))
  
  return (as.data.frame(x))
  }


getValMny <- function() {
  dataofZomato <- read.csv("zomato.csv",stringsAsFactors = F,header = T)
  dataforproc <- subset(dataofZomato[,c(1:2,4,11,20)],City %in% c("New_Delhi","Gurgaon","Noida")& Rating.text %in% c("Excellent","Very Good"))
  dataforproc_good <- subset(dataforproc, City %in% c("New_Delhi","Gurgaon","Noida") & Rating.text %in% c("Excellent","Very Good") & Average.Cost.for.two <= 1000)
  
  x <- dataforproc %>%
    group_by (City) %>%
    summarise(Num_Restaurants = n())
  
  y <- dataforproc_good %>%
    group_by (City) %>%
    summarise(Num_Restaurants = n())
  
  z <- as.data.frame(cbind(City=x$City , TotalOutlets=as.numeric(x$Num_Restaurants) , ValueForMoney=as.numeric(y$Num_Restaurants)))
  
  return (z)
}

shinyServer(function(input, output, session){
  wordcloud_rep <- repeatable(wordcloud)
  output$plot1 <- renderPlot({
    
    wordcloud_rep(getDTM("City"),random.order = F, scale=c(3,1),
                  min.freq = 20, max.words=80,
                  colors=brewer.pal(8, "Dark2"))
  })
  
  output$plot2 <- renderPlot({
    
    wordcloud_rep(getDTM("Cuisines"),random.order = F, scale=c(3,1),
                  min.freq = 15, max.words=90,
                  colors=brewer.pal(8, "Dark2"))
  })
  
  output$plot3 <- renderPlot({
    
    d <- subset(gettm("Cuisines"), freq>=150)
    d %>%
      ggplot( aes(x=word, y=freq)) +
      geom_bar(stat="identity") + xlab("Cuisines") + ylab("Number of Outets") + labs(title= "Cuisines v/s Outlets") +
      coord_flip()
    
  })
  
  output$table1 <- renderTable(importanceMatrix(),bordered=T)
  
  output$table2 <- renderTable (getratingOnline(),bordered=T)
  
  output$table3 <- renderTable(getValMny(),bordered = T)
  
  output$plot4 <- renderPlot({
    z <- getValMny()
    
    z1 <-z[z$City=="New_Delhi",]
    z1[2] <- as.numeric(as.character(z1[,2]))
    z1[3] <- as.numeric(as.character(z1[,3]))
    z1['val']<- z1[3]/z1[2]
    
    z2 <-z[z$City=="Noida",]
    z2[2] <- as.numeric(as.character(z2[,2]))
    z2[3] <- as.numeric(as.character(z2[,3]))
    z2['val']<- z2[3]/z2[2]
    
    
    z3 <-z[z$City=="Gurgaon",]
    z3[2] <- as.numeric(as.character(z3[,2]))
    z3[3] <- as.numeric(as.character(z3[,3]))
    z3['val']<- z3[3]/z3[2]
    
    z1[2:3] <- NULL
    z2[2:3] <- NULL
    z3[2:3] <- NULL
    
    lbl <- c("NotSoGood","ValueForMoney")
    
    par(mfrow=c(1,3) ) # 1 row and 3 columns for plots
    pie(c(1-z1$val,z1$val), labels=lbl,col = c("purple", "violetred1", "green3","cornsilk", "cyan", "white"), xlab="New Delhi")
    pie(c(1-z2$val,z2$val) ,labels=lbl,col = c("purple", "violetred1", "green3","cornsilk", "cyan", "white"), xlab="Noida")
    mtext(side=3, text="Value for money Outlets in NCT")
    pie(c(1-z2$val,z3$val), labels=lbl,col = c("purple", "violetred1", "green3","cornsilk", "cyan", "white"), xlab="Gurugram")
  })
  
}
)

