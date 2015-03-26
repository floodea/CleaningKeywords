#Redundant stuff: for loops and some regular expressions. Sub out numeric 
#things and those with punctuation. Some of the redundant code here is useful so
#I'll keep it here




require(xlsx)
data<-read.xlsx2("WordR.xlsx",sheetIndex=1)

#Remove links and http://t.co
#Data1<-data[grep("http://t.co",data$Row.Labels,ignore.case=T,invert=TRUE),]

#Assign "Stop" to category variable for links like http://t.co..
data[grep("http://t.co",data$Row.Labels,ignore.case=T,invert=FALSE),]$Category="Stop"
head(data[grep("http://t.co",data$Row.Labels,ignore.case=T,invert=FALSE),])

#----------------------------------------------------------------------------------

#Assign stop words to all english "Stop" words, prepositions etc

StopWords<-read.csv("StopWords.csv",header=TRUE,stringsAsFactors=FALSE)

#Set stop words to upper case
StopWords$StopWord=toupper(StopWords$StopWord)










#add numbers to stopwords thing 1 to 1000 should do it
StopWords[346:1346,]<-1:1001


#Turn stopwords into regular expression thing using paste function.

RegX<-paste("\\b^",StopWords$StopWord,"$\\b",sep="")


#Get Stopwords with additional punctuation.
RegXPunct<-paste("\\b^",StopWords$StopWord,"$\\b",sep="")

#----------------------------------------------------------------------------------

#Need to deal with stop words that don't have a corresponding value in the Excel
#file. Length=0 divides them. Use a for loop to substitute for exact matches


#This now works. Huzaah!

for (i in 1:length(RegX)){
  if (length(data[grep(RegX[i],data$Display.as,ignore.case=T,invert=FALSE),]$Category!=0))
  {
  #data[data$Display.as==StopWords$StopWord[i],]$Category="Stop"
  data[grep(RegX[i],data$Display.as,ignore.case=T,invert=FALSE),]$Category="Stop"}
}

#----------------------------------------------------------------------------------
#perform the same treatment on the regular words as on the stop words
#for each of the words in the top 100, take the first character of the string and
#set it as a starting character. You can set the ending character as a series of
#punctuations etc.

#leave an example of just one so your poor little brain doesn't get too confused. 
#Then do a for-loop

data[,5]<-paste("\\b^",data$Row.Labels,"[./:,?!()]$\\b",sep="")
colnames(data[5])<-"Regular.Exp"
data[grep("\\b^marketing[./:,?!]$\\b",data$Row.Labels,ignore.case=T),]$Display.as="MARKETING"

dataCL<-data[data$Category!="Stop",]
dataCL$Display.as<-gsub("[[:punct:]]", "", dataCL$Display.as)

#----------------------------------------------------------------------------------
#The for loop is redundant now


for (i in 1:200)
  {
  if (length(dataCL[grep(dataCL$V5[i],dataCL$Row.Labels,ignore.case=T),]$Display.as!=0))
  {
dataCL[grep(dataCL$V5[i],dataCL$Row.Labels,ignore.case=T),]$Display.as
<-toupper(dataCL$Row.Labels[i])
}
}

#----------------------------------------------------------------------------------
#Aggregate that sucker
dataCL$Count.Of.Tweet.ID<-as.numeric(as.character(dataCL$Count.Of.Tweet.ID))
dataCl2<-aggregate(dataCL$Count.Of.Tweet.ID, by=list(dataCL$Display.as),FUN=sum)

#----------------------------------------------------------------------------------

#save the csv file
#write.xlsx2(data,file="Test1.xlsx")
write.xlsx2(dataCl2,file="Test1.xlsx")
