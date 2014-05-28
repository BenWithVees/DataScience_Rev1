define kmeans `kmeans.py` ship ('kmeans.py');

news = load 'newsgroups.avro' using AvroStorage();

one_topic_per_article = foreach news generate *, flatten(TOKENIZE(newsgroups, ',')) as topic;

-- Only keep data for the top 100 topics
news_by_topic = group one_topic_per_article by topic;
article_counts = foreach news_by_topic generate group as topic, COUNT(one_topic_per_article) as articleCount, one_topic_per_article as articles;
split article_counts into 
  keep if articleCount >= 100,
  discard if articleCount < 100;

news_by_major_topic = foreach keep generate topic, flatten(articles.(articleId, content)) as (articleId, content);

grouped_content = group news_by_major_topic by topic parallel 10;
flattened_content = foreach grouped_content generate group as topic, flatten(news_by_major_topic.(articleId, content)) as (articleId, content);
cleaned_content = foreach flattened_content generate topic, articleId as articleId, REPLACE(REPLACE(REPLACE(content, '\\n', ' '), '\\r', ''), '\\t', ' ') as content;

filtered_content = filter cleaned_content by (TRIM(content) != '');
--a = limit filtered_content 1000;
--store a into 'test' using PigStorage('\t');
result = stream filtered_content through kmeans;
dump result;
