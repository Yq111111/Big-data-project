positiveWordsBarGraph <- function(SC) {
  contributions <- SC %>%
    unnest_tokens(word, text) %>%
    count(word,sort = TRUE) %>%
    ungroup() %>%
    
    inner_join(get_sentiments("afinn"), by = "word") %>%
    group_by(word) %>%
    summarize(occurences = n(),
              contribution = sum(score))
  
  contributions %>%
    top_n(20, abs(contribution)) %>%
    mutate(word = reorder(word, contribution)) %>%
    head(20) %>%
    ggplot(aes(word, contribution, fill = contribution > 0)) +
    geom_col(show.legend = FALSE) +
    coord_flip() + theme_bw()
}

positiveWordsBarGraph(review %>%
                        filter(user_id == "CxDOIDnH8gp9KXzpBHJYXw"))