require(xlsx)
data<-read.xlsx2("WordR.xlsx",sheetIndex=1)
data[grep("http://t",data$Row.Labels,ignore.case=T,invert=FALSE),]$Category="Stop"
StopWords<-read.csv("StopWords.csv",header=TRUE,stringsAsFactors=FALSE)
StopWords$StopWord=toupper(StopWords$StopWord)
RegX<-paste("\\b^",StopWords$StopWord,"$\\b",sep="")
data$Display.as<-gsub("[[:punct:]]", "", data$Display.as)

#----------------------------------------------------------------------------------

for (i in 1:length(RegX)){
  if (length(data[grep(RegX[i],data$Display.as,ignore.case=T,invert=FALSE),]$Category!=0))
  {
    data[grep(RegX[i],data$Display.as,ignore.case=T,invert=FALSE),]$Category="Stop"}
}

data[which(data$Category!="Stop"),]$Category="Regular"

dataCL<-data[data$Category!="Stop",]

#----------------------------------------------------------------------------------

dataCL$Count.Of.Tweet.ID<-as.numeric(as.character(dataCL$Count.Of.Tweet.ID))
dataCl2<-aggregate(dataCL$Count.Of.Tweet.ID, by=list(dataCL$Display.as),FUN=sum)

#----------------------------------------------------------------------------------

#save the csv file
write.xlsx2(data,file="Test.xlsx")
write.xlsx2(dataCl,file="Test1.xlsx")
