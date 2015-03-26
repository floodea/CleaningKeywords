require(xlsx)
data<-read.xlsx2("WordR.xlsx",sheetIndex=1)

#Assign "Stop" to category variable for links like http://t.co..
data[grep("http://t",data$Row.Labels,ignore.case=T,invert=FALSE),]$Category="Stop"

#----------------------------------------------------------------------------------

#Assign stop words to all english "Stop" words, prepositions etc

StopWords<-read.csv("StopWords.csv",header=TRUE,stringsAsFactors=FALSE)

#Set stop words to upper case
StopWords$StopWord=toupper(StopWords$StopWord)

#Define start and end of words

RegX<-paste("\\b^",StopWords$StopWord,"$\\b",sep="")

#Remove punctuation from words in Display as variable. Can do the same with numbers
#if needed

data$Display.as<-gsub("[[:punct:]]", "", data$Display.as)

#----------------------------------------------------------------------------------

#Need to deal with stop words that don't have a corresponding value in the Excel
#file. Length=0 divides them. Use a for loop to substitute for exact matches.
#This now works. Huzaah!

for (i in 1:length(RegX)){
  if (length(data[grep(RegX[i],data$Display.as,ignore.case=T,invert=FALSE),]$Category!=0))
  {
  #data[data$Display.as==StopWords$StopWord[i],]$Category="Stop"
  data[grep(RegX[i],data$Display.as,ignore.case=T,invert=FALSE),]$Category="Stop"}
}

data[which(data$Category!="Stop"),]$Category="Regular"

#----------------------------------------------------------------------------------
#Again, this part has been changed, The punctuation has been removed already.

#leave an example of just one so your poor little brain doesn't get too confused. 
#Then do a for-loop

dataCL<-data[data$Category!="Stop",]

#Aggregate that sucker
#dataCL$Count.Of.Tweet.ID<-as.numeric(as.character(dataCL$Count.Of.Tweet.ID))
#dataCl2<-aggregate(dataCL$Count.Of.Tweet.ID, by=list(dataCL$Display.as),FUN=sum)

#----------------------------------------------------------------------------------

#save the csv file
#write.xlsx2(data,file="Test.xlsx")
write.xlsx2(dataCL,file="TestCL.xlsx")
