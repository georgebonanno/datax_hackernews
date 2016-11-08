# datax_hackernews

hacker_news.R: An r implementation that samples the articles every 5 seconds. The ordering for each sample 
is stored in a csv file. In every sample, the actual article is cached to disk unless it was cached in previous samples.

hacker_new_data_extraction.R: The ordering of a every article at a given sample are loaded from a csv file in the 
format outputted from hacker_new_data_extraction.R. This information is used to ploy an x-y scatter 
(the plotOrderingsOfAll function) that shows the ordering of all articles across the sampling period. A bargraph 
that displays the amount of times that articles feature in a given order can be generated using the 'barplotForOrdering' function.
