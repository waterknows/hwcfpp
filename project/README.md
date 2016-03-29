# Applying Data Mining to Reveal Media Bias

--A Comparison Between China Daily and The New York Times in the Discourse of Democracy (2013-2015)

## 1. Introduction

Media bias is the selection bias of news producers in deciding what and how stories are covered. According to Stefano Mario Rivolta, there are three types of media bias: gate keeping bias, coverage bias and statement bias. Based on this concise classification, this project is going to evaluate the differences and similarities of "democracy news" produced between 2013 and 2015 by two influential newspaper: the New York Times and the China Daily. 

## 2. Data Scraping

News are retrieved from the Newspapers' websites, with the following steps: 
1) Pull out search results with Keyword "democracy" between 2013-2015 by API (Nytimes) or web scrapping (China Daily);
2) Generate from the search results a list of links for specific news pages;
3) Loop through the links to get page htmls and parse them with the BeautifulSoup module;
4) Fetch the main bodies of the news and save them to individual text files under a common directory.
These procedures produce a [China Daily Corpus] (chinadaily) with 1472 news articles, and a [New York Times Corpus] (nytimes) with 2534 articles.   

## 3. Gate Keeping Bias

Definition: the tendency to cover certain issues but ignore others, also known as selection bias. 

### 3.1 General

Time plots of number of articles produced per month: 1) similarity = high correlation in ups and downs, suggesting that the intensities of coverage are similar between two newspapers; 2) difference: two peaks for the China Daily, but the second one is probably due to mismatching (for a political leader from National League for Democracy). 3.1 and 3.2 make use of the pattern that filenames are created with the "date+title" format.
[Graph: China Daily](GateKeeping1 _General_ChinaDaily.png); [The New York Times](GateKeeping1_General_Nytimes.png)

### 3.2 Country Specific

Time plots of number of democracy news related to {China, US and EU} produced per month: 1) similarity = China Daily covers more news about US than EU’s, and the New York Times covers more China news than EU’s, suggesting that both China and US seem to treat each other as a big audience in terms of democracy; 2) difference = China Daily covers more proportion of domestic democracy news, probably due to the "defense position" in the discourse of democracy. 
[Graph: China Daily](GateKeeping2_Country_ChinaDaily.png); [The New York Times](GateKeeping2_Country_Nytimes.png)

## 4. Coverage Bias

Definition: the preference for giving more airtime, space, or attention to some information in contrast to others within an issue.

### 4.1 Word Counts

Word counts (cdf) for all tokens in the text excluding stop words: 1) similarity = shape of the cumulative distribution curve; 2) difference = about 50% of the top 30 most common words are not the same, indicating a different focus in reporting and discussing democracy issues.
[Graph: China Daily](Coverage1_WordCounts_ChinaDaily.png); [The New York Times](Coverage1_WordCounts_Nytimes.png)

### 4.2 TF-IDF 

Term frequency normalized by document frequency: 1) similarity = words such as "government", "political" are used quite often in both texts; 2) difference = China Daily has a higher TF-IDF in general, suggesting that it is more focused on certain concepts; 3) difference = words such as "law", "development", "central" are frequently used only by China daily, mirroring the societal beliefs specific to China. IDF scores are trained from 1000 news articles randomly selected from NLTK movie review corpus.
[Graph: TF-IDF](Coverage2_tfidf.png)

## 5. Statement Bias

Definition: the tendency to interject journalists own opinions and attitudes into the text of coverage of issue.

### 5.1 Sentiment

To enable the program to "predict" the sentiment of a news article, we need to first train the program with some text data. Ideally, human readers should go through part of the two corpuses and rate the news as positive/negative, before which the computer can figure out the relationship between the presence of a word and the sentiment of an article conntaining this word with a Bayes model. For practicle reasons, however, the sentiment analysis here are performed by training the Naive Bayes Classifier with randomly selected 1000 reviews from the movie review corpus in NLTK. The [training result](Training_Result_Movie_Reviews_Corpus.png) is a dictionary of words-sentiment pairs. The out-of sample prediction accuracy with the rest of 1000 moview reviews is 80.9%. 

I then use this dictionary to predict the sentiment of articles in the two corpuses and calutlate the number of articles with positive/negative sentiment when the democracy news are related to {China, US, Europe} respectively: 1) similarity: news related to Europe have similar level of sentiment for both papers; 2) difference: comparatively speaking, democracy news related to China and US are associated with more negative tones when they are produced from China Daily, possibly mirroring China's ideology and foreign policy. Nytimes also has slight higher proportion of negative sentiment news in relation to China. 
[Graph: China Daily(up) vs The New York Times(down)](Statement1_Sentiment.png)   

### 5.2 Network

The case studied here is the 2014 Hong Kong protest/umbrella movement, which is a sit-in street protests from 26 Sep to 15 Dec 2014. A corpus is created for each agency (67 news from China Daily, 53 from Nytimes) with news covering this protest movement between Oct 1st to Oct 31th, 2014. Using Network X, there are mainly 5 steps to create the network graphs: 1) filter out stopwords in the texts; 2) tag words by Named Entity Recognition; 3) generate an edge connection if two nouns exist in the same sentence; 4) process these edges and create a words (nouns) connection map with NetworkX; 5) calculate centrality score based on how nouns phrases are related to each other in a corpus. 

Network graphs show how certain noun phrases are related within all the sentences of a corpus: 1) similarity: both corpus covers similar key words; 2) difference: there are significant differences in how the key words interact with each other. For China Daily, the central key noun (the biggest red circle) is "government", surrounded by words like "law", "economy", "disobedience", "society", "illegal" showing a "top-down perspective". On the other hand, the New York Times doesn't have this hierarchy--it has multiple central key words with equal importance such as "protestors", "students", "government", "police". Combining with words like "police", "communist", "think", "say", these words structure indicate a bottom-up perspective for political movements. 
[Graph: China Daily](Statement2_network_ChinaDaily.png); [The New York Times](Statement2_network_Nytimes.png)

Centrality scores can be used with further applications, such as generating a metric to measure texts similarity. And we can use text similarity to show if newspaper have developed its own writing style to report events.

## 6. Conclusion

Although news media are expected to be objective in how they cover events, in fact medias from different countries often develop their own version of the reality, among all three levels—selection, coverage and statement. And as a result, it is understandable that people nurtured within different public discourses can disagree with each other fundamentally. Among all the article genres, international political new can be extremely vulnerable toward media bias due to the lack of check and balance among stake holders. To avoid ethnocentrism and be a responsible citizen of the world we should be critical about the mass medias around us and listen to opinions from all sides.  

Note: Codes for section 2 can be viewed here: [China Daily](project-chinadaily.ipynb) and [The New York Times](project-nytimes.ipynb). Codes for section 3-5 can be viewed from [here](project-analysis.ipynb).
```python

```
