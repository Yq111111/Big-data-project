channel<-dbConnect(MySQL(),user="qy508",password="qy508123",dbname="qy508",host="localhost")

res0<-dbGetQuery(channel, "select name,review_count as sum, useful,funny,cool,fans from user where user_id LIKE'%CxDOIDnH8gp9KXzpBHJYXw%' or user_id LIKE '%RtGqdDBvvBCjcu5dUqwfzA%' or user_id LIKE '%HFECrzYDpgbS5EmTBtj2zQ%' or user_id LIKE '%8k3aO-mPeyhbR5HUucA5aA%';")
res0 %>% 
     mutate(sum=sum/15000) %>%
     mutate( useful= useful/15000) %>%
     mutate( funny=funny/5000) %>%
     mutate(cool=cool/15000) %>%
     mutate(fans=fans/2000)%>%
    ggradar()
