---
title: "Data Sources"
subtitle: <h4 style="font-style:normal">CRD 298 - Spatial Methods in Community Research</h4>
output: 
  html_document:
    theme: cosmo
---

<h4 style="font-style:normal">Winter 2019</h4>

<style>
p.comment {
background-color: #DBDBDB;
padding: 10px;
border: 1px solid black;
margin-left: 25px;
border-radius: 5px;
font-style: italic;
}

h1.title {
  font-weight: bold;
}

</style>

\

For the final project, you will be expected to download, wrangle and analyze a data set of your own choosing. You can use a data set that you've put together for your thesis/dissertation.  You can also use publicly available data such as the United States Census.  Or you may want to combine publicly available data with data you've collected on your own. 

This guide is a reference tool describing online sources that provide data typically in a csv or shapefile format at a local scale. The data sources are organized by topic or theme.


**Comprehensive neighborhood data sources**

* [PolicyMap](https://ucdavis.policymap.com/maps) 
    + PolicyMap is a data and mapping resource that provides a wealth of policy, education, socioeconomic, demographic, health and neighborhood dimension data at various geographic scales including census tracts.  As UC Davis affiliates, we have access to the subscription or paid edition. You either need to be on campus or on [VPN](https://www.library.ucdavis.edu/service/connect-from-off-campus/) setup.  Although allowing the user to upload and map shapefiles, the site does not all you to download shapefiles.

* [Social Explorer](https://www.socialexplorer.com/)
    + Similar to PolicyMap, but focuses more on historical data, including Census data going back to the first Census in 1790. Also like PolicyMap, UC Davis affiliates have access to all Social Explorer tools. Focuses on census data, but provides data from other sources, including religious organizations.

**Decennial Census and American Community Survey**

The Census represents the most comprehensive source for demographic and socioeconomic data at the census tract level.  You can download tract level data from the following sources

* [American Fact Finder](https://factfinder.census.gov/faces/nav/jsf/pages/index.xhtml)

* [Social Explorer](https://www.socialexplorer.com/)

* [National Historical Geographic Information System](https://www.nhgis.org/)

* [PolicyMap](https://ucdavis.policymap.com/maps) 

You can download Census tract shapefiles (and other spatial data formats) at the following sites

* [United States Census](https://www.census.gov/geo/maps-data/data/cbf/cbf_tracts.html)

* [National Historical Geographic Information System](https://www.nhgis.org/)

If you want to evaluate tract characteristics over an extensive time period, you'll need to account for changes in tract boundary definitions.  Social explorer allows you to get historical census data in 2010 tract boundaries.  Other resources for getting data normalized to a certain year's boundary definition include

* [United States Census](https://www.census.gov/geo/maps-data/data/relationship.html)
    + The U.S. Census provides relationship files that allow you to normalize data to a specific year for the tract (and other small scale geographies).
    
* [Geolytics Neighborhood Change Database](http://demographics.geolytics.com/ncdb2010/login.aspx)
    + As a UC Davis affiliate, you have access to this paid dataset.  Just be on campus or use [VPN](https://www.library.ucdavis.edu/service/connect-from-off-campus/) to access.  The site allows you to download tract data going back to 1970 normalized to 2010 boundaries.
    
* [Longitudinal Tract Database](https://s4.ad.brown.edu/projects/diversity/researcher/bridging.htm)
    + This site's tools are free to the public.  In addition to providing preloaded census data normalized to a certain boundary year, the site provides crosswalks that allow you to normalize *any* tract level data.
    
NHGIS is part the vast umbrella known as the Integrated Public Use Microdata Series (IPUMS). IPUMS provides census and survey data from around the world integrated across time and space.  If you are interested in downloading individual level Census data (typically a 5% sample), check out [IPUMS USA](https://usa.ipums.org/usa/).  Unsurprisingly, there is also an [IPUMS CPS](https://cps.ipums.org/cps/), which provides individual level data from the Current Population Survey. All the IPUMS brands can be found on their [homepage](https://cps.ipums.org/cps/). Similar to the Census API, R can tap into IPUMS data directly through the **ipumsr** package. Check out one of its vignettes [here](https://cran.r-project.org/web/packages/ipumsr/vignettes/ipums.html).

**Other R packages for bringing in data**

* ICPSR: A lot of social science data are stored in the [Inter-university Consortium for Political and Social Research](https://www.icpsr.umich.edu/icpsrweb/) at the University of Michigan.  The R package [**icpsrdata**](https://www.icpsr.umich.edu/icpsrweb/) allows you to grab ICPSR data sets directly through R.

* OECD: If you need some international data, the [Organization for Economic Cooperation and Development](http://www.oecd.org/unitedstates/), an intergovernmental economic organization with 36 member countries, can help.  And R has a package for getting data, aptly named [OECD](https://cran.r-project.org/web/packages/OECD/index.html).


**Health characteristics**

The following data sets provide health related indicators at small scale geographies.

* [500 Cities: Local Data for Better Health](https://www.cdc.gov/500cities/).
    + This dataset, put together by the Centers for Disease Control and Prevention (CDC), provides city- and census tract-level small area estimates for chronic disease risk factors, health outcomes, and clinical preventive service use for the largest 500 cities in the United State.

* [CalEnviroScreen](https://oehha.ca.gov/calenviroscreen/report/calenviroscreen-30)  
    + Developed by California's Office of Environmental Health Hazard Assessment, CalEnviroScreen is is a screening tool that evaluates the burden of pollution from multiple sources in California communities while accounting for potential vulnerability to the adverse effects of pollution.  You can also download a shapefile of census tracts with these indicators [here](https://oehha.ca.gov/calenviroscreen/maps-data/download-data).
  

**Department of Housing and Urban Development (HUD)**

HUD offers a plethora of lower geographic scale data sets on a variety of housing, built environment, and socioeconomic indicators for the country or select Metropolitan Areas.  The main data splash page for the HUD is located [here](https://www.huduser.gov/portal/pdrdatas_landing.html).  Many of the data sets provide indicators of HUD funding, such as tracts that qualify for [Low-Income Housing Tax Credit](https://www.huduser.gov/portal/datasets/qct.html).  They also provide [Fair Area Market Rents](https://www.huduser.gov/portal/datasets/fmr/smallarea/index.html) at the zip code level, and georeferenced data located on their [eGIS open data portal](https://hudgis-hud.opendata.arcgis.com/), which includes point level information.


**Work commuting patterns**

* [OnTheMap](https://onthemap.ces.census.gov/)
    + OnTheMap is an application that shows where workers are employed and where they live. The data come from the [Longitudinal Employer-Household Dynamics](https://lehd.ces.census.gov/) Program, specifically from their Origin-Destination Employment Statistics (LODES).  OnTheMap also provides reports on age, earnings, industry distributions, race, ethnicity, educational attainment, and sex.  

**Eviction rates**

* [Eviction Lab](https://evictionlab.org/)
    + The Eviction Lab at Princeton University has built the first nationwide database of evictions aggregated to various geographic scales including block groups and tracts. It as an open-source resource, available to researchers, citizen organizers, and journalists to use, disseminate, and even augment with new data that they collect.

**Gentrification**

* [Urban Displacement Project](http://www.urbandisplacement.org/)
    + Developed by researchers at UC Berkeley, the Urban Displacement Project provides census tract level typologies of gentrification in the City of Portland, Southern California, and the San Francisco Bay Area.  They also provide the underlying data that they used to create the typologies.
    
**Opportunity Mapping Indices**

Opportunity mapping is used to illustrate where opportunity rich communities exist (and assess who has access to these communities) and to examine where disadvantage or opportunity poor communities are located.  Rather than present neighborhood characteristics separately, opportunity mapping consolidates characteristics into single indices of opportunity.  This is fast becoming a popular tool in the applied and policy worlds, with indicators being developed for an assortment of different neighborhood dimensions. The indices themselves may not be as relevant for you given the type of question you want to answer; however, all of these indices rely on a consolidation of a bunch of variables that are not available in a clean format at a local level, and many of the websites below provide these variables for download.

* [Regional Opportunity Index (ROI)](https://interact.regionalchange.ucdavis.edu/roi/index.html)
    + The ROI is developed and maintained by the UC Davis Center for Regional Change.  The ROI is specific to California tracts.  The site provides mapping features but also allows you to download the indices and the underlying data.

* [Diversity Data Kids](http://www.diversitydatakids.org/getdata)
    + The site provides opportunity indices specific to the school-aged population.

* [Neighborhood Atlas](https://www.neighborhoodatlas.medicine.wisc.edu/)
    + Another index, this time the Area Deprivation Index, developed by the Health Resources and Services Administration.  You'll need to sign up for a free account to download the data.

* [Social Vulnerability Index](https://svi.cdc.gov/SVIDataToolsDownload.html)
    + An index maintained by the CDC, it uses Census data to determine tracts that are socially vulnerable to the after effects of a hazardous event.

**Opportunity Atlas**

The Opportunity Atlas is an an interactive, map-based tool that can trace the root of outcomes, such as poverty and incarceration, back to the neighborhoods in which children grew up.  The atlas, in a nutshell, shows “Which neighborhoods in America offer children the best chances of climbing the income ladder?” You can view the tool and download all the census tract data [here](https://www.opportunityatlas.org/).


**Los Angeles Neighborhood Data for Social Change**

A data warehouse created by the [University of Southern California](https://socialinnovation.usc.edu/) that collects a bunch of health, demographic, built environment, and socioeconomic variables at the neighborhood level for the County of Los Angeles.  Check the site out [here](https://data.myneighborhooddata.org/stories/s/xs7g-jqmb).

**Big Data**

* [Airbnb](http://insideairbnb.com/get-the-data.html): Provides csv files containing detailed information on data on airbnb hosts.  The data are in latitude/longitude.  They don't provide historical data.

* Bikesharing: Web sites providing public use data on bikesharing.  Provides station-to-station data.
    + [San Francisco](https://www.fordgobike.com/system-data).  
    + [New York City](https://www.citibikenyc.com/system-data) 
    + [Chicago](https://www.divvybikes.com/system-data). 
    + [Washington D.C.](https://www.capitalbikeshare.com/system-data)

* [OpenStreetMaps](https://ropensci.github.io/osmdata/).  **osmdata** is an R package for downloading OpenStreetMaps data.  The site provides a couple of vignettes on using the package.

* [Array of things](https://aot-file-browser.plenar.io/).  The City of Chicago installed modular sensor boxes around Chicago to collect real-time data on the city’s environment, infrastructure, and activity for research and public use. 

* [Zillow](https://www.zillow.com/research/data/). Provides housing price data at the metro, city and zipcode levels.  R has a [package](https://cran.r-project.org/web/packages/ZillowR/index.html) for downloading Zillow data directly.

* [Yelp](https://www.yelp.com/dataset).  A public use dataset put together by Yelp specifically for personal and educational purposes, but has been used in academic and applied research.  You can use the Yelp API, and here is a [tutorial](https://billpetti.github.io/2017-12-23-use-yelp-api-r-rstats/), but there are some restrictions, specifically getting an access ID and creating your own app.  Here is another [tutorial](https://github.com/richierocks/yelp) for a specific R package that uses the Yelp API.

* [Uber](https://movement.uber.com/?lang=en-US).  A public use dataset that provides anonymized information on Uber usage in select US cities.  You'll need to sign up for an account or use your Facebook or Google account.

* [Twitter](https://apps.twitter.com/). Twitter provides access to a sample of their tweets.  You'll need to register for an API.  Here are some guides to collect and manage tweets in R: [here](https://www.earthdatascience.org/courses/earth-analytics/get-data-using-apis/use-twitter-api-r/), [here](https://cfss.uchicago.edu/webdata002_twitter_exercise.html), and [here](https://cran.r-project.org/web/packages/rtweet/vignettes/intro.html).


**Open data portals**

Many city, county and even state governments maintain open data portals.  These portals provide various data sets held and maintained by the public sectors.  Some of the data are measured at a fine spatial scale, going doing to latitude/longitude.  

There are a couple of sites that maintain open data portal directories, including

* [Data.gov](https://www.data.gov/open-gov/)

* [OpenDataSoft](https://www.opendatasoft.com/a-comprehensive-list-of-all-open-data-portals-around-the-world/#/united-states)

* [US City Open Data Census](http://us-cities.survey.okfn.org/)

Here are links to various open data portals in US cities (updated 10/31/18)

*California*

* [Sacramento City](http://data.cityofsacramento.org/)

* [Sacramento County](http://data-sacramentocounty.opendata.arcgis.com/)

* [San Francisco City](https://datasf.org/opendata/)

* [Alameda County](https://data.acgov.org/)

* [Oakland City](https://data.oaklandnet.com/)

* [Oakland City](http://data.openoakland.org/)

* [Long Beach City](http://www.longbeach.gov/openlb/)

* [San Jose City](https://data.sanjoseca.gov/home)

* [Kern County](https://geodat-kernco.opendata.arcgis.com/)

* [Anaheim City](http://data-anaheim.opendata.arcgis.com/)

* [Riverside County](https://data.countyofriverside.us/)

* [Riverside County](http://data-countyofriverside.opendata.arcgis.com/)

* [Chula Vista City](http://chulavista-cvgis.opendata.arcgis.com/)

* [Los Angeles City](https://data.lacity.org/)

* [Los Angeles City](http://geohub.lacity.org/)

* [Los Angeles County](https://data.lacounty.gov/)

* [Los Angeles County](https://egis3.lacounty.gov/dataportal/)

* [Orange County](http://data-ocpw.opendata.arcgis.com/)

* [San Francisco City/County](https://datasf.org/)

* [Santa Clara County](http://prod-sccgov.opendata.arcgis.com/)

* [Santa Clara County](https://data.sccgov.org/)

* [San Diego City](https://data.sandiego.gov/)

* [Solano County](http://geohub-doitgis.opendata.arcgis.com/datasets)

* [California State](https://data.ca.gov/)

*Major Cities*

* [Boston](https://data.boston.gov/)

* [New York](https://data.ny.gov/)

* [New York](https://opendata.cityofnewyork.us/data/)

* [Chicago](https://data.cityofchicago.org/)

* [Philadelphia](https://www.opendataphilly.org/)

* [Detroit](https://data.detroitmi.gov/)

* [Balitmore](https://data.baltimorecity.gov/)

* [San Francisco City/County](https://datasf.org/)

* [Seattle](https://data.seattle.gov/)

* [Washington D.C.](http://opendata.dc.gov/)


**Looking for more data?**

* Google released a Beta site for a dataset search site akin to Google Scholar, Images, Books and so on.  Check it out [here](https://toolbox.google.com/datasetsearch)

* Kaggle is a crowd-sourced platform for all things data science.  This includes competitions, discussion forums, online tutorials, and most importantly, at least for the purpose of this guide, a repository of big data sources.  A lot of these data are not pertinent to this class, but some are; specifically, those with geographic information that allows you to connect data to geographic locations. Check out their datasets [here](https://www.kaggle.com/datasets).

* Google released a Beta site for a dataset search site akin to Google Scholar, Images, Books and so on.  Check it out [here](https://toolbox.google.com/datasetsearch).

* Kaggle is a crowd-sourced platform for all things data science.  This includes competitions, discussion forums, online tutorials, and most importantly, at least for the purpose of this guide, a repository of big data sources.  A lot of these data are not pertinent to this class, but some are; specifically, those with geographic information that allows you to connect data to geographic locations. Check out their datasets [here](https://www.kaggle.com/datasets).

* Esri provides a repository that many of its members use to store various big and open data all in shapefile format.  Check out what's available [here](http://hub.arcgis.com/pages/open-data).


***

Website created and maintained by [Noli Brazil](https://nbrazil.faculty.ucdavis.edu/)


