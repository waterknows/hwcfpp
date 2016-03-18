
# Applying Data Mining to Reveal Media Bias

--A Comparison Between China Daily and The New York Times in the Discourse of Democracy (2013-2015)

## 1. Introduction

Media bias is the selection bias of news producers in deciding what and how stories are covered. According to Stefano Mario Rivolta, there are three types of media bias: gate keeping bias, coverage bias and statement bias. Based on this concise classification, this project is going to evaluate the differences and similarities of "democracy news" produced between 2013 and 2015 by two influential newspaper: the New York Times and the China Daily. 

## 2. Data Scraping

News are retrived from the Newspapers' websites, with the following steps: 
1) Pull out search results with Keyword "democracy" between 2013-2015 by API (Nytimes) or web scrapping (China Daily);
2) Generate from the search results a list of links for specific news pages;
3) Loop through the links to get page htmls and parse them with the BeautifulSoup;
4) Fetch the main body of the news and write them to indivdual txt files in a common directory.
These procedures produce a "China Daily Corpus" with 1472 news articles, and a "New York Times Corpus" with 2534 articles.   

## 3. Gate Keeping

### 3.1 General

Time plots of number of articles produced per month: 1) similarity = high correlation in ups and downs, suggesting little gate keeping bias; 2) difference: two peaks for the China Daily, but the second one is probably due to mis-matching (for a political leader from National League for Democracy). 3.1 and 3.2 make use of the pattern that filenames are created with the "date+title" format.
[China Daily](GateKeeping1 _General_ChinaDaily.png)
[The New York Times]; (GateKeeping1_General_Nytimes.png)

### 3.2 Country Specific

Time plots of number of democracy news related to {China, US and EU} produced per month: 1) similarity = both newspapers seem to treat the other as a big audiance; 2) difference = China Daily covers more proportion of domestic news, probabaly due to the "defense poistion" in the discourse of democracy. 
[China Daily](GateKeeping2 _Country_ChinaDaily.png); [The New York Times](GateKeeping2_Country_Nytimes.png)

## 4. Coverage

### 4.1 Word Counts

Word counts (cdf) for all tokens in the text excluding stopwords: 1) similarity = shape of the cumulative distribution curve; 2) difference = about 50% of the top 30 most common words are not the same, indicating a different focus in reporting and discussing democracy issues
[China Daily](Coverage1_WordCounts_ChinaDaily.png); [The New York Times](Coverage1_WordCounts_Nytimes.png)

### 4.2 TF-IDF 

Term frequency normalized by document frequency: 1) similarity = words such as "government", "political" are used quite often in both texts; 2) difference = China Daily has a higher TF-IDF in general, suggesting that it is more focused on certain concepts; 3) difference = words such as "law", "development", "central" are frequently used only by China daily, mirroing the soceital belifs specific to China. IDF scores are trained from 1000 news articles randomly selected from NLTK.movie review corpus.
[China Daily](Coverage2_tfidf.png)

## 5. Statement

### 5.1 Sentiment

The number of articles with Positive/Negative sentiment when the new is related to {China, US, Europe}: 1) similarty: news related to europe have similar level of sentiment for both papers; 2) difference: compartively speaking, democracy news related to China and US are associated with more negative tones when they are produced from China Daily, possibly mirroing China's ideology and foreign policy. Nytimes also has slight higher proportion of negative sentiment news in realtion to China. The sentiment score are calculated by training the Nayes Bayes Classifier with movie_review corpus from NLTK.  
[China Daily(up) vs The New York Times(down)](Statement1_Sentiment.png)

### 5.2 Network

Network graphs of how certain words (nouns/adjs) are related within all the sentences of a corpus: 1) similarity: both corpus covers similar key words; 2) difference: there are significant differences in how the key words interact with each other. For China Daily, the central key noun (the biggest red circle) is "govenrment", surrounded by words like "law", "economy", "disobedienc", "society", "illegal" showing a "top-down perspective". On the other hand, the New York Times doesn't have this hierarchy--it has multiple central key words with equal importance such as "protestors", "students", "government", "police". Combining with words like "police", "communist", "think", "say", these words structure indicate a bottom-up perspective for political movements. 
[China Daily](Statement2_network_ChinaDaily.png); [The New York Times](Statement2_network_Nytimes.png)

Notes on the network:
The case studied here is the 2014 Hong Kong protest/umbrella movement, which is a sit-in street protests from 26 Sep to 15 Dec 2014. The dataset is comparised of related news in Oct 1st-31th, 2014 (67 news from China Daily, 53 from Nytimes). Using Network X, there are mainly 5 steps to create the network graph: 1) filter words from sentences; 2) tag words by Named Entity Recognition; 3) pull out nouns/adjs relation within each sentence; 4) generate edges with NetworkX; 5) output centrality score. Centrality scores can be used wit further applications, such as generating a metric to measure texts similarity. And we can use text similarity to show if newspaper have developed its own writing style to report events.

# 6. Conclusion

All in all, we can see that although both China Daily and the New York Times covers similar phenomena, the way they cover and interpret the facts can be dramatically diffrenet. And among all the article genres, international political new can be extremely volunarabl toward bias probably due to the lack of check and balance internationally. Just like people, news media are not free from bias. Although it is sometimes more comfortable to stay in one's own center of the world, as a responsible citizen of the world we should be critical about the information around us and be open to opinions from different sides.  


Note: For section 2, please refer to codes in [China Daily](project-chinadaily.ipynb) and [The New York Times](project-nytimes.ipynb). For Graph: The New York Times](Statement2_network_Nytimes.png) and project-nytimes.ipynb; the analysis parts section 3-5 are covered in [here](project-analysis.ipynb).
```python

```
