business<-dbGetQuery(channel, "select * from business;")
categories = str_split(str_replace_all(business$categories,"\r",""),";")
categories = as.data.frame(unlist(categories))
colnames(categories) = c("Name")

temp<-(categories %>%
  group_by(Name) %>%
  summarise(Count = n()) %>%
  arrange(desc(Count)) %>%
  ungroup() %>%
  mutate(Name = reorder(Name,Count)) %>%
  head(10))

  ggplot(temp,aes(x = "", y = Count, fill = Name)) + 
  geom_bar(stat = "identity",width=1) + 
  coord_polar(theta = "y")+ 
  theme(axis.text.x = element_blank()) +scale_fill_discrete( breaks=temp$Name,labels = paste( as.vector(temp$Name),"(", round(temp$Count/ sum(temp$Count) * 100, 2), "%)", sep = ""))+
  theme(panel.grid=element_blank())+
  labs(x="",y="",title="Top 10 most popular business")