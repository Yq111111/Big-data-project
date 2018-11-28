channel<-dbConnect(MySQL(),user="qy508",password="qy508123",dbname="qy508",host="localhost")
res1<-dbGetQuery(channel, "select latitude,longitude from business where city='Toronto' and stars>=4.5 and categories LIKE '%restaurant%';")
res1$latitude<-as.numeric(res1$latitude)
res1$longitude<-as.numeric(res1$longitude)
center_lon = median(res1$longitude,na.rm = TRUE)
center_lat = median(res1$latitude,na.rm = TRUE)

leaflet(res1) %>% addProviderTiles("Esri.NatGeoWorldMap") %>%
  addCircles(lng = ~longitude, lat = ~latitude,radius = 1)  %>%
  
  # controls
  setView(lng=center_lon, lat=center_lat,zoom = 12)
