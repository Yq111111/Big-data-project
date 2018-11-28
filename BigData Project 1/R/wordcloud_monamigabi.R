createWordCloud = function(train)
{
  train %>%
    unnest_tokens(word, text) %>%
    filter(!word %in% stop_words$word) %>%
    count(word,sort = TRUE) %>%
    ungroup()  %>%
    head(30) %>%
    
    with(wordcloud(word, n, max.words = 30,colors=brewer.pal(8, "Dark2")))
}

createWordCloud(review %>%
                  filter(business_id == "4JNXUYY8wbaaDmk3BPzlWw"))