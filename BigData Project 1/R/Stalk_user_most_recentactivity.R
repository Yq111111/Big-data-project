business<-dbGetQuery(channel, "select * from business;")
jennifer<-(review %>%
             filter(user_id ==
                      
                      "CxDOIDnH8gp9KXzpBHJYXw"))
recent_review<-head(jennifer[order(jennifer$date,decreasing = T),],20)
recentactivity<-(business%>%
                    filter(business$business_id %in% 
                      ((recent_review %>%
                      filter(user_id ==
                               "CxDOIDnH8gp9KXzpBHJYXw"))$business_id)
                    )
                )
recentactivity$latitude<-as.numeric(recentactivity$latitude)
recentactivity$longitude<-as.numeric(recentactivity$longitude)
center_lon = median(recentactivity$longitude,na.rm = TRUE)
center_lat = median(recentactivity$latitude,na.rm = TRUE)

leaflet(recentactivity) %>% addProviderTiles("Esri.NatGeoWorldMap") %>%
  addCircles(lng = ~longitude, lat = ~latitude,radius = 1)  %>%
  
  # controls
  setView(lng=center_lon, lat=center_lat,zoom = 10)