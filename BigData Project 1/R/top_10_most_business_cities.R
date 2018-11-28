res<-dbGetQuery(channel, "select city,count(*)as freq from business group by city Order by freq desc limit 10")
res$city1 <- factor(res$city, levels=unique(res$city))
temp<-ggplot(res,aes(x=city1,y=freq,fill=city1))+ geom_bar(stat="identity",col='white')+ geom_text(aes(label = freq, vjust = -0.3, hjust = 0.5))+labs(x="City",title="Top 10 most business cities")
show(temp)