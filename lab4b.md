---
title: "Lab 4b: Mapping Twitter Data"
subtitle: <h4 style="font-style:normal">CRD 230 - Spatial Methods in Community Research</h4>
author: <h4 style="font-style:normal">Professor Noli Brazil</h4>
date: <h4 style="font-style:normal">January 28, 2021</h4>
output: 
  html_document:
    toc: true
    toc_depth: 3
    toc_float: true
    theme: cosmo
    code_folding: show
---



<style>
p.comment {
background-color: #bdced6;
padding: 10px;
border: 0px solid black;
margin-left: 25px;
border-radius: 5px;
font-style: normal;
}

h1.title {
  font-weight: bold;
  font-family: Arial;  
}

h2.title {
  font-family: Arial;  
}

</style>


<style type="text/css">
#TOC {
  font-size: 13px;
  font-family: Arial;
}
</style>


\





In this lab you will learn how to bring in, clean, analyze and map social media data accessed from Twitter in R. You will use the Twitter [RESTful API](https://developer.twitter.com/en/docs/api-reference-index) to access data about both twitter users and what they are tweeting about.  The objectives of this guide are

1. Learn how to sign up for a Twitter developer account
2. Learn how bring in Twitter user and tweet data using Twitter's API
3. Learn how to map Twitter user locations and geotagged tweets

To achieve these objectives, we will bring in and map tweets containing the words "biden" and "trump".


<div style="margin-bottom:25px;">
</div>
## **Installing and loading packages**
\

You'll need to install the following packages in R.  You only need to do this once, so if you've already installed these packages, skip the code.  Also, don't put these `install.packages()` in your R Markdown document.  Copy and paste the code in the R Console.


```r
install.packages("rtweet")
install.packages("tidytext")
```

You'll need to load the following packages.  Unlike installing, you will *always* need to load packages whenever you start a new R session. You'll also always need to use `library()` in your R Markdown file.


```r
library(tidyverse)
library(sf)
library(leaflet)
library(tigris)
library(rtweet)
library(tidytext)
```



<div style="margin-bottom:25px;">
</div>
## **Read in census geography**
\

We will be mapping tweet locations within the Los Angeles metropolitan area. As such, we'll need to bring its boundaries into R using the function `core_based_statistical_areas()`, which we learned about in [Lab 3](https://crd230.github.io/lab3.html#tigris_package).  


```r
cb <- core_based_statistical_areas(year = 2018, cb = TRUE)

la.metro <- filter(cb, grepl("Los Angeles", NAME))
```

<div style="margin-bottom:25px;">
</div>
## **Signing up for a Twitter API**
\

Signing up for a Census API was fairly easy and required only an email address.  Signing up for a Twitter API is a little more comprehensive.  Below are the steps.

1. Set up a twitter account if you don’t have one already.

2. Using your account, apply for a developer account [here](https://developer.twitter.com/en).

3. On the developer account splash page, click on "Apply" and then "Apply for a developer account"

4. The next screen asks you to describe yourself. I chose "Academic" and then "Academic researcher." Click on "Get Started."

5. You will then need to add a valid phone number if you did not supply one when you signed up for Twitter.  You will need to give the verification code that will be sent to your phone. Fill out the rest of the page and click Next.

6. The next page will ask you to fill out several text boxes on how you will use the Twitter API for Twitter Data.  
* For the first text box, your response will need to be a minimum of 200 characters. Make sure you provide a thorough response (e.g. mention you are using it for a graduate class you are taking.  You can also provide the link to the site).  
* The next text box asks you to describe how you will analyze Twitter data including any analysis of Tweets or Twitter users (you can say something like you will be making bar graphs and maps of tweets containing certain keywords). 
* The third text box asks you whether you will use Tweet, Retweet, Like, Follow or Direct Message functionality. I would make this option No.
* The next text box asks you to describe how and where Tweets and/or data about Twitter content will be displayed outside of Twitter. I recommend writing that you will be presenting Tweet data in lab and homework assignments.  Of course, these are just my suggestions.  If you plan on using tweet data for your final project or research outside of this class, please include that information.
* The final text box asks you to list all government entities you intend to provide Twitter content or derived information to under this use case.  I recommend selecting the No option.  Click Next to move on.

7. The next screen asks you to review all the information you provided.  Once you've done so, click Next.

8. The final screen asks you to read the developer agreement and policy.  Click on the box located at the bottom of the agreement.  Click on submit application.

9. You'll get an email approving your application.  If you were not approved, you will get an email asking you to fill out more information.  The process of getting approval should not take too long.  For example, I was approved within an hour.

10. Once you have acquired a developer account, you next need to create an app. Navigate to [http://developer.twitter.com/en/apps](http://developer.twitter.com/en/apps), click the blue button that says "Create a New App", and then complete the form. App Name is what your app will be called. Click on "Complete".

11.  Make sure you save or write down the Application API key (also known as the Consumer Key) and Application API secret key (also known as the API secret). 

12. You will also need to write down or save the Access token and Access secret. To get these, you can navigate to your newly created app under the *Project & Apps* header on the left panel.  Click on "Keys and tokens" The access token and secret are located at the bottom of the page.

<div style="margin-bottom:25px;">
</div>
## **Authenticating your Twitter API**
\

We'll be using the R package **rtweet** to access tweet data from Twitter. The first thing you need to establish is your authentication.  When you set up your app in Twitter, you were provided 5 unique identification elements:

* App name
* API key
* API secret key
* Access token
* Access secret token

You feed these items into the function `create_token()` to get authenticated.


```r
# whatever name you assigned to your created app.  Mine is crd230
appname <- "crd230"

## api key 
key <- "INSERT YOUR KEY HERE"

## api secret 
secret <- "INSERT YOUR SECRET KEY HERE"

access_token <- "INSERT YOUR ACCESS TOKEN HERE"

access_secret <- "INSERT YOUR SECRET TOKEN HERE"

twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret,
  access_token = access_token,
  access_secret = access_secret)
```





<div style="margin-bottom:25px;">
</div>
## **Loading in Tweets**
\

To send a request for tweets to Twitter's API use the function `search_tweets()`.  Let's collect the 8,000 most recent tweets that contain the word "biden".


```r
biden_tweets <- search_tweets(q="biden", n = 8000,
                               include_rts = FALSE, lang = "en",
                             geocode = lookup_coords("usa"))
```

The argument `q =` specifies the words you want to search for in quotes.  You can search for multiple words by using "AND" or "OR."  For example, to search for tweets with the words "biden" or "kamala", use `q = "biden OR kamala`.  To search for tweets that contain both "biden" and "kamala", use `q = "biden AND kamala"`. 

The argument `n =` specifies the number of tweets you want to bring in. Twitter rate limits cap the number of search results returned to 18,000 every 15 minutes. To request more than that, simply set `retryonratelimit = TRUE` and **rtweet** will wait for rate limit resets for you. However, don't go overboard.  Bringing in, say, 50,000+ tweets may requires multiple hours if not days to complete.

The argument `include_rts = FALSE` excludes retweets. The argument `lang = "en"` collects tweets in the English language.  The argument `geocode = lookup_coords("usa")` collects tweets sent from the United States.  Take a look at the data.


```r
glimpse(biden_tweets)
```

Note that the Twitter API returns data from only the past 6-9 days.  

Let's collect tweets containing the word "trump".


```r
trump_tweets <- search_tweets(q="trump", n = 8000,
                              include_rts = FALSE, lang = "en",
                              geocode = lookup_coords("usa"))
```

Check the data.


```r
glimpse(trump_tweets)
```


<div style="margin-bottom:25px;">
</div>
## **Visualizing Tweet Locations**
\

The data set contains 90 variables.  These variables include the user (handle and name) who sent the tweet, the tweet text itself, hashtags used in the tweet, how many times the tweet has been retweeted, and much much more. See [here](https://developer.twitter.com/en/docs/twitter-api/v1/data-dictionary/object-model/tweet) for the data dictionary.

We're interested in determining where these tweets are coming from. There are four sources of geographic information.  First, you have geographic information embedded within the tweet itself.  You can use `search_tweets()` to find all tweets that refer to a specific place (e.g. a city such as "los angeles" or a neighborhood such as Sacramento's "oak park").  

Second, the user sets a place with a name such as "Los Angeles" in their tweet.  In other words, the user tweets something and adds a place to where this tweet is being tweeted from.  The variable containing the tweet place is *place_full_name*.  How many unique places are captured by tweets containing the word "biden"?


```r
length(unique(biden_tweets$place_full_name))
```

```
## [1] 198
```

We can create a table of the top 10 places tweeting about biden using the following code.  The code `is.na(place_full_name) == FALSE & place_full_name != ""` within `filter()` keeps tweets without NA and blank place names.  The function `top_n()` only keeps the top 10 places by count.


```r
biden_tweets %>% 
  filter(is.na(place_full_name) == FALSE & place_full_name != "") %>% 
  count(place_full_name, sort = TRUE) %>% 
  slice(1:10)
```

```
## # A tibble: 10 x 2
##    place_full_name         n
##    <chr>               <int>
##  1 Florida, USA           11
##  2 Manhattan, NY           8
##  3 Atlanta, GA             5
##  4 Los Angeles, CA         5
##  5 North Carolina, USA     5
##  6 Georgia, USA            4
##  7 Green Knoll, NJ         4
##  8 Virginia, USA           4
##  9 Wisconsin, USA          4
## 10 Austin, TX              3
```

We can visualize this distribution using our best bud `ggplot()`


```r
biden_tweets %>%
  count(place_full_name, sort = TRUE) %>%
  mutate(location = reorder(place_full_name,n)) %>%
  na.omit() %>%
  top_n(10) %>%
  ggplot(aes(x = location,y = n)) +
  geom_col() +
  coord_flip() +
  labs(x = "Place",
       y = "Count",
       title = "Biden Tweets - unique locations ")
```

![](lab4b_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

What about "trump"?


```r
trump_tweets %>%
  count(place_full_name, sort = TRUE) %>%
  mutate(location = reorder(place_full_name,n)) %>%
  na.omit() %>%
  top_n(10) %>%
  ggplot(aes(x = location,y = n)) +
  geom_col() +
  coord_flip() +
  labs(x = "Place",
       y = "Count",
       title = "Trump Tweets - unique locations ")
```

![](lab4b_files/figure-html/unnamed-chunk-13-1.png)<!-- -->


<div style="margin-bottom:25px;">
</div>
## **Extracting Tweet Geographic Coordinates**
\

The third source for geographic information is the geotagged precise location point coordinates of where the tweet was tweeted. To extract the longitudes and latitudes of the tweet locations use the function `lat_lng()`.


```r
biden_tweets <- lat_lng(biden_tweets)
```

The function creates two new columns in the data set, *lat* and *lng*, which represent the latitude and longitude coordinates, respectively.

Not all tweets are geotagged.  Let's keep the tweets with lat/long info using the `filter()` command.


```r
biden_tweets.geo <- biden_tweets %>%
                    filter(is.na(lat) == FALSE & is.na(lng) == FALSE)
```

Let's do the same for *trump_tweets*


```r
trump_tweets <- lat_lng(trump_tweets)

trump_tweets.geo <- trump_tweets %>%
  filter(is.na(lat) == FALSE & is.na(lng) == FALSE)
```

An important issue to note is that starting in 2019, Twitter requires users to decide whether they want to opt into allowing the company to collect geotagged information on their tweets.  Before 2019, the default was an automatic opt in.  The change is good for privacy, but not so good for social scientists interested in conducting spatial analysis of tweets.  As a result of the change, less than 10\% of tweets have geographic coordinate information. 


<div style="margin-bottom:25px;">
</div>
## **Mapping Tweets**
\

Now that we have the longitudes and latitudes of the tweets, we can map them.  To do so, let's follow [Lab 4a]() and convert the non-spatial data frames *biden_tweets.geo* and  *trump_tweets.geo* into **sf** objects using the `st_as_sf()` command.  


```r
biden_tweets.geo.sf <- st_as_sf(biden_tweets.geo, coords = c("lng", "lat"), crs = "+proj=longlat +datum=WGS84 +ellps=WGS84")

trump_tweets.geo.sf <- st_as_sf(trump_tweets.geo, coords = c("lng", "lat"), crs = "+proj=longlat +datum=WGS84 +ellps=WGS84")
```

Let's use `leaflet()` to map the points. You can also use `tm_shape()` from the **tmap** package, which we learned about in  [Lab 3](https://crd230.github.io/lab3.html#Mapping_in_R).  First, let's map the Biden tweets.


```r
leaflet() %>%
  addProviderTiles("OpenStreetMap.Mapnik") %>%
  addCircles(data = biden_tweets.geo.sf, 
             color = "blue")
```

<!--html_preserve--><div id="htmlwidget-14ee5f0ce833b6fcaac5" style="width:672px;height:480px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-14ee5f0ce833b6fcaac5">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addProviderTiles","args":["OpenStreetMap.Mapnik",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addCircles","args":[[32.415051,37.91855175,44.900818,44.900818,44.900818,40.47523625,38.8808445,35.935017,26.150368,26.150368,26.150368,37.529883,38.88428135,27.9965945,40.780709,41.765617,41.765617,35.1704985,35.1704985,42.2445985,36.232915,36.709059,32.6782075,40.54970505,44.0752271,38.0033755,33.1946515,37.900595,38.752945,38.752945,43.629311,29.9357675,40.780709,40.0730405,41.275721,42.5610505,42.3527865,42.3354245,40.443207,40.443207,38.0033755,42.7391215,32.7799665,25.6719858,42.746617,42.6516675,41.1179365,43.05672225,43.05672225,43.05672225,33.5857423,41.15,49.8538055,34.0207895,42.8943045,42.57900275,42.57900275,38.6040335,32.6782075,41.45146985,41.45146985,41.83358445,29.8384948,27.698682,41.79158405,27.582329,35.209059,35.84742,33.536182,26.53348575,46.25817755,39.713563,53.5558197,35.296929,35.296929,38.0033755,35.8305215,43.043594,39.713563,47.6148172,27.3108332,39.95827055,36.3194862,40.780709,28.469859,27.698682,27.698682,27.698682,27.698682,27.698682,27.698682,33.29521475,36.006256,45.53640175,45.53640175,36.0871686,32.6782075,40.5539945,42.9108905,43.8717565,33.12148405,40.8186315,41.1179365,42.3527865,27.698682,28.36385665,40.780709,42.6355395,40.572376,45.2487908,34.16825365,25.81696565,40.780709,33.765961,43.555244,34.0207895,35.7261815,41.275721,42.03693905,35.0731115,39.33521565,38.3045585,38.3045585,35.1704985,32.573709,38.89860285,36.006256,30.3233457,30.3233457,33.7671944,31.79336815,31.79336815,33.7671944,33.7671944,33.7671944,36.0871686,38.9374855,31.1104765,34.0207895,32.7799665,42.8031345,40.0048655,32.6782075,39.736777,36.006256,38.0033755,35.3090465,43.0551245,47.6148172,27.93168015,37.0508965,33.526322,35.1704985,32.6855845,41.83358445,37.822244,41.1654697,39.087747,39.3638155,45.188407,30.937336,30.937336,37.663817,40.780709,27.3435985098003,27.3411215,41.298394,41.298394,41.298394,38.3729915,40.655138,38.49819605,41.247487,47.4425832,32.2720465,40.4144955,38.89860285,26.6337105,39.1701115,35.1704985,33.7671944,29.8384948,40.3651595,40.3651595,40.0048655,39.138486,27.698682,29.417501,36.32695575,40.780709,40.780709,34.0451585,29.497157,39.9044253,39.9901065,33.7293783,33.7293783,36.68914925,38.735288,27.385102,27.385102,41.0683178,41.275721,38.8023145,26.53348575,34.13492515,34.13492515,25.9290595,38.81738005,41.1401078,41.5007293,39.7393005,37.125845,42.2855415,38.559987,38.559987,35.115325,41.4959395,30.3233457,40.3651595,45.545501,43.1272685,43.629311,42.6081775,40.61075505,40.61075505,40.61075505,40.61075505,35.9824705,35.9824705,34.04975085,34.04975085,44.5407885,39.0083495,36.01880475,27.698682,42.515052,39.920855,28.980361,43.43024,34.0207895,40.694424,19.28432165,38.9558015,32.5158315,43.9357315,43.9357315,35.1170026,33.914068,38.3045585,32.8100122,28.2993704,27.698682,32.668218,43.39257725,39.1450234,32.342708,27.5036645,30.4547915,44.900818,34.0207895,36.232915,39.9946835,47.6148172,41.5007293,33.5528626,38.29806485,38.8808445,44.8244695,32.576227,28.352158,41.1179365,37.5236445,39.761726,38.49819605,26.0781704,41.7054,36.59629915,37.8758456,37.7615815,41.83358445,38.67141785,29.170974,42.1452605,38.6040335,36.45756025,45.7974457,42.1896195,25.7823537,39.695477],[-99.750556,-122.30220815,-89.5694915,-89.5694915,-89.5694915,-74.3220025,-77.101999,-86.8511765,-80.14917255,-80.14917255,-80.14917255,-77.4931705,-77.1719965,-82.44269375,-73.9685415,-72.6809665,-72.6809665,-79.86103375,-79.86103375,-71.1839105,-115.223125,-81.9685235,-83.1738665,-81.91244105,-103.2334107,-79.420865,-96.699604,-88.9324755,-90.7349615,-90.7349615,-79.2725695,-81.3036785,-73.9685415,-74.7243235,-96.053431,-71.560836,-83.099288,-88.28937925,-74.5422595,-74.5422595,-79.420865,-73.763825,-97.2859135,-80.34711985,-75.770041,-83.2914246,-77.604684,-87.9672925,-87.9672925,-87.9672925,-96.1877851,-73.984562,-97.1526765,-118.4119065,-88.009557,-83.14804355,-83.14804355,-121.375689,-83.1738665,-79.676129,-79.676129,-87.732013,-95.4464865,-83.804475,-88.0400015,-80.4017665,-80.8467855,-86.40961,-82.163663,-80.1129035,-119.2796615,-104.9220935,-113.4926175,-78.0235845,-78.0235845,-79.420865,-85.9785995,-85.6014885,-104.9220935,-122.3306024,-82.51172835,-74.8963554,-119.3195263,-73.9685415,-81.34542515,-83.804475,-83.804475,-83.804475,-83.804475,-83.804475,-83.804475,-111.7385665,-115.03833685,-122.63090815,-122.63090815,-80.244984,-83.1738665,-122.360053,-78.7084675,-72.4511725,-117.2879235,-74.3702987,-77.604684,-83.099288,-83.804475,-81.6882255,-73.9685415,-70.9517005,-74.153947,-75.8001415,-111.93171085,-80.1329624,-73.9685415,-89.8081135,-79.616073,-118.4119065,-83.986413,-96.053431,-71.683502,-92.430839,-84.41491035,-92.4367735,-92.4367735,-79.86103375,-117.1165326,-77.0143985,-115.03833685,-97.75472415,-97.75472415,-84.433106,-106.4174305,-106.4174305,-84.433106,-84.433106,-84.433106,-80.244984,-77.2038845,-97.4060975,-118.4119065,-97.2859135,-73.938142,-75.117998,-83.1738665,-75.6994571,-115.03833685,-79.420865,-98.71699175,-76.21179,-122.3306024,-82.21839435,-76.362276,-82.095304,-79.86103375,-97.461937,-87.732013,-85.7682405,-96.14889335,-74.8257495,-94.35840945,-68.984705,-91.4010085,-91.4010085,-120.987468,-73.9685415,-82.5423874553906,-82.5330735,-72.9291585,-72.9291585,-72.9291585,-90.392152,-73.9487755,-98.319925,-95.83495845,-122.2964883,-110.7668846,-104.735476,-77.0143985,-80.1441757,-77.26434,-79.86103375,-84.433106,-95.4464865,-82.66946745,-82.66946745,-75.117998,-76.540993,-83.804475,-98.5406515,-82.2368185,-73.9685415,-73.9685415,-117.6037832,-95.08702915,-82.8664782,-75.819521,-116.9899205,-116.9899205,-121.64126865,-90.365692,-82.6369205,-82.6369205,-74.15065,-96.053431,-77.2094755,-80.1129035,-117.2940958,-117.2940958,-80.125071,-77.0908695,-95.94091775,-99.6809025,-89.2665075,-93.463637,-73.3096935,-121.5453825,-121.5453825,-114.5723565,-81.7054672,-97.75472415,-82.66946745,-122.4386015,-77.6052065,-79.2725695,-73.829435,-74.6128213,-74.6128213,-74.6128213,-74.6128213,-83.9638415,-83.9638415,-117.24838765,-117.24838765,-80.0697415,-77.017853,-115.2344355,-83.804475,-70.9075225,-75.3374935,-95.9511125,-80.4764034,-118.4119065,-73.3285305,-99.655676,-77.349057,-96.771044,-69.961999,-69.961999,-106.6327181,-118.346138,-92.4367735,-117.10498915,-81.4023468,-83.804475,-114.5847525,-86.32831005,-75.3864607,-111.032309,-82.6140605,-87.2046595,-89.5694915,-118.4119065,-115.223125,-82.98577205,-122.3306024,-99.6809025,-112.1246767,-77.4832879,-77.101999,-93.301344,-86.6807375,-81.65133775,-77.604684,-121.979527,-82.0944945,-98.319925,-80.28518895,-87.7788635,-121.87903315,-122.2795215,-77.4733985,-87.732013,-121.3800735,-80.98226,-76.294949,-121.375689,-94.2659991,-108.56292205,-71.7617435,-80.2333285,-84.153529],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"blue","weight":5,"opacity":0.5,"fill":true,"fillColor":"blue","fillOpacity":0.2},null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null]}],"limits":{"lat":[19.28432165,53.5558197],"lng":[-122.63090815,-68.984705]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

Next, let's map the Trumpy tweets.


```r
leaflet() %>%
  addProviderTiles("OpenStreetMap.Mapnik") %>%
  addCircles(data = trump_tweets.geo.sf, 
             color = "red")
```

<!--html_preserve--><div id="htmlwidget-c8a5baa1296d081c4bdf" style="width:672px;height:480px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-c8a5baa1296d081c4bdf">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addProviderTiles","args":["OpenStreetMap.Mapnik",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addCircles","args":[[37.822244,47.3254495,40.054025,36.307425,41.1179365,46.7583346,42.746617,41.15,41.08253965,30.3233457,40.67087955,38.0033755,32.84881735,32.84881735,32.5209975,33.385555,35.84742,38.8808445,44.0599381,42.97119905,27.097179,34.16825365,26.2047925,37.529883,40.0239815,34.1884781,42.84296625,42.84296625,42.84296625,46.7347065,46.7347065,37.075786,34.1821598,32.6782075,32.6782075,32.6782075,33.8093925,33.8093925,38.997936,28.9200315,28.9200315,40.7913595,43.6984395,38.195555,40.78262345,41.83358445,37.2691755,40.27041835,40.27041835,36.006256,41.5094324,48.168642,32.8462365,35.1704985,39.9946835,43.145023,35.6952221,39.9044253,39.95993,41.1179365,29.8384948,46.365202,50.0511765,45.1801065,36.695883,38.3045585,39.1000485,36.006256,34.7519365,31.34387415,40.655138,40.655138,33.935822,33.935822,32.6782075,37.900595,38.8885185,32.571032,28.31380385,33.12148405,44.218552,39.0083495,40.3651595,42.3113055,42.3113055,42.3113055,42.3113055,38.752945,40.780709,40.780709,41.08197605,34.0207895,32.1893905,29.9357675,29.9357675,35.1704985,42.717573,38.89860285,31.859378,31.3029945,41.275721,41.275721,42.5610505,29.8384948,29.8384948,38.947187,35.1243394,35.8439812,42.4817475,33.8545135,37.7706565,36.006256,36.006256,36.006256,33.29521475,40.9445675,43.1967835,42.5325755,42.5325755,40.8203045,44.360476,38.997936,41.83358445,44.7231447,40.443207,51.027664,40.0849935,41.83358445,29.6731715,35.119918,33.5528626,39.8996225,25.90560545,27.698682,33.7671944,41.247669,38.6040335,35.3090465,38.8051145,28.2320465,27.52491595,27.52491595,42.240875,40.780709,40.780709,29.23699215,41.45146985,38.8051145,41.4485053,38.3045585,40.655138,34.0207895,35.534448,27.82086,34.05733575,21.048719,42.746617,36.786042,34.0207895,34.0207895,36.232915,37.52905585,41.111851,41.83358445,42.155516,39.8996225,41.1179365,41.316085,35.13352055,32.6782075,43.7481015,35.1704985,35.1704985,35.1704985,35.1704985,35.1704985,35.1704985,42.746617,36.5509835,41.83358445,40.0048655,40.0048655,32.576227,32.576227,42.7946145,42.7946145,40.2486455,42.6555285,40.945262,43.629311,38.471623,37.822244,38.502147,38.89860285,41.08197605,39.1225315,40.803235,38.997936,32.8100122,38.0033755,47.6148172,28.0326475,27.3108332,27.698682,39.95827055,43.8717565,39.1000485,40.780709,36.3194862,31.6901135,31.6901135,38.0033755,38.0033755,30.4459085,27.698682,27.698682,27.698682,27.698682,33.29521475,42.3136695,40.348151,34.16825365,34.16825365,27.32138035,27.32138035,27.32138035,25.9851744,40.1662525,42.533282,45.4156857,40.780709,45.53640175,47.481598,39.34582985,41.83358445,38.8878895,42.9108905,35.1170026,39.713563,37.822244,40.4313888,40.4313888,38.0033755,38.0033755,43.5410145,40.8186315,44.900818,27.582329,27.698682,42.3527865,42.561255,41.1179365,38.633388,25.6719858,40.0947845,32.003301,38.2616418,40.655138,42.746617,42.3136695,40.5594805,42.3777775,43.470502,43.470502,40.187495,40.0516365,26.4561475,37.919526,28.0591025,43.333512,29.417501,39.9901065,35.8439812,27.698682,27.84707055,33.765961,40.42139095,32.576227,42.1084705,34.16825365,41.7348625,32.342708,41.4959395,47.6476145,40.873382,45.4945515,38.89860285,39.7393005,35.1704985,35.1704985],[-85.7682405,-122.5934163,-88.264303,-86.5850998,-77.604684,-92.12283995,-75.770041,-73.984562,-111.96751605,-97.75472415,-73.8311875,-79.420865,-83.6540795,-83.6540795,-97.3028295,-86.760091,-86.40961,-77.101999,-121.311582,-71.4440806,-82.431755,-111.93171085,-80.23063465,-77.4931705,-105.24268645,-118.9188865,-73.9872649,-73.9872649,-73.9872649,-117.000734,-117.000734,-122.0832485,-118.32514515,-83.1738665,-83.1738665,-83.1738665,-116.46527935,-116.46527935,-105.5508905,-82.456011,-82.456011,-74.26299,-70.3515075,-85.7223455,-124.169452,-87.732013,-119.3066075,-74.53944605,-74.53944605,-115.03833685,-112.0068406,-122.1505695,-97.09450645,-79.86103375,-82.98577205,-75.2698195,-97.455741,-82.8664782,-75.605775,-77.604684,-95.4464865,-94.7980796,-110.70934,-93.3774155,-79.8973385,-92.4367735,-94.5592817,-115.03833685,-92.131274,-92.4001915,-73.9487755,-73.9487755,-117.397616,-117.397616,-83.1738665,-88.9324755,-104.789327,-89.876449,-80.7318815,-117.2879235,-88.443615,-77.017853,-82.66946745,-83.369718,-83.369718,-83.369718,-83.369718,-90.7349615,-73.9685415,-73.9685415,-112.0741955,-118.4119065,-110.9155735,-81.3036785,-81.3036785,-79.86103375,-73.9409845,-77.0143985,-106.654188,-82.2444045,-96.053431,-96.053431,-71.560836,-95.4464865,-95.4464865,-121.081968,-120.5807805,-78.657837,-83.1682025,-83.996909,-122.4359785,-115.03833685,-115.03833685,-115.03833685,-111.7385665,-73.860857,-89.230524,-70.973641,-70.973641,-74.853962,-84.4189445,-105.5508905,-87.732013,-93.434323,-74.5422595,-114.08785095,-74.7086405,-87.732013,-82.3302695,-120.6218085,-112.1246767,-75.320699,-80.177668,-83.804475,-84.433106,-85.855172,-121.375689,-98.71699175,-77.2369685,-82.1893645,-82.5944365,-82.5944365,-122.7781,-73.9685415,-73.9685415,-81.0167722,-79.676129,-77.2369685,-82.0193025,-92.4367735,-73.9487755,-118.4119065,-77.4032335,-82.8219845,-81.11191575,-87.0316645,-75.770041,-119.7824645,-118.4119065,-118.4119065,-115.223125,-122.03036505,-74.142018,-87.732013,-71.4272115,-75.320699,-77.604684,-73.135176,-89.922029,-83.1738665,-78.9482085,-79.86103375,-79.86103375,-79.86103375,-79.86103375,-79.86103375,-79.86103375,-75.770041,-87.3221685,-87.732013,-75.117998,-75.117998,-86.6807375,-86.6807375,-70.992785,-70.992785,-111.671789,-83.5042015,-73.993189,-79.2725695,-78.0003165,-85.7682405,-117.0226945,-77.0143985,-112.0741955,-76.48367,-96.69656245,-105.5508905,-117.10498915,-79.420865,-122.3306024,-82.679232,-82.51172835,-83.804475,-74.8963554,-72.4511725,-94.5592817,-73.9685415,-119.3195263,-106.18757185,-106.18757185,-79.420865,-79.420865,-97.6821955,-83.804475,-83.804475,-83.804475,-83.804475,-111.7385665,-71.0887125,-76.2107655,-111.93171085,-111.93171085,-80.2302895,-80.2302895,-80.2302895,-80.16212825,-80.2680565,-71.1036075,-122.83160655,-73.9685415,-122.63090815,-122.194398,-84.3027665,-87.732013,-76.7859572,-78.7084675,-106.6327181,-104.9220935,-85.7682405,-79.98068965,-79.98068965,-79.420865,-79.420865,-96.73114255,-74.3702987,-89.5694915,-80.4017665,-83.804475,-83.099288,-114.465155,-77.604684,-90.47813565,-80.34711985,-75.3817475,-80.9723685,-85.4804963,-73.9487755,-75.770041,-71.0887125,-111.9632777,-87.9378545,-81.775474,-81.775474,-75.461587,-75.6444395,-80.0931798,-78.3240835,-82.5117856,-73.6609045,-98.5406515,-75.819521,-78.657837,-83.804475,-82.7840956,-89.8081135,-79.862208,-86.6807375,-87.741282,-111.93171085,-86.1205405,-111.032309,-81.7054672,-122.5355625,-74.3806565,-114.14326245,-77.0143985,-89.2665075,-79.86103375,-79.86103375],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"red","weight":5,"opacity":0.5,"fill":true,"fillColor":"red","fillOpacity":0.2},null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null]}],"limits":{"lat":[21.048719,51.027664],"lng":[-124.169452,-70.3515075]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

Rather than the entire United States, let's map tweets located within the Los Angeles Metropolitan Area.  To do this, we'll need to make sure the the **sf** object *la.metro* has the same CRS as *biden_tweets.geo.sf*.


```r
st_crs(la.metro) == st_crs(biden_tweets.geo.sf)
```

```
## [1] FALSE
```

Let's reproject *la.metro* into the same CRS as *biden_tweets.geo.sf* using the function `st_transform()`, which we learned about in [Lab 4a]().


```r
la.metro <-st_transform(la.metro, crs = st_crs(biden_tweets.geo.sf)) 
```

Let's keep the Biden and Trump tweets within the metro area using the `st_within` option in the `st_join()` command, which we learned about in [Lab 3]().


```r
biden_tweets.geo.la <- st_join(biden_tweets.geo.sf, la.metro, join = st_within, left=FALSE)
trump_tweets.geo.la <- st_join(trump_tweets.geo.sf, la.metro, join = st_within, left=FALSE)
```

Finally, use `leaflet()` to map the tweets on top of the metro area boundary.


```r
leaflet() %>%
  addProviderTiles("OpenStreetMap.Mapnik") %>%
  addPolygons(data = la.metro, 
              color = "gray", 
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.2) %>%
  addCircles(data = biden_tweets.geo.la, 
             color = "blue") %>%
  addCircles(data = trump_tweets.geo.la, 
             color = "red")
```

<!--html_preserve--><div id="htmlwidget-2e61883fd9cf13029592" style="width:672px;height:480px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-2e61883fd9cf13029592">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addProviderTiles","args":["OpenStreetMap.Mapnik",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addPolygons","args":[[[[{"lng":[-118.604415,-118.598783,-118.585936,-118.580255,-118.570351,-118.557605,-118.54453,-118.538624,-118.534276,-118.530702,-118.528239,-118.524769,-118.522635,-118.510537,-118.50285,-118.500212,-118.499574,-118.500288,-118.497435,-118.493632,-118.489354,-118.486264,-118.482224,-118.477646,-118.473485,-118.47034,-118.454636,-118.449535,-118.445812,-118.442276,-118.436905,-118.434805,-118.430172,-118.423576,-118.409099,-118.406444,-118.39525,-118.390955,-118.382037,-118.377169,-118.370323,-118.368301,-118.36727,-118.370161,-118.368126,-118.365094,-118.3587,-118.351275,-118.332486,-118.331314021324,-118.329158,-118.32446,-118.322741,-118.321841674063,-118.318476,-118.316525695019,-118.310222,-118.310213,-118.309064992916,-118.308955,-118.307767,-118.30539,-118.30539,-118.305084,-118.306816,-118.312045,-118.316787,-118.325244,-118.343249,-118.354042,-118.360332,-118.367806,-118.374768,-118.384564,-118.393055,-118.402941,-118.408543,-118.413767,-118.424258,-118.431112,-118.436352,-118.441066,-118.456309,-118.465368,-118.474143,-118.482937,-118.487453,-118.48877,-118.489592,-118.487215,-118.482609,-118.485789,-118.481086,-118.482462,-118.478421,-118.475331,-118.47652,-118.478465,-118.481035,-118.482239,-118.485575,-118.486264,-118.487453,-118.484949,-118.48769,-118.48875,-118.495059,-118.49817,-118.503952,-118.507656,-118.511696,-118.51336,-118.514073,-118.515914,-118.516267,-118.52323,-118.533681,-118.536415,-118.53738,-118.542357,-118.545441,-118.548061,-118.552577,-118.555178,-118.558715,-118.563442,-118.565854,-118.570927,-118.575394,-118.573317,-118.575901,-118.579435,-118.58609,-118.589886,-118.592745,-118.595122,-118.593969,-118.601185,-118.603916,-118.607243,-118.604415],"lat":[33.478552,33.477939,33.473819,33.475099,33.47531,33.474722,33.474119,33.477015,33.473493,33.468071,33.466603,33.466355,33.462016,33.455313,33.453302,33.449592,33.445931,33.443352,33.441964,33.442559,33.445336,33.446724,33.44831,33.448392,33.442877,33.442956,33.433961,33.432673,33.428907,33.428645,33.428637,33.426781,33.428278,33.427258,33.421203,33.421559,33.416204,33.417963,33.409883,33.410821,33.409285,33.40711,33.401088,33.396013,33.389533,33.388374,33.381633,33.373936,33.358228,33.3558509398843,33.351478,33.348782,33.344728,33.3442993177889,33.342695,33.3408250322726,33.334781,33.335795,33.3309,33.330431,33.32348,33.320898,33.315933,33.310323,33.308385,33.306597,33.301137,33.299075,33.305234,33.313111,33.31533,33.317254,33.320065,33.321019,33.319659,33.320901,33.321494,33.320241,33.317839,33.319183,33.320104,33.318555,33.32182,33.326056,33.334204,33.344331,33.350883,33.356649,33.360412,33.365772,33.369914,33.372918,33.375946,33.380261,33.381849,33.383238,33.385818,33.38632,33.388994,33.396108,33.401176,33.40467,33.409233,33.412131,33.414392,33.419826,33.422129,33.421447,33.424234,33.426691,33.429667,33.427683,33.423517,33.422417,33.425075,33.430733,33.429183,33.430658,33.434608,33.434824,33.434159,33.435617,33.435617,33.43338,33.433419,33.434381,33.437503,33.439351,33.440179,33.443633,33.448261,33.449302,33.456243,33.461521,33.46239,33.465166,33.467198,33.469853,33.473493,33.478449,33.478552]}],[{"lng":[-118.6105,-118.598853,-118.595763,-118.593862,-118.586732,-118.57988,-118.573897,-118.56843,-118.56843,-118.565578,-118.562726,-118.558448,-118.552743,-118.550842,-118.549891,-118.542999,-118.536247,-118.534204,-118.52446,-118.519196,-118.51828,-118.499503,-118.488332,-118.483579,-118.470893,-118.463614,-118.456958,-118.423446,-118.406808,-118.397328,-118.386605,-118.373533,-118.354185,-118.360936,-118.367591,-118.377811,-118.383031,-118.391834,-118.400866,-118.406095,-118.40871,-118.41584,-118.422733,-118.427249,-118.431809,-118.434141,-118.436233,-118.439396,-118.444029,-118.450931,-118.452585,-118.454677,-118.462016,-118.467987,-118.475402,-118.477684,-118.489853,-118.495368,-118.495938,-118.499922,-118.506206,-118.505065,-118.507537,-118.513051,-118.513811,-118.51229,-118.52503,-118.530544,-118.535823,-118.542143,-118.547087,-118.545565,-118.546835,-118.55203,-118.549559,-118.55146,-118.555453,-118.556404,-118.561347,-118.56439,-118.574087,-118.580362,-118.582263,-118.581883,-118.584735,-118.590249,-118.593435,-118.597475,-118.601468,-118.606982,-118.610262,-118.6105],"lat":[33.032941,33.036329,33.034336,33.03055,33.031746,33.034459,33.03055,33.02497,33.020188,33.014807,33.006834,33.006834,33.002848,32.996668,32.989492,32.98072,32.977404,32.971946,32.964369,32.95856,32.954198,32.933654,32.923679,32.921484,32.915948,32.909712,32.900932,32.875784,32.864206,32.857447,32.848233,32.839047,32.820919,32.817078,32.820873,32.822471,32.824948,32.826266,32.823869,32.821073,32.813083,32.810886,32.809287,32.80669,32.801462,32.805372,32.811445,32.815671,32.816718,32.822112,32.820553,32.821033,32.82814,32.832217,32.835093,32.840365,32.84372,32.846116,32.84979,32.851777,32.852985,32.857138,32.863527,32.868957,32.873269,32.879178,32.886523,32.894985,32.90628,32.906799,32.911907,32.9151,32.918408,32.91925,32.924198,32.930582,32.934252,32.947018,32.951805,32.958506,32.964887,32.974299,32.982594,32.987698,32.98993,33.005559,33.012386,33.013212,33.017039,33.015126,33.015803,33.032941]}],[{"lng":[-118.944502,-118.940801,-118.892195,-118.876906,-118.868065,-118.856473,-118.833456,-118.826082,-118.820951,-118.81488,-118.806404,-118.789376,-118.788889,-118.788749,-118.775577,-118.774004,-118.758599,-118.758468,-118.755581,-118.744934,-118.740157,-118.728689,-118.723374,-118.716891,-118.711994,-118.710916,-118.703392,-118.693834,-118.67566,-118.674241,-118.668152,-118.668153,-118.668162,-118.66814,-118.66805,-118.667944,-118.6678,-118.6678,-118.667796,-118.66778,-118.667773,-118.667708,-118.667713,-118.650138,-118.648113,-118.632495,-118.632537,-118.632602,-118.632546,-118.633281,-118.633461,-118.633494,-118.633544,-118.636789,-118.650859,-118.652285,-118.670593,-118.677616,-118.691397,-118.6929,-118.722616,-118.722668,-118.722716,-118.726568,-118.738618,-118.796842,-118.821077,-118.881364,-118.893056,-118.894634,-118.884388,-118.881729,-118.88375,-118.884525,-118.884642,-118.883381,-118.88253,-118.877289,-118.870926,-118.854114,-118.854253,-118.843579,-118.836589,-118.78689,-118.785537,-118.690867,-118.626162,-118.625688,-118.625003,-118.587591,-118.571879,-118.569714,-118.563652,-118.559404,-118.326281,-118.290456,-118.23767,-118.220048,-118.170237,-118.16678,-118.140074,-118.13083,-118.125834,-118.042259,-118.023406,-117.774368,-117.667292,-117.667244,-117.667108,-117.667323,-117.667085,-117.667087,-117.666923,-117.666954,-117.667221,-117.666969,-117.667068,-117.666984,-117.667074,-117.666651,-117.667034,-117.659994,-117.660346,-117.660052,-117.659792,-117.659673,-117.655235,-117.655213,-117.652685,-117.652246,-117.652119,-117.650459,-117.650454,-117.647027,-117.646924,-117.646374,-117.652907,-117.656255,-117.66073,-117.661396,-117.663777,-117.677405,-117.677706,-117.677576,-117.681713,-117.683264,-117.685551,-117.686799,-117.689171,-117.693545,-117.699582,-117.702479,-117.704433,-117.70429,-117.704622,-117.704725,-117.705342,-117.70848,-117.709413,-117.709928,-117.711067,-117.712087,-117.712677,-117.713409,-117.715019,-117.716599,-117.718007,-117.719481,-117.719547,-117.720837,-117.722224,-117.723564,-117.724411,-117.724434,-117.724509,-117.72608,-117.728038,-117.728059,-117.728676,-117.729481,-117.730125,-117.731717,-117.735344,-117.735846,-117.744342,-117.744385,-117.745378,-117.745417,-117.76769,-117.767752,-117.767227,-117.767045,-117.767483,-117.769921,-117.779771,-117.785062,-117.79111,-117.802539,-117.802469,-117.802445,-117.793667,-117.793585,-117.793578,-117.783287,-117.781866,-117.772911,-117.768225,-117.765567,-117.748097,-117.737752,-117.735464,-117.732532,-117.710282,-117.707294,-117.687857,-117.680289,-117.677198,-117.673749,-117.673134,-117.672568,-117.672439,-117.67225,-117.671928,-117.671608,-117.675053,-117.674519,-117.674282,-117.662117,-117.63665,-117.607639,-117.580789,-117.580136,-117.574628,-117.569175,-117.548355,-117.542265,-117.536448,-117.535807,-117.535316,-117.535033,-117.534137,-117.533999,-117.497645,-117.474573,-117.459817,-117.457862,-117.455887,-117.424038,-117.413314,-117.413899,-117.415815,-117.457937,-117.460901,-117.466296,-117.496701,-117.501162,-117.506238,-117.51021,-117.509909,-117.503181,-117.503756,-117.509725,-117.509722,-117.509455,-117.509581,-117.508614,-117.515014,-117.526919,-117.527599,-117.538429,-117.542667,-117.548282,-117.554085,-117.557226,-117.557985,-117.56813,-117.573339,-117.57848,-117.583508,-117.588415,-117.590519,-117.593599,-117.596147232519,-117.602263,-117.607278225611,-117.607905,-117.609747035085,-117.612495,-117.617294,-117.620035922967,-117.62217,-117.625891,-117.631682,-117.631740265841,-117.633779719464,-117.642595,-117.645582,-117.645590475743,-117.645873824588,-117.650688133729,-117.652692,-117.658067,-117.663589,-117.668314000402,-117.673385,-117.681025,-117.684264212833,-117.684584,-117.68942,-117.689933,-117.691984,-117.691353,-117.691384,-117.694693,-117.704675,-117.707093,-117.70855,-117.709652,-117.713370543169,-117.714617,-117.715349,-117.715657,-117.715688,-117.714783,-117.715102,-117.720363,-117.721616,-117.725553332195,-117.726432511331,-117.726486,-117.731952549347,-117.7333,-117.734159829272,-117.736930297021,-117.73785,-117.739057040307,-117.73955,-117.745900121131,-117.746288,-117.753647135784,-117.754974,-117.759725,-117.761387,-117.763186562364,-117.765063,-117.769151,-117.773960352148,-117.776844,-117.779623540442,-117.782690350999,-117.784888,-117.788621431492,-117.789036604692,-117.792488,-117.792863012556,-117.792935687705,-117.801288,-117.804936775734,-117.806916,-117.806980506149,-117.807515,-117.811379,-117.813513,-117.814777345952,-117.818587379913,-117.819821,-117.82007157039,-117.820304,-117.826188,-117.828968532272,-117.833446,-117.834407884509,-117.836703491457,-117.839534307378,-117.840253246872,-117.840289,-117.846943570933,-117.853332,-117.858586243127,-117.861134113801,-117.86427,-117.866147640884,-117.870749,-117.873352,-117.87679,-117.878044124759,-117.878896649729,-117.893642260748,-117.899241801308,-117.89926,-117.926632038946,-117.928019,-117.940591,-117.957309626045,-117.95749108767,-117.957547941498,-117.95793609656,-117.965047927353,-117.970879695968,-117.987898975382,-118.000593,-118.000805725047,-118.005471002914,-118.008183541003,-118.008427656492,-118.018783843459,-118.029694,-118.032290264993,-118.040179,-118.055592054055,-118.064895,-118.065422842208,-118.078717332574,-118.079496880089,-118.086975238717,-118.088928,-118.094861865584,-118.113647,-118.115411077283,-118.132595110124,-118.132698,-118.136934513913,-118.146562657989,-118.156429,-118.156757879998,-118.159907459484,-118.166497421716,-118.166887,-118.1755,-118.176198747974,-118.176375951824,-118.18035,-118.17962,-118.179848969804,-118.184574795877,-118.187708646817,-118.188656531138,-118.189833,-118.18584,-118.185734259285,-118.183342,-118.197436491762,-118.206534,-118.231992045233,-118.232947994158,-118.244617800581,-118.247762674392,-118.262297,-118.269645,-118.271736695544,-118.277208,-118.277973646643,-118.277979661873,-118.283540991907,-118.284296,-118.2854122865,-118.28589791404,-118.287998876897,-118.288373,-118.292873356242,-118.294788,-118.295110239771,-118.296463,-118.310155,-118.311561623405,-118.314141,-118.317482,-118.320359,-118.32121556571,-118.322314556494,-118.324075414676,-118.332893576362,-118.342622,-118.352052,-118.354705,-118.360505,-118.364121,-118.367945,-118.36931,-118.369720214979,-118.373635232807,-118.375351827301,-118.376283,-118.376531,-118.381749,-118.385006,-118.38979429006,-118.392895696474,-118.398286,-118.402885,-118.404415,-118.411211,-118.411397166472,-118.414152142573,-118.414215567372,-118.41428,-118.418352,-118.420570349199,-118.422038857667,-118.422446045219,-118.422925,-118.423945374797,-118.4244667723,-118.424936,-118.421917,-118.423733089004,-118.423819,-118.427147,-118.428291710559,-118.428407,-118.427048141908,-118.424484398135,-118.423407,-118.422657764543,-118.420238443633,-118.42009325589,-118.417438,-118.406999,-118.407408568928,-118.408297,-118.405007,-118.400022285949,-118.394376070379,-118.394307,-118.391507,-118.391506490151,-118.391053742248,-118.390875011333,-118.390838873728,-118.390511,-118.391103,-118.392027,-118.392477583363,-118.395387667506,-118.399709,-118.401798,-118.401713930418,-118.40157,-118.400096484591,-118.399479,-118.399484377404,-118.399493,-118.400871783649,-118.402912055249,-118.402962040086,-118.409548310693,-118.409639542292,-118.412695385473,-118.412708,-118.414654067515,-118.415610998909,-118.416260078565,-118.417544927084,-118.419224092145,-118.419436785343,-118.421082808566,-118.421963372164,-118.422017845132,-118.423654974265,-118.423674490672,-118.430011733396,-118.435197538436,-118.44241,-118.442490840366,-118.44822599166,-118.450677,-118.455822236985,-118.460611,-118.468640820036,-118.473070126836,-118.476600463193,-118.483466847853,-118.484998,-118.487584492053,-118.493115463502,-118.502813,-118.502825537466,-118.509618879472,-118.516877737351,-118.519514,-118.519726744824,-118.536114307181,-118.543115,-118.549076,-118.554891,-118.555873129927,-118.562149,-118.56714103306,-118.567373764407,-118.567985647474,-118.569235,-118.569735264596,-118.574725494359,-118.575908,-118.579252741749,-118.579737,-118.583902,-118.584351039228,-118.592815,-118.603572,-118.609652,-118.617337997816,-118.622757,-118.623493434314,-118.626946,-118.627789009915,-118.635250350277,-118.635920764079,-118.636314,-118.636463223339,-118.643847,-118.649901,-118.657381,-118.668358,-118.67543,-118.677696,-118.678849,-118.683183,-118.690213,-118.697388,-118.706215,-118.714155488725,-118.714468,-118.719538,-118.732391,-118.732460426152,-118.744952,-118.748230929668,-118.749891892712,-118.752339,-118.756402,-118.767741,-118.77905748101,-118.783433,-118.787075190351,-118.787094,-118.787138163409,-118.791915542234,-118.793331,-118.794289,-118.800541,-118.803753,-118.805114,-118.806367,-118.808901,-118.810435973687,-118.821419492801,-118.8215584688,-118.821579,-118.821958649246,-118.836821808211,-118.84038,-118.842675913429,-118.8467,-118.854653,-118.859205,-118.862499,-118.874853,-118.882023,-118.895628330318,-118.896159,-118.905781,-118.915968,-118.921269,-118.928048,-118.931549,-118.93481,-118.938081,-118.944862413904,-118.944502],"lat":[34.046563,34.074967,34.104817,34.11421,34.11964,34.126765,34.140882,34.145408,34.148554,34.152266,34.157472,34.167911,34.168214,34.168213,34.168158,34.168146,34.168073,34.168073,34.168059,34.168005,34.167975,34.167892,34.167861,34.168288,34.168619,34.168617,34.168591,34.168557,34.168286,34.168268,34.168195,34.17675,34.184141,34.191331,34.194971,34.199166,34.206635,34.206773,34.209329,34.216517,34.223426,34.236692,34.240404,34.240403,34.240435,34.240426,34.241948,34.25493,34.263351,34.268322,34.269522,34.269812,34.270242,34.291804,34.320484,34.323392,34.360692,34.374993,34.403033,34.406088,34.466483,34.466587,34.466686,34.474507,34.498969,34.616567,34.665791,34.790629,34.814717,34.817972,34.817651,34.817802,34.815528,34.813812,34.811795,34.808637,34.807662,34.803212,34.803109,34.803279,34.817772,34.817761,34.817504,34.817715,34.817817,34.818095,34.818193,34.818225,34.818266,34.818022,34.818025,34.818255,34.818025,34.818303,34.819726,34.820103,34.820146,34.820138,34.820513,34.820568,34.82078,34.820733,34.821013,34.821952,34.822163,34.823301,34.822526,34.734334,34.715855,34.713028,34.690155,34.67552,34.631653,34.603367,34.600545,34.597518,34.587458,34.587267,34.576158,34.573464,34.558008,34.55804,34.557848,34.498629,34.462523,34.451605,34.397222,34.396953,34.366165,34.360809,34.35925,34.339025,34.338963,34.297129,34.295875,34.28917,34.262969,34.249765,34.232393,34.22976,34.220334,34.166103,34.165173,34.164368,34.155827,34.150488,34.142486,34.138122,34.132318,34.121627,34.106824,34.099533,34.095346,34.095055,34.094221,34.093957,34.09261,34.085254,34.083155,34.081984,34.079536,34.077213,34.075893,34.074257,34.070591,34.066887,34.063175,34.059731,34.059476,34.055854,34.052183,34.048469,34.045448,34.044865,34.044687,34.040935,34.033632,34.033543,34.029835,34.025139,34.021371,34.020589,34.0188,34.018554,34.019852,34.019859,34.020018,34.020024,34.023506,34.019429,34.013567,34.011192,34.004611,34.004639,34.00475,34.004809,33.994677,33.975551,33.970076,33.968308,33.968135,33.957895,33.95379,33.946411,33.945396,33.939093,33.935767,33.933834,33.921432,33.914732,33.913251,33.911352,33.896736,33.894812,33.88229,33.877412,33.873945,33.870831,33.871005,33.870397,33.870258,33.870055,33.86971,33.869368,33.868725,33.861588,33.857956,33.857499,33.829975,33.797731,33.769477,33.767988,33.766455,33.76461,33.760112,33.758801,33.757665,33.750018,33.736029,33.727542,33.712584,33.710355,33.705575,33.703811,33.691714,33.690219,33.688954,33.667017,33.659302,33.657653,33.655268,33.602189,33.598031,33.591087,33.552615,33.545814,33.539496,33.533999,33.520546,33.520405,33.508945,33.509062,33.505019,33.484027,33.471633,33.469614,33.467739,33.461776,33.461136,33.455643,33.454987,33.453669,33.452524,33.451194,33.451633,33.452907,33.453339,33.453927,33.435413,33.416832,33.407544,33.396819,33.3871676935322,33.399496,33.4055592495383,33.406317,33.4084166792082,33.411549,33.416196,33.419457516245,33.421996,33.424632,33.430528,33.4305744823985,33.4322014853532,33.439234,33.440728,33.4407344682672,33.4409507060779,33.4446247484685,33.446154,33.44955,33.451981,33.4549334017417,33.458102,33.461754,33.4619114554145,33.461927,33.461658,33.457846,33.456627,33.454355,33.454028,33.455604,33.457878,33.460285,33.46063,33.460332,33.4600189383596,33.459914,33.460556,33.461675,33.462657,33.463262,33.464463,33.472911,33.473427,33.4815118710374,33.4833171670033,33.483427,33.484659260023,33.484963,33.4858239631128,33.4885980842261,33.489519,33.493329697252,33.494886,33.500454843242,33.500795,33.5104942155721,33.512243,33.514417,33.516326,33.5189103007938,33.521605,33.525132,33.529323694547,33.531837,33.5351846116113,33.538878204435,33.541525,33.5426175199525,33.5427390127417,33.543749,33.5438587337878,33.5438799995273,33.546324,33.5477820839774,33.548573,33.5488290861813,33.550951,33.55232,33.551209,33.5519119266416,33.5540301557316,33.554716,33.5566816546776,33.558505,33.563001,33.56421618991,33.566173,33.567206150832,33.5696718400128,33.5727123919663,33.5734845979119,33.573523,33.5766199290474,33.579593,33.5826101787419,33.5840732593512,33.585874,33.5873392496233,33.59093,33.592933,33.592322,33.5927649901298,33.5930661245617,33.5982746654898,33.6002525717392,33.600259,33.6068528831608,33.607187,33.620021,33.6295776053814,33.6296813314377,33.6297138298976,33.6299357048736,33.6340009289084,33.6373344511233,33.647062914264,33.654319,33.6544805412119,33.6580233052265,33.6600831787442,33.6602685575347,33.6681329393697,33.676418,33.6786787438614,33.685548,33.7014312532279,33.711018,33.7114615693105,33.7226335215186,33.723288610006,33.7295730077451,33.731214,33.7338709045787,33.742282,33.7432945549888,33.7531579426908,33.753217,33.7545459203814,33.7575661009257,33.760661,33.7607417891292,33.761515481011,33.7631343003815,33.76323,33.763617,33.7635876093636,33.7635801558408,33.763413,33.759181,33.7589618947527,33.7544396683534,33.751440831064,33.7505337838237,33.749408,33.738254,33.7376161692958,33.723186,33.7231252269241,33.723086,33.7148399728315,33.7145303347293,33.7107504081902,33.7097317630173,33.705024,33.70403,33.7048765794077,33.707091,33.7072771186745,33.7072785808984,33.7086304674177,33.708814,33.7079110044449,33.7075181666659,33.7058186387034,33.705516,33.7052325792795,33.705112,33.7058199655875,33.708792,33.712932,33.7134962726604,33.714531,33.71363,33.717186,33.7175240016063,33.7179576643668,33.7186525006033,33.7221321552055,33.725971,33.727681,33.732317,33.736817,33.737998,33.738086,33.736315,33.7364102442351,33.7373192380487,33.7377177991397,33.737934,33.740444,33.742875,33.741417,33.7395528840656,33.7383454841286,33.736247,33.739401,33.741171,33.741985,33.7423394381553,33.747584575123,33.7477053281701,33.747828,33.759475,33.7618073470259,33.763351320066,33.7637794324106,33.764283,33.7662242998376,33.7672162773846,33.768109,33.769355,33.7723732215257,33.772516,33.772318,33.7744956755626,33.774715,33.7766989328139,33.7804419987226,33.782015,33.7827560765859,33.7851490520678,33.7852926587749,33.787919,33.79189,33.7934900955591,33.796961,33.800215,33.8021250306178,33.8042885337802,33.804315,33.815415,33.815425247667,33.8245252077666,33.828117591483,33.8288439355918,33.835434,33.838771,33.838723,33.8390036614674,33.8408163082553,33.843508,33.847951,33.8484786472454,33.849382,33.8501374320985,33.850454,33.8517234513727,33.853759,33.8569051098863,33.8615606036307,33.8616746590802,33.8767032178307,33.8769113901839,33.8838842161597,33.883913,33.8876082481903,33.8894252966614,33.890657787522,33.8930974943305,33.8962859405721,33.8966898084495,33.8998153240298,33.9014873631624,33.9015907979799,33.9046994252093,33.9047364835165,33.9167698197367,33.9266167734248,33.940312,33.9404621418875,33.9511138308875,33.955666,33.9626297317564,33.969111,33.9783541667707,33.9834527644046,33.987516552579,33.9954204829596,33.997183,33.9998436821985,34.0055333023368,34.015509,34.0155180084182,34.0203991594915,34.0256147929591,34.027509,34.0276081475071,34.0352454000966,34.038508,34.040201,34.037762,34.0381717395174,34.04079,34.0413888185296,34.0414167357812,34.0414901341169,34.04164,34.0414979347506,34.0400808082107,34.039745,34.0397991587852,34.039807,34.037475,34.0375951569123,34.03986,34.039048,34.036424,34.0375993330502,34.038428,34.0381537489782,34.036868,34.036810497509,34.0363015525377,34.0362558229882,34.036229,34.0362626955926,34.03793,34.037531,34.038551,34.038887,34.037479,34.03614,34.03311,34.030723,34.032245,34.032519,34.029383,34.0312553120148,34.031329,34.031093,34.032743,34.0327394626433,34.032103,34.0312032585032,34.030747488625,34.030076,34.025719,34.025231,34.022571352921,34.021543,34.0195552654135,34.019545,34.0194857047642,34.0130714398482,34.011171,34.007413,34.006712,34.004473,34.001239,34.000198,34.001622,34.0031156875199,34.0138037830643,34.0139390210272,34.013959,34.0142329790953,34.0249591820016,34.027527,34.0288820248563,34.031257,34.034215,34.035309,34.034554,34.037648,34.0381,34.0391654428878,34.039207,34.041488,34.041753,34.044475,34.045847,34.045536,34.043507,34.043383,34.0454177344622,34.046563]}]]],null,null,{"interactive":true,"className":"","stroke":true,"color":"gray","weight":1,"opacity":1,"fill":true,"fillColor":"gray","fillOpacity":0.2,"smoothFactor":0.5,"noClip":false},null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addCircles","args":[[34.0207895,34.0207895,34.0207895,34.0207895,33.914068,34.0207895],[-118.4119065,-118.4119065,-118.4119065,-118.4119065,-118.346138,-118.4119065],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"blue","weight":5,"opacity":0.5,"fill":true,"fillColor":"blue","fillOpacity":0.2},null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null]},{"method":"addCircles","args":[[34.1821598,34.0207895,34.0207895,34.0207895,34.0207895],[-118.32514515,-118.4119065,-118.4119065,-118.4119065,-118.4119065],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"red","weight":5,"opacity":0.5,"fill":true,"fillColor":"red","fillOpacity":0.2},null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null]}],"limits":{"lat":[32.801462,34.823301],"lng":[-118.944862413904,-117.413314]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

You might be thinking that you can directly get tweets in Los Angeles using `geocode = lookup_coords("los angeles, CA")` in `search_tweets()`.  You can but only if you have a [Google Maps API Key](https://developers.google.com/maps/documentation/geocoding/get-api-key), which requires you to provide a credit card number (to pay in case you go over their free limit).  **rtweet**  only allows you to narrow the  tweets to the United States without a Google Maps API Key.

<div style="margin-bottom:25px;">
</div>
## **Mapping Twitter User Locations**
\

The fourth source for Twitter geographic information is the location specified by the user in their account profile.  This information is stored in the variable *location*.  Let's plot the top 10 locations of users who tweeted "biden"


```r
biden_tweets %>%
  count(location, sort = TRUE) %>%
  mutate(location = reorder(location,n)) %>%
  na.omit() %>%
  top_n(10) %>%
  ggplot(aes(x = location,y = n)) +
  geom_col() +
  coord_flip() +
  labs(x = "Place",
       y = "Count",
       title = "Biden Tweet users - unique locations ")
```

![](lab4b_files/figure-html/unnamed-chunk-24-1.png)<!-- -->

And Trumpy


```r
trump_tweets %>%
  count(location, sort = TRUE) %>%
  mutate(location = reorder(location,n)) %>%
  na.omit() %>%
  top_n(10) %>%
  ggplot(aes(x = location,y = n)) +
  geom_col() +
  coord_flip() +
  labs(x = "Place",
       y = "Count",
       title = "Trump Tweet users - unique locations ")
```

![](lab4b_files/figure-html/unnamed-chunk-25-1.png)<!-- -->

You can also search for users (not tweets) using the function `search_users()`. Twitter will look for matches in user names, screen names, and profile bios. Let's look for users with the words "maga" somewhere in their profile bios, user names or screen names. The maximum number of users a single call returns is 1,000.


```r
# what users are tweeting with maga
users <- search_users("maga",
                      n = 1000)
```

and their locations (eliminating NA and blank values)


```r
users %>%
  count(location, sort = TRUE) %>%
  mutate(location = reorder(location,n)) %>%
  filter(is.na(location) == FALSE & location != "") %>%
  top_n(20) %>%
  ggplot(aes(x = location,y = n)) +
  geom_col() +
  coord_flip() +
  labs(x = "Location",
       y = "Count",
       title = "MAGA users - unique locations ")
```

![](lab4b_files/figure-html/unnamed-chunk-27-1.png)<!-- -->

You can repeat the process of getting Longitude and Latitude coordinates of "MAGA" users and map them across the United States and within the Los Angeles Metropolitan Area.

You've completed the lab guide on how to use the package **rtweet** to bring in Twitter data. Hey, you know what? You earned a badge! Woohoo!

<center>
![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/rtweet.png){ width=25% }

</center>

***

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.


Website created and maintained by [Noli Brazil](https://nbrazil.faculty.ucdavis.edu/)
