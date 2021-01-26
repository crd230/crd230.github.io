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

To send a request for tweets to Twitter's API use the function `search_tweets()`.  Let's collect the 10,000 most recent tweets that contain the word "biden".


```r
biden_tweets <- search_tweets(q="biden", n = 10000,
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
trump_tweets <- search_tweets(q="trump", n = 10000,
                              include_rts = FALSE, lang = "en",
                              geocode = lookup_coords("usa"))
```

Check the data.


```r
glimpse(trump_tweets)
```


***

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.


Website created and maintained by [Noli Brazil](https://nbrazil.faculty.ucdavis.edu/)
