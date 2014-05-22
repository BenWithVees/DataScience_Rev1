news = load 'newsgroups.avro' using AvroStorage();
--describe news;

one_topic_per_article = foreach news generate *, flatten(TOKENIZE(newsgroups, ',')) as topic;

news_by_topic = group one_topic_per_article by topic;
article_counts = foreach news_by_topic generate group as topic, COUNT(one_topic_per_article) as articleCount, one_topic_per_article as article;
split article_counts into 
  keep if articleCount >= 100,
  discard if articleCount < 100;

topic_counts = foreach keep generate topic, articleCount;
dump topic_counts;
