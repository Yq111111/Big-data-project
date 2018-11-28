res<-dbGetQuery(channel, "select stars,count(*)as freq from business group by stars")
temp<-ggplot(res,aes(x=stars,y=freq,fill=stars))+ geom_bar(stat="identity",col='white')+ 
  geom_text(aes(label = freq, vjust = -0.3, hjust = 0.5))+
  labs(title="Business Stars Distribution")
show(temp)
