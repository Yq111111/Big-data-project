channel<-dbConnect(MySQL(),user="root",password="yaoqisy884",dbname="bd",host="localhost")
star_review<-dbGetQuery(channel, "select stars,review_count from business where review_count>=2500;")
#sr_sample<-star_review[sample(nrow(star_review),15,replace = FALSE),]

ggplot(star_review,aes(x=stars,y=review_count,colour="red"))+
geom_point()+
  stat_smooth(method = lm)

star_review1<-dbGetQuery(channel, "select stars,review_count from business where review_count>=1000 and review_count<2500;")
ggplot(star_review1,aes(x=stars,y=review_count,col="yellow"))+
  geom_point()+
  stat_smooth(method = lm)