jennifer<-(review %>%
  filter(user_id =="CxDOIDnH8gp9KXzpBHJYXw"))
month<-format(jennifer$date,format="%m")
jennifer<-cbind(jennifer,month)

bruce<-(review %>%
  filter(user_id ==
           "hWDybu_KvYLSdEFzGrniTw"))
month<-format(bruce$date,format="%m")
bruce<-cbind(bruce,month)

together<-rbind(jennifer,bruce)

ggplot(together, aes(x=month,fill=user_id)) + 
  geom_histogram(stat="count",alpha=.5,position = "identity")+
  labs(title="Reviews of each month for Jennifer&Bruce")
  
  