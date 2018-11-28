res<-dbGetQuery(channel, "select business_name,review_count from business order by review_count desc limit 10;")
res$business_name1 <- factor(res$business_name, levels=unique(res$business_name))
temp<-ggplot(res,aes(x=business_name1,y=review_count,fill=business_name1))+ 
geom_bar(stat="identity",col='white')+ 
geom_text(aes(label = review_count, vjust = -0.1, hjust = 0.2))+
labs(x="Business name",title="Top 10 business with most reviews",legend.title=element_blank())+
coord_flip()+
theme_bw()
show(temp)