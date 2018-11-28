res<-dbGetQuery(channel, "select year(yelping_since) as year, count(*)as freq from user group by year(yelping_since);")

temp<-ggplot(res,aes(x=year,y=freq,group=1))+
  geom_bar(stat='identity',col='black',fill='gray60')+
  geom_line(size=1.2)+
  labs(x="Year",y="# of new users",title="# of new register users per year")
temp