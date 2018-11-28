res<-dbGetQuery(channel, "select review_count,count(*)as freq from user where review_count<50 group by review_count;")
row<-dbGetQuery(channel, "select 50 as review_count,count(*) as freq from user where review_count>=50;")
res1<-rbind(res,row)
res2 <- res1 %>% mutate(f=freq/sum(freq))
ggplot(res2,aes(x=review_count,y=f))+
  geom_bar(stat='identity',width = 0.5,col="black",fill="white")+
  scale_y_continuous(labels = scales::percent)+
  labs(x="# of reviews",y="Percent")