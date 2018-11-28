res<-dbGetQuery(channel, "select name,review_count from user order by review_count desc limit 10;")
res$name1 <- factor(res$name, levels=unique(res$name))
temp<-ggplot(res,aes(x=name1,y=review_count,fill=name1))+geom_bar(stat="identity",col='white')+geom_text(aes(label = review_count, vjust = -0.3, hjust = 0.5))+labs(x="User",y="# of Reviews",title="Top 10 Users with most reviews")
show(temp)