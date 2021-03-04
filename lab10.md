---
title: "Lab 10: Social Network Analysis"
subtitle: <h4 style="font-style:normal">CRD 230 - Spatial Methods in Community Research</h4>
author: <h4 style="font-style:normal">Professor Noli Brazil</h4>
date: <h4 style="font-style:normal">March 4, 2021</h4>
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
background-color: #DBDBDB;
padding: 10px;
border: 1px solid black;
margin-left: 25px;
border-radius: 5px;
font-style: italic;
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





For most of this quarter, we’ve conceptualized connectivity and dependence from a purely spatial  perspective. In this lab, we will examine how neighborhood linkages can be shaped by networks that transcend geographic connectivity. To do this, we will dive into the world of social network analysis (SNA). The objectives of this guide are as follows

1. Learn how to construct a social network object in R
2. Learn how to visualize a social network
3. Learn how to calculate node and network-level summary statistics 
4. Learn how to incorporate network connectivity in a spatial regression model
5. Learn how to create spatial network objects using the **sfnetworks** package

To help us accomplish these learning objectives, we will construct a social network linking census tracts in the City of Seattle based on [gang turfs](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1745-9125.2012.00281.x). The material covered in this lab follows closely the material covered in Handout 8.

<div style="margin-bottom:25px;">
</div>
## **Installing and loading packages**
\

 We’ll be using the following new packages in this lab. Install them using `install.packages()`.
 

```r
install.packages("tidygraph")
install.packages("ggraph")
install.packages("igraph")
install.packages("visNetwork")
```

Load in all necessary  packages for this lab.


```r
library(tidyverse)
library(sf)
library(tmap)
library(spdep)
library(spatialreg)
library(knitr)
library(tidygraph)
library(ggraph)
library(igraph)
library(visNetwork)
```


<div style="margin-bottom:25px;">
</div>
## **Bring in census tract data**
\

We will be using the shapefile *seattle_census_tracts_2010.shp*. This file contains violent crime counts and rates between 2014 and 2017 by census tract in Seattle, WA.  It also contains demographic and socioeconomic data from the 2012-16 American Community Survey. The record layout for the shapefile's attribute table is located [here](https://raw.githubusercontent.com/crd230/data/master/seattle_record_layout.txt).

I zipped up the files associated with the shapefile and uploaded the file onto Github.  Download the file, unzip it, and bring it into R using the following code.


```r
download.file(url = "https://raw.githubusercontent.com/crd230/data/master/seattle_census_tracts_2010.zip", destfile = "seattle_census_tracts_2010.zip")
unzip(zipfile = "seattle_census_tracts_2010.zip")

sea.tracts <- st_read("seattle_census_tracts_2010.shp", stringsAsFactors = FALSE)
```

We're going to examine the association between structural neighborhood characteristics and violent crime rates in the City of Seattle.  Specifically, we will examine the association between violent crime and residential mobility, concentrated disadvantage, immigrant concentration, population density, percent of housing units that are owner occupied, and population density.  Let's create the concentrated disadvantage (mean standardized values of percent poverty, percent unemployed, percent non-Hispanic black, percent under 18 years old, and percent on public assistance) and immigrant concentration (mean standardized values of percent Hispanic and percent foreign born) indices using the following code.  We covered these functions in [Lab 6b](https://crd230.github.io/lab6b.html#Standardize_and_Average).


```r
sea.tracts.std <- sea.tracts %>%
                  st_drop_geometry() %>%
                  mutate_at(~(scale(.) %>% as.vector(.)), 
                    .vars = vars(ppov, unemp, pnhblack, pund18, pwelfare)) %>%
                  mutate(concd = (ppov+unemp+pnhblack+pund18+pwelfare)/5, 
                         immc = (pfb+phisp)/2) %>%
                  select(GEOID10, concd, immc)

#merge indices into main analysis file
sea.tracts <- left_join(sea.tracts, sea.tracts.std, by = "GEOID10")
```

<div style="margin-bottom:25px;">
</div>
## **Bring in network data**
\

There are numerous network analysis packages in R.  We'll be using the packages **igraph**, perhaps the most relied upon social network package in R (that or the suite of [statnet packages](http://www.statnet.org/)) and **tidygraph** and **ggraph**, which leverage the power of **igraph** in a manner consistent with the tidyverse workflow we're now accustomed to. [Here](https://www.data-imaginist.com/2018/tidygraph-1-1-a-tidy-hope/) is a vignette of **tidygraph**. [Here](https://igraph.org/redirect.html) is the **igraph** website and [lecture slides](https://www.r-project.org/conferences/useR-2008/slides/Csardi.pdf) providing a brief background on the package. Finally, find **ggraph** vignettes from its creator [here](https://cran.r-project.org/web/packages/ggraph/vignettes/Edges.html), [here](https://cran.r-project.org/web/packages/ggraph/vignettes/Layouts.html), and [here](https://cran.r-project.org/web/packages/ggraph/vignettes/Nodes.html). In this lab, we will just scratch the surface on network analysis in R, so I would recommend exploring these resources if you want to use SNA in your research.  

The two primary components of networks are nodes or actors, and the connections between them, which are known as edges or ties.  There are two ways to construct a network graph.

<div style="margin-bottom:25px;">
</div>
### **Sociomatrix**
\


First, you can use sociomatrices, also known as adjacency matrices.  An adjacency matrix is a square matrix in which the column and row names are the nodes of the network. Within the matrix a 1 indicates that there is a connection between the nodes (edge), and a 0 indicates no connection. If the network is weighted, the values of the cells will measure the degree to which the node in the row interacts with the node in the column. Let's bring in the sociomatrix for neighborhood gang affiliation in Seattle. I created this matrix outside of R and uploaded it onto GitHub.


```r
gang.matrix <- read_csv("https://raw.githubusercontent.com/crd230/data/master/seattle_gang_tracts.csv")
```

The matrix contains census tracts as rows and columns. The matrix does not distinguish between which specific gangs are in which neighborhoods - a value of 1 indicates that the neighborhoods on the row and column are in the same gang turf.  Note that a neighborhood cannot be associated with multiple gangs (i.e. a neighborhood can only belong to one gang turf). The gang turf network is undirected. An adjacency matrix is always symmetric if you are dealing with an undirected network. Note that these data are outdated (2017), and thus should not be used in an analysis of contemporary data.  Moreover, the data were compiled via newspapers articles and social media, and therefore may contain errors.

<div style="margin-bottom:25px;">
</div>
### **Node and edge lists**
\

The second way to construct a network object is to use a node list and an edgelist. An edgelist is a data frame that contains a minimum of two columns, one column of nodes that are the source of a connection and another column of nodes that are the target of the connection. The nodes in the data are identified by unique IDs. If the distinction between source and target is meaningful, the network is directed. If the distinction is not meaningful, the network is undirected.  In our case study, our network is undirected. Let's bring in the edgelist, which I uploaded onto Github.


```r
sea.edges <- read_csv("https://raw.githubusercontent.com/crd230/data/master/edges.csv")
```

Take a look


```r
glimpse(sea.edges)
```

```
## Rows: 90
## Columns: 2
## $ from <dbl> 5, 5, 21, 21, 22, 22, 22, 23, 23, 23, 23, 23, 23, 23, 24, 24, 24,…
## $ to   <dbl> 104, 136, 50, 51, 36, 40, 46, 24, 36, 46, 48, 59, 64, 65, 36, 46,…
```

We also need to establish a node list, which is a data frame with a column that lists the node IDs for all nodes in the network regardless of whether they have a connection to other network nodes.  Let's bring in the node list.


```r
sea.nodes <- read_csv("https://raw.githubusercontent.com/crd230/data/master/nodes.csv")
```

Take a gander


```r
glimpse(sea.nodes)
```

```
## Rows: 140
## Columns: 2
## $ id    <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 1…
## $ label <dbl> 26700, 26600, 800, 700, 600, 500, 402, 401, 300, 200, 100, 26500…
```

The node list contains the *id* that defines the connection in the *to* and *from* columns in the edgelist and the tract FIPS code associated with the *id*.

<div style="margin-bottom:25px;">
</div>
## **Create the network object**
\

<div style="margin-bottom:25px;">
</div>
### **Sociomatrix**
\

We can create a network object from the adjacency matrix using the function  `graph_from_adjacency_matrix()`, which is a part of the  **igraph** package.  We'll need to clean up this matrix a bit before we can input it into `graph_from_adjacency_matrix()`. First, we want just 0 and 1 values in the matrix cells, so get rid of the column *X1*, which provides the tract IDs.  


```r
gang.matrix <- gang.matrix %>%
                select(-X1)
```

Next, designate row names using the column names of the data frame, which are the tract IDs.


```r
rownames(gang.matrix) <- colnames(gang.matrix)
```

Now we can use `graph_from_adjacency_matrix()` to create an **igraph** network object.  The function `graph_from_adjacency_matrix()` takes in a *matrix* object, so we'll need to use `as.matrix()` to convert *gang.matrix* to a matrix, which is currently a tibble.  


```r
class(gang.matrix)
```

```
## [1] "tbl_df"     "tbl"        "data.frame"
```

We'll also need to specify that the network is undirected using the argument `mode = "undirected"`


```r
gang.network.ig <- graph_from_adjacency_matrix(as.matrix(gang.matrix), 
                                               mode = "undirected")
```

We'll want to convert the **igraph** network object into a tidy network object so it can cohere with all the tidy functions we've learned in this class.  To do this, use the function `as_tbl_graph()`


```r
gang.network1<-as_tbl_graph(gang.network.ig)
```

<div style="margin-bottom:25px;">
</div>
### **Node and edge lists**
\

We create a network from an edge list and a node list using the function `tbl_graph()`, which is a part of the **igraph** package. The node list *sea.nodes* is a regular tibble with two columns indicating a generic ID from 1 to 140 for each tract and the tract FIPS code. What is the purpose of the ID of 1 to 140? Because the function `tbl_graph()`,  which creates a network object from node and edge lists, assumes that there should be nodes for *every integer between* `min(node$id)` and `max(node$id)`, which is not the case if we use the FIPS tract code. 

In `tbl_graph()`, we specify the nodes and edges using the `nodes =` and `edges =` arguments, respectively. We use the argument `directed = FALSE` to tell R that we want to create an undirected network. 


```r
gang.network2 <- tbl_graph(nodes = sea.nodes, edges = sea.edges, directed = FALSE)
```

The output for *gang.network2* is similar to that of a normal tibble.  


```r
gang.network2
```

```
## # A tbl_graph: 140 nodes and 90 edges
## #
## # An undirected simple graph with 101 components
## #
## # Node Data: 140 x 2 (active)
##      id label
##   <dbl> <dbl>
## 1     1 26700
## 2     2 26600
## 3     3   800
## 4     4   700
## 5     5   600
## 6     6   500
## # … with 134 more rows
## #
## # Edge Data: 90 x 2
##    from    to
##   <int> <int>
## 1     5   104
## 2     5   136
## 3    21    50
## # … with 87 more rows
```

The object *gang.network2* is separated into node and edge tables. Edge Data is a table of all relationships between *from* and *to*. Node Data is a table containing all of the IDs and FIPS codes of the tracts even if they do not appear in the Edge Data table (not all 140 tracts are part of a gang turf).  

We find that there are 140 nodes (census tracts) and 90 edges. The first six rows of “Node Data” and the first three of “Edge Data” are also shown. 

Run the command `class()` on *gang.network2* and you'll find that **tidygraph** sub classes **igraph** with the *tbl_graph* class and thus presents the network in a tidy manner. 


```r
class(gang.network2)
```

```
## [1] "tbl_graph" "igraph"
```


<div style="margin-bottom:25px;">
</div>
## **Visualizing your network**
\

There are a number of ways to visualize your network. The most common approach is to graph the network's nodes and edges onto a two-dimensional space.  The tidy package for graphing networks is `ggraph`, which is an extension of **ggplot2**, making it easier to carry over the basic `ggplot()` skills we learned in [Lab  2](https://crd230.github.io/lab2.html#Summarizing_variables_using_graphs) to the creation of network plots in this lab.

Let's plot the Seattle neighborhood gang turf network using `ggraph()`


```r
gang.network2 %>%
  ggraph(layout = "fr") + 
  geom_edge_link() + 
  geom_node_point() + 
  ggtitle("Gang Turf Network in Seattle, WA")
```

![](lab10_files/figure-html/unnamed-chunk-18-1.png)<!-- -->

As you can see, the structure of the command `ggraph()` is similar to that of `ggplot()` with the separate layers added with the `+` sign.  The first step is to establish a layout using the argument `layout =` in  `ggraph()`. The layout parameter specifies the algorithm to use to display the graph. In other words, a layout is the vertical and horizontal placement of nodes when plotting the graph structure. The "fr" layout is part of the graph layouts package and is always a safe choice since it is deterministic and produces nice layouts for almost any graph. Other layout algorithms are described [here](https://www.rdocumentation.org/packages/ggraph/versions/2.0.4/topics/layout_tbl_graph_igraph). You can get a deeper look into the other ways you can display the network in this [guide](https://www.data-imaginist.com/2017/ggraph-introduction-layouts/). Note that there isn't anything geographic about the above plot - the location of the points in the plot are not linked or associated with anything referenced on the earth's surface.

The functions `geom_edge_link()` and `geom_node_point()` plots the edges and nodes, respectively.  And there are arguments within these commands to stylize and alter their graphical features.  Network visualizations are cool if you've got a small enough data set.  Check out the **ggraph** [vignettes](https://cran.r-project.org/web/packages/ggraph/index.html) to find out how you can improve your graphics. 


Just like with interactive maps, you can also make interactive network graphs.  You can do this by using the package **visNetwork**.  Use the function `toVisNetworkData()` to initialize the interactive graph. The argument `idToLabel = FALSE` tells R not to use the column *id* to identify the nodes.  It will instead grab the column *label*


```r
dataVis <-  toVisNetworkData(gang.network2,idToLabel = FALSE)
```

You then create the interactive network using the function `visNetwork()`.  Similar to `ggraph()` you can make this interactive visual [prettier](https://cran.r-project.org/web/packages/visNetwork/vignettes/Introduction-to-visNetwork.html).


```r
visNetwork(nodes = dataVis$nodes, edges = dataVis$edges, width = "100%",
           main = "Gang Turf Network in Seattle Neighborhoods") %>%
  addFontAwesome() %>%
  visOptions(highlightNearest = list(enabled = T, hover = T), nodesIdSelection = T) %>%
  visInteraction(navigationButtons = TRUE)
```

<!--html_preserve--><div id="htmlwidget-07ed9ceb15a498248173" style="width:100%;height:480px;" class="visNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-07ed9ceb15a498248173">{"x":{"nodes":{"id":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140],"label":[26700,26600,800,700,600,500,402,401,300,200,100,26500,26400,26300,26100,26001,1702,4302,4301,7402,10002,10001,11002,10402,10702,11402,11401,25302,12100,12000,11900,10900,10800,10600,10500,10300,1701,7401,10200,10100,9900,9800,9702,9701,9600,10401,10701,11001,9500,9400,9300,9200,9100,9000,8900,8800,8700,11800,11700,11600,11500,11300,11200,11102,11101,8600,8500,8400,8300,8200,8100,8002,8001,7900,7800,7700,7600,7500,7300,7200,7100,7000,6900,6800,6700,6600,6500,6400,6300,6200,6100,6000,5801,5700,5600,5400,5302,5301,5200,5100,5000,4900,4800,4700,4600,4500,4400,4200,4100,4000,3900,3800,5900,5802,3600,3500,3400,3300,3200,3100,3000,2900,2800,2700,2600,2500,2400,2200,2100,2000,1900,1800,1600,1500,1400,1300,1200,1100,1000,900]},"edges":{"from":[5,5,21,21,22,22,22,23,23,23,23,23,23,23,24,24,24,24,24,24,25,25,25,25,25,25,25,31,31,33,33,33,33,33,33,34,34,35,35,35,35,36,36,36,36,36,36,36,40,41,46,46,46,46,46,47,48,48,48,48,50,50,50,53,53,53,54,54,54,54,56,56,56,56,57,57,58,58,58,59,59,64,66,71,71,72,74,98,98,104],"to":[104,136,50,51,36,40,46,24,36,46,48,59,64,65,36,46,48,59,64,65,33,34,35,41,42,47,61,58,59,34,35,41,42,47,61,47,61,41,42,53,54,39,40,46,48,60,64,65,46,42,48,58,59,64,65,61,58,59,64,65,51,54,55,54,66,67,55,57,66,67,57,74,75,76,74,76,59,64,65,64,65,65,67,72,80,80,76,104,107,136]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot"},"manipulation":{"enabled":false},"interaction":{"hover":true,"navigationButtons":true}},"groups":null,"width":"100%","height":null,"idselection":{"enabled":true,"style":"width: 150px; height: 26px","useLabels":true,"main":"Select by id"},"byselection":{"enabled":false,"style":"width: 150px; height: 26px","multiple":false,"hideColor":"rgba(200,200,200,0.5)","highlight":false},"main":{"text":"Gang Turf Network in Seattle Neighborhoods","style":"font-family:Georgia, Times New Roman, Times, serif;font-weight:bold;font-size:20px;text-align:center;"},"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)","iconsRedraw":true,"highlight":{"enabled":true,"hoverNearest":true,"degree":1,"algorithm":"all","hideColor":"rgba(200,200,200,0.5)","labelOnly":true},"collapse":{"enabled":false,"fit":false,"resetHighlight":true,"clusterOptions":null,"keepCoord":true,"labelSuffix":"(cluster)"},"tooltipStay":300,"tooltipStyle":"position: fixed;visibility:hidden;padding: 5px;white-space: nowrap;font-family: verdana;font-size:14px;font-color:#000000;background-color: #f5f4ed;-moz-border-radius: 3px;-webkit-border-radius: 3px;border-radius: 3px;border: 1px solid #808074;box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

<br>

The widget will allow you to pick a neighborhood and highlight its ego network.


<div style="margin-bottom:25px;">
</div>
## **Node characteristics**
\

Let's now calculate the local network measures covered in Handout 8.  In order to do this, we create node-level variables within the graph object *gang.network2*.  Let’s look  at the output for *gang.network2* again.


```r
gang.network2
```

```
## # A tbl_graph: 140 nodes and 90 edges
## #
## # An undirected simple graph with 101 components
## #
## # Node Data: 140 x 2 (active)
##      id label
##   <dbl> <dbl>
## 1     1 26700
## 2     2 26600
## 3     3   800
## 4     4   700
## 5     5   600
## 6     6   500
## # … with 134 more rows
## #
## # Edge Data: 90 x 2
##    from    to
##   <int> <int>
## 1     5   104
## 2     5   136
## 3    21    50
## # … with 87 more rows
```

Notice the text *Node Data: 140 x 2 (active)*.  This indicates that the Node table is active and any manipulations of the graph object will be done on this table. What if you wanted to manipulate the Edges table? You will need to use the `activate()` function, which is a part of the **tidygraph** package.


```r
gang.network2 %>%
  activate(edges)
```

```
## # A tbl_graph: 140 nodes and 90 edges
## #
## # An undirected simple graph with 101 components
## #
## # Edge Data: 90 x 2 (active)
##    from    to
##   <int> <int>
## 1     5   104
## 2     5   136
## 3    21    50
## 4    21    51
## 5    22    36
## 6    22    40
## # … with 84 more rows
## #
## # Node Data: 140 x 2
##      id label
##   <dbl> <dbl>
## 1     1 26700
## 2     2 26600
## 3     3   800
## # … with 137 more rows
```

You'll see now that the Edge Data is active. The function `activate()` allows R to know which of the two tables (nodes or edges) to perform further transformations on (the node table is always the default). And because we are in the **tidyverse**, manipulations of the tables take on all the tidy functions we've learned throughout this class.  For example, let's filter out the nodes that don't have an edge.  We use the function `filter()`, which we've used extensively throughout this class.


```r
gang.network.connected <- gang.network2 %>%
  # Remove isolated nodes
  activate(nodes) %>%
  filter(!node_is_isolated())
```

The command `node_is_isolated()` is a **tidygraph** function that identifies the nodes that do not have a link and the `!` sign indicates not, which means when plugged into `filter()`, remove the nodes that have a `TRUE` for `node_is_isolated()`.  We get a network that contains only the 43 tracts that are a part of a gang turf.


```r
gang.network.connected
```

```
## # A tbl_graph: 43 nodes and 90 edges
## #
## # An undirected simple graph with 4 components
## #
## # Node Data: 43 x 2 (active)
##      id label
##   <dbl> <dbl>
## 1     5   600
## 2    21 10002
## 3    22 10001
## 4    23 11002
## 5    24 10402
## 6    25 10702
## # … with 37 more rows
## #
## # Edge Data: 90 x 2
##    from    to
##   <int> <int>
## 1     1    41
## 2     1    43
## 3     2    19
## # … with 87 more rows
```

Now that we know how to activate nodes for manipulation, let's run through the measures that characterize their connectedness.

<div style="margin-bottom:25px;">
</div>
### **Centrality**
\

One of the most popular node characteristics is centrality. The higher the centrality, the more central the node. The definition of centrality is pretty broad.  As such, there are several measures of centrality.  Let's calculate the three centrality measures covered in Handout 8. The **tidygraph** functions that calculate centrality take on the form `centrality_`.  First, there is degree centrality, which captures the number of relationships (edges) that a node has.  Use the function `centrality_degree()` within `mutate()` to create a variable named *degree* that provides node-level degree centrality.  Remember, this is a node measure, so make sure the nodes table is activated within your network object.


```r
gang.network2 <- gang.network2 %>%
                activate(nodes) %>%
                mutate(degree = centrality_degree())
```

The column *degree* is a part of the node table in *gang.network2*.


```r
gang.network2
```

```
## # A tbl_graph: 140 nodes and 90 edges
## #
## # An undirected simple graph with 101 components
## #
## # Node Data: 140 x 3 (active)
##      id label degree
##   <dbl> <dbl>  <dbl>
## 1     1 26700      0
## 2     2 26600      0
## 3     3   800      0
## 4     4   700      0
## 5     5   600      2
## 6     6   500      0
## # … with 134 more rows
## #
## # Edge Data: 90 x 2
##    from    to
##   <int> <int>
## 1     5   104
## 2     5   136
## 3    21    50
## # … with 87 more rows
```

We can create a degree centrality plot like the one shown in Figure 10 in Handout 8 using our new friend `ggraph()`.  We specify within `geom_node_point()` that we want to change the size and color of each node based on its degree.


```r
ggraph(gang.network2, layout = 'kk') + 
  geom_edge_link() + 
  geom_node_point(aes(size = degree, colour = degree)) + 
  scale_color_continuous(guide = 'legend') + 
  theme_graph()
```

![](lab10_files/figure-html/unnamed-chunk-27-1.png)<!-- -->

Making nice graphs of networks that are disconnected like *gang.network2* can be difficult.  If the artist in you is calling out, you can make a nice visual using only nodes that are connected.  For example, here is a degree centrality plot for the *gang.network.connected* network with tract labels and a title.  


```r
#create degree variable
gang.network.connected <- gang.network.connected %>%
  mutate(degree = centrality_degree()) 

ggraph(gang.network.connected, layout = "nicely") + 
  geom_edge_diagonal(alpha = 0.2) + 
  geom_node_point(aes(size = degree)) + 
  scale_color_brewer(palette = "Set1", name = "Type") +
  geom_node_text(aes(label = label), size = 2.5, repel = TRUE) +
  theme_graph() +
  theme(plot.background = element_rect(fill = "#f8f2e4")) +
  labs(title = "Gang Turf Degree Centrality in Seattle Neighborhoods, 2017",
       size = "Degree",
       caption = "CRD 230\n Data source: Seattle Police Department")
```

![](lab10_files/figure-html/unnamed-chunk-28-1.png)<!-- -->


Another measure of centrality is betweenness, which captures the number of shortest paths that go through a node. Use the function `centrality_betweenness()` to create a node-level betweenness variable in *gang.network2*'s node table.


```r
gang.network2 <- gang.network2 %>%
                activate(nodes) %>%
                mutate(betweenness = centrality_betweenness())
```

We then plot node betweenness using `ggraph()` again.


```r
gang.network2 %>% 
  ggraph(layout = 'kk') + 
  geom_edge_link() + 
  geom_node_point(aes(size = betweenness, colour = betweenness)) + 
  scale_color_continuous(guide = 'legend') + 
  theme_graph()
```

![](lab10_files/figure-html/unnamed-chunk-30-1.png)<!-- -->

The third centrality measure covered in Handout 8 is closeness. Use `centrality_closeness()` within `mutate()` to create the variable *closeness*


```r
gang.network2 <- gang.network2 %>%
                activate(nodes) %>%
                mutate(closeness = centrality_closeness())
```

Then plot.


```r
gang.network2 %>% 
  ggraph(layout = 'kk') + 
  geom_edge_link() + 
  geom_node_point(aes(size = closeness, colour = closeness)) + 
  scale_color_continuous(guide = 'legend') + 
  theme_graph()
```

![](lab10_files/figure-html/unnamed-chunk-32-1.png)<!-- -->



<div style="margin-bottom:25px;">
</div>
## **Network characteristics**
\


You've successfully created a network object and visualized it. You then measured its node-level characteristics.  Next, let's summarize the overall network. We'll go through all the network-level measures covered in Handout 8. 

<div style="margin-bottom:25px;">
</div>
### **Average degree**
\

The first network measured covered in Handout 8 is the average degree. Average degree is just the mean degree across all nodes, or the average number of edges per node in the network. We already created the variable *degree*, which measures node-level degree centrality. We just take the mean of that variable. Heck, why not take the max, the median, and other summary statistics. To do this, we activate the nodes table, pipe it into the function `as_tibble()` to transform the table into a tibble, and use the function `summarize()` to calculate summary statistics.



```r
gang.network2 %>%
  activate(nodes) %>%
  as_tibble() %>%
  summarize(mean = mean(degree),
            max = max(degree),
            median = median(degree)) %>%
  kable()
```



|     mean| max| median|
|--------:|---:|------:|
| 1.285714|  10|      0|

The current active data can be extracted as a tibble using `as_tibble()`.  Here, we find that average number of tracts within a single gang turf is 1.29.  But, these data are likely skewed, with a large number of tracts not belonging to a gang turf. We can visualize this using a bar graph.



```r
gang.network2 %>%
            activate(nodes) %>%
            as_tibble() %>%
            ggplot() +
            geom_bar(aes(x =degree))
```

![](lab10_files/figure-html/unnamed-chunk-34-1.png)<!-- -->



<div style="margin-bottom:25px;">
</div>
### **Centralization**
\

We covered node-level measures of centrality above. There are also network-level measures of centrality. Network centralization is a measure of the unevenness of the centrality scores of actors in a network. It measures the extent to which the actors in a social network differ from one another in their individual centralities. Centralization ranges from zero, when every actor is just as central for whatever centrality score we are interested in, to 1, when one node is maximally central and all others are minimally central.

To measure network-level centrality, we use the suite of `centr_` functions in **igraph**.  To get network degree centrality, use the function `centr_degree()`.  The actual centrality value is stored in the scalar vector *centralization*, which we extract using the `$` symbol.


```r
centr_degree(gang.network2)$centralization
```

```
## [1] 0.0626927
```

Use `centr_betw()` to get network betweenness centrality. 


```r
centr_betw(gang.network2)$centralization
```

```
## [1] 0.01299105
```

Finally, `centr_clo()` to measure closeness centrality.


```r
centr_clo(gang.network2)$centralization
```

```
## [1] 0.001867652
```

Remember from the handout that there are many flavors of centrality (node and network level).  Degree, betweenness and closeness are the most popular flavors.

<div style="margin-bottom:25px;">
</div>
### **Clustering**
\

We might be interested in measuring the level of clustering in the network.   Broadly, clustering captures the degree to which nodes in a graph tend to cluster together.   One of the most common measures of clustering is transitivity, which refers to the extent to which the relations that ties nodes in a network are transitive. Perfect transitivity implies that, if neighborhood 1 is connected (through an edge) to neighborhood 2, and neighborhood 2 is connected to neighborhood 3, then neighborhood 1 is connected to neighborhood 3 as well.   We use the function `transitivity()` to measure transitivity, which is a part of the **igraph** package.


```r
transitivity(gang.network2)
```

```
## [1] 0.6966825
```

If neighborhood 1 is affiliated with neighborhood 2 and neighborhood 2 is affiliated with neighborhood 3 through a gang turf, then the probability that neighborhood 1 is affiliated with neighborhood 3 through a gang turf is 69.7 percent.

<div style="margin-bottom:25px;">
</div>
### **Diameter**
\

Another important network summary statistic is the diameter, which gives the length (in number of edges) of the longest geodesic path between any two nodes that are connected.


```r
diameter(gang.network2)
```

```
## [1] 6
```

The value 6 means that longest geodesic path to go from one neighborhood to another is 6.  We can get this path by using the `get_diameter()` function


```r
get_diameter(gang.network2)
```

```
## + 7/140 vertices, from eb5e498:
## [1] 34 25 35 54 57 56 75
```

What do the results tell us?

The mean distance of the shortest paths from one neighborhood to another can be calculated using the function `mean_distance()`


```r
mean_distance(gang.network2)
```

```
## [1] 2.468153
```

Note that this value only considers the connected neighborhoods.

<div style="margin-bottom:25px;">
</div>
### **Density**
\

The density of a graph is a measure of how many ties between actors exist compared to how
many ties between actors are possible.  To get the density of a network, use the function `graph.density()`, which is a part of the **tidygraph** package.


```r
graph.density(gang.network2) 
```

```
## [1] 0.009249743
```

The value is calculated using Equation 3 on page 13 of Handout 8.

<div style="margin-bottom:25px;">
</div>
## **Social and spatial network models**
\

We've visualized and summarized at the node and network levels the gang neighborhood network in Seattle.  Although our network is inherently spatial (e.g. gang turfs encompass a physical space, our network is a connection between neighborhoods across a city), everything we've done so far has been *aspatial*. Let's now go through some ways to incorporate "spatiality" into our network analyses (or, conversely, ways to incorporate SNA into our spatial analyses).

One simple thing we can do is map the node characteristics we calculated above to find out what our network looks like geographically and identify *where* the most influential or connected nodes are physically located. First, let's take out the node tibble from *gang.network2* using the function `as_tibble()`.  Remember, make sure the node tibble is active.


```r
node.centrality <-gang.network2 %>%
                  activate(nodes) %>%
                  as_tibble()
node.centrality
```

You'll find that the tibble contains the tract ID, FIPS tract code *label*, and measures of centrality.

Join the centrality measures from *node.centrality* to the spatial object *sea.tracts*.  We'll join using the FIPS tract code *TRACTCE10*, which we'll need to turn into a numeric in *sea.tracts*.



```r
sea.tracts<- sea.tracts %>%
            mutate(TRACTCE10 = as.numeric(TRACTCE10)) %>%
            left_join(node.centrality, by = c("TRACTCE10" = "label"))
```

We can then map degree centrality


```r
tm_shape(sea.tracts, unit = "mi") +
  tm_polygons(col = "degree", style = "jenks",palette = "Reds", 
              border.alpha = 0, title = "") +
  tm_scale_bar(breaks = c(0, 1, 2), text.size = 1, position = c("left", "bottom")) +
  tm_layout(main.title = "Gang network degree centrality",  main.title.size = 0.95, frame = FALSE, legend.outside = TRUE)
```

![](lab10_files/figure-html/unnamed-chunk-45-1.png)<!-- -->

What about betweenness centrality?


```r
tm_shape(sea.tracts, unit = "mi") +
  tm_polygons(col = "betweenness", style = "jenks",palette = "Reds", 
              border.alpha = 0, title = "") +
  tm_scale_bar(breaks = c(0, 1, 2), text.size = 1, position = c("left", "bottom")) +
  tm_layout(main.title = "Gang network betweenness centrality",  main.title.size = 0.95, frame = FALSE, legend.outside = TRUE)
```

![](lab10_files/figure-html/unnamed-chunk-46-1.png)<!-- -->

We can also calculate whether a node measure is spatially clustered using the Moran's I.  Let's do this for degree centrality.  Let's define a row standardized spatial weights matrix using Queen contiguity using the functions we learned in [Lab 7](https://crd230.github.io/lab7.html).


```r
seab<-poly2nb(sea.tracts, queen=T)
seaw<-nb2listw(seab, style="W", zero.policy = TRUE)
```

Then calculate Moran's I


```r
moran.mc(sea.tracts$degree, seaw, nsim=999)
```

```
## 
## 	Monte-Carlo simulation of Moran I
## 
## data:  sea.tracts$degree 
## weights: seaw  
## number of simulations + 1: 1000 
## 
## statistic = 0.63442, observed rank = 1000, p-value = 0.001
## alternative hypothesis: greater
```

What does the Moran's I value tell you about the spatial clustering of gang network degree centrality in Seattle tracts?

As discussed in Handout 8, many of the methods we learned in Labs 7 and 8 using a spatial weights matrix can be applied using a social network or sociomatrix.  In other words, the adjacency matrix can be plugged into a spatial regression framework - rather than a spatial weights matrix, we're dealing with a social network weights matrix.  This means we can apply the  methods we've used to measure and model spatial dependency to measure and model social dependency.  

You'll need to first convert *gang.matrix* into a row-standardized weights matrix using the function `mat2listw()`, which is a part of the **spdep** package. We also need to convert the tibble *gang.matrix* into a matrix using `as.matrix()`.


```r
gang.matrix.w <- mat2listw(as.matrix(gang.matrix), style="W")
```

We can then plot the connections


```r
centroids <- st_centroid(st_geometry(sea.tracts))
plot(st_geometry(sea.tracts), main = "Gang turf network")
plot.listw(gang.matrix.w, coords = centroids, add = T, col = "red")
```

![](lab10_files/figure-html/unnamed-chunk-50-1.png)<!-- -->

How does this map compare to, say, a map showing connections based on a queen contiguity spatial weights matrix?


```r
par(mfrow = c(1, 2))
plot(st_geometry(sea.tracts), main = "Gang turf network")
plot.listw(gang.matrix.w, coords = centroids, add = T, col = "red")
plot(st_geometry(sea.tracts), main = "Queen contiguity network")
plot.listw(seaw, coords = centroids, add = T, col = "red")
```

![](lab10_files/figure-html/unnamed-chunk-51-1.png)<!-- -->

It would be neat to combine `visNetwork()` with, say, `leaflet()` so that you can create an interactive network and map. I'm not smart enough to construct this, so I will leave this up to the super coders to handle.

You've created a weights matrix based on gang turf affiliation.  You can then plug this matrix into the spatial regression functions we covered in [Lab 8](https://crd230.github.io/lab8.html#Spatial_lag_model) to find out whether gang network dependency has an effect on violent crime rates above and beyond neighborhood structural characteristics.  For example, use `lagsarlm()` to run a social network lag model.  You'll need to add the argument `zero.policy=TRUE` because of the isolates in the city.  We regress the log violent crime rate *lvcmrt1417* on concentrated disadvantage *concd*, residential mobility *mob*, percent home ownership *pocc*, immigrant concentration *immc*, and population density *pod*.


```r
fit.lag.net<-lagsarlm(lvcmrt1417 ~ concd + mob + pocc + immc  + popd, 
     data = sea.tracts, listw = gang.matrix.w, zero.policy=TRUE) 
summary(fit.lag.net)
```

```
## 
## Call:lagsarlm(formula = lvcmrt1417 ~ concd + mob + pocc + immc + popd, 
##     data = sea.tracts, listw = gang.matrix.w, zero.policy = TRUE)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -4.91388 -0.55986  0.20336  1.17533  3.76124 
## 
## Type: lag 
## Regions with no neighbours included:
##  26700 26600 800 700 500 402 401 300 200 100 26500 26400 26300 26100 26001 1702 4302 4301 7402 11402 11401 25302 12100 12000 10900 1701 7401 9702 9701 9600 9500 9200 11600 11300 11200 8400 8300 8200 8001 7600 7500 7300 7100 7000 6900 6800 6700 6600 6500 6400 6300 6200 6100 6000 5801 5700 5600 5400 5302 5200 5100 5000 4900 4800 4600 4500 4200 4100 4000 3900 3800 5900 5802 3600 3500 3400 3300 3200 3100 3000 2900 2800 2700 2600 2500 2400 2200 2100 2000 1900 1800 1600 1500 1400 1200 1100 1000 900 
## Coefficients: (asymptotic standard errors) 
##                Estimate  Std. Error z value Pr(>|z|)
## (Intercept)  3.41870115  4.87099489  0.7018 0.482774
## concd       -0.43214007  0.33702903 -1.2822 0.199771
## mob          4.19446252  1.39910190  2.9980 0.002718
## pocc         0.08753576  5.01052176  0.0175 0.986061
## immc         2.88351427  3.15872225  0.9129 0.361309
## popd        -0.00134536  0.00050164 -2.6819 0.007320
## 
## Rho: 0.24589, LR test value: 19.108, p-value: 1.2352e-05
## Asymptotic standard error: 0.054203
##     z-value: 4.5365, p-value: 5.7187e-06
## Wald statistic: 20.58, p-value: 5.7187e-06
## 
## Log likelihood: -277.0942 for lag model
## ML residual variance (sigma squared): 3.05, (sigma: 1.7464)
## Number of observations: 140 
## Number of parameters estimated: 8 
## AIC: 570.19, (AIC for lm: 587.3)
## LM test for residual autocorrelation
## test value: 0.059683, p-value: 0.807
```

You use the same interpretations here as you did for the models we ran in Lab 8, except instead of a spatial diffusion effect, you're modelling a social network diffusion effect.  You can compare the findings from these models to a spatial dependency model using Queen contiguity.  This is the approach that Papachristos and Bastomski (2018) used in their American Journal of Sociology paper examining co-offending networks in Chicago.  


```r
fit.lag.geo<-lagsarlm(lvcmrt1417 ~ concd + mob + pocc + immc  + popd, 
     data = sea.tracts, listw = seaw, zero.policy=TRUE) 
summary(fit.lag.geo)
```

```
## 
## Call:lagsarlm(formula = lvcmrt1417 ~ concd + mob + pocc + immc + popd, 
##     data = sea.tracts, listw = seaw, zero.policy = TRUE)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -4.86357 -0.55506  0.30286  1.00657  3.71562 
## 
## Type: lag 
## Coefficients: (asymptotic standard errors) 
##                Estimate  Std. Error z value Pr(>|z|)
## (Intercept)  0.79431611  4.60814604  0.1724  0.86314
## concd       -0.03276924  0.30709184 -0.1067  0.91502
## mob          3.07667641  1.33426370  2.3059  0.02112
## pocc         0.44777225  4.71394049  0.0950  0.92432
## immc         3.03096625  2.96848686  1.0210  0.30723
## popd        -0.00065881  0.00047139 -1.3976  0.16224
## 
## Rho: 0.54894, LR test value: 27.102, p-value: 1.9305e-07
## Asymptotic standard error: 0.086788
##     z-value: 6.3251, p-value: 2.5307e-10
## Wald statistic: 40.007, p-value: 2.5307e-10
## 
## Log likelihood: -273.0975 for lag model
## ML residual variance (sigma squared): 2.6965, (sigma: 1.6421)
## Number of observations: 140 
## Number of parameters estimated: 8 
## AIC: 562.19, (AIC for lm: 587.3)
## LM test for residual autocorrelation
## test value: 2.2292, p-value: 0.13542
```

How do the lag parameters and coefficient estimates from the social network lag model *fit.lag.net* compare to the spatial lag model *fit.lag.geo*?


<div style="margin-bottom:25px;">
</div>
## **sfnetworks**
\

The methods in the above section do not get us to a complete convergence of the spatial and social network ecosystems in R.  A new package, **sfnetworks**, moves us towards that objective.  The package provides functions that allow users to create a spatial network based on geolocated points as nodes and lines (e.g. streets, transport networks, river basins, power grids, ecological networks) as edges.  We won't go through this package in detail because  it is  still in development and its power really resides in having both spatially explicit nodes and edges.  Here is a snippet from the package's [vignette](https://luukvdmeer.github.io/sfnetworks/articles/intro.html) that conveys this.

*In a geospatial network, the nodes always have coordinates in geographic space, and thus, are always described by an sf object. The edges, however, can also be described by just the indices of its end-nodes. This still makes them geospatial, because they start and end at specific points in space, but the spatial information is not explicitly attached to them. Both representations can be useful. In road networks, for example, it makes sense to explicitly draw a line geometry between two nodes, while in geolocated social networks, it probably does not. An sfnetwork supports both types. It can either have edges with a geometry stored in a geometry list column, described by an sf object, or edges that only refer to node indices, described by a regular data frame. We refer to these types of edges as spatially explicit edges and spatially implicit edges respectively.*

In our case study of gang turfs in Seattle, we have spatially explicit nodes (tracts), but not edges.  Nevertheless, we can still create an **sf** network and  create some nice spatial network plots and maps.

First, we'll need to install the package.  Because it is still in development, the package is not on CRAN.  So we need to install it from the creator's GitHub website


```r
remotes::install_github("luukvdmeer/sfnetworks")
```

You might have to update a bunch of new packages. When I did so, I ran into some problems with the **sf** package.  I had to remove it and then reinstall it.  When you are done installing, load the package in.


```r
library(sfnetworks)
```

Next, let's create an **sfnetwork** object using the function `sfnetwork()`. The first input is the nodes, which have to be an **sf** POINT object.  Our nodes are tracts, which are polygons, but we can use tract centroids, which we already created above with the object *centroids*. Let's reproject the centroids into UTM.


```r
#reproject to UTM NAD 83
centroids <-st_transform(centroids, 
                                 crs = "+proj=utm +zone=10 +datum=NAD83 +ellps=GRS80")
```

You then specify the edges in `sfnetwork()`, which may or may not  be spatial (i.e. an **sf** object).  In our case, our edges are not explicitly spatial.


```r
sea_gang_sfnetwork <- sfnetwork(centroids, sea.edges, directed = FALSE)
```

If we take a look at the object, it looks very similar to a **tidygraph** object, but with geometry attached!


```r
sea_gang_sfnetwork
```

```
## # A sfnetwork with 140 nodes and 90 edges
## #
## # CRS:  NAD83 / UTM zone 10N 
## #
## # An undirected simple graph with 101 components with spatially implicit edges
## #
## # Node Data:     140 x 1 (active)
## # Geometry type: POINT
## # Dimension:     XY
## # Bounding box:  xmin: 544372.9 ymin: 5260910 xmax: 557480.4 ymax: 5286565
##                    x
##          <POINT [m]>
## 1 (547236.4 5261101)
## 2 (547960.5 5262823)
## 3 (553551.4 5284454)
## 4 (552363.2 5284937)
## 5 (550060.9 5285164)
## 6 (547377.9 5285564)
## # … with 134 more rows
## #
## # Edge Data: 90 x 2
##    from    to
##   <int> <int>
## 1     5   104
## 2     5   136
## 3    21    50
## # … with 87 more rows
```

The **sfnetworks** package does not yet include advanced visualization options. However, a simple plot method is provided, which gives a quick view of how the network looks like.


```r
#get back to 1x1 plot frame
par(mfrow = c(1, 1))
plot(sea_gang_sfnetwork)
```

![](lab10_files/figure-html/unnamed-chunk-59-1.png)<!-- -->

We already produced a similar map above, but it required three lines of somewhat ambiguous code. 

We can actually make a much more visually compelling map.  We'll need to spatialize the lines connecting the tracts. To do this, use the `to_spatial_explicit` function within the `convert()` function, which draws straight linestring geometries between the *to* and *from* nodes of spatially implicit edges. 


```r
sea_gang_sfnetwork <- sea_gang_sfnetwork %>% 
  convert(to_spatial_explicit) 
```

Take a look at *sea_gang_sfnetwork*


```r
sea_gang_sfnetwork
```

```
## # A sfnetwork with 140 nodes and 90 edges
## #
## # CRS:  NAD83 / UTM zone 10N 
## #
## # An undirected simple graph with 101 components with spatially explicit edges
## #
## # Node Data:     140 x 2 (active)
## # Geometry type: POINT
## # Dimension:     XY
## # Bounding box:  xmin: 544372.9 ymin: 5260910 xmax: 557480.4 ymax: 5286565
##                    x .tidygraph_node_index
##          <POINT [m]>                 <int>
## 1 (547236.4 5261101)                     1
## 2 (547960.5 5262823)                     2
## 3 (553551.4 5284454)                     3
## 4 (552363.2 5284937)                     4
## 5 (550060.9 5285164)                     5
## 6 (547377.9 5285564)                     6
## # … with 134 more rows
## #
## # Edge Data:     90 x 4
## # Geometry type: LINESTRING
## # Dimension:     XY
## # Bounding box:  xmin: 545975.2 ymin: 5261665 xmax: 555847.6 ymax: 5285164
##    from    to .tidygraph_edge_index                             geometry
##   <int> <int>                 <int>                     <LINESTRING [m]>
## 1     5   104                     1   (550060.9 5285164, 546878 5279439)
## 2     5   136                     2   (550060.9 5285164, 549352 5283420)
## 3    21    50                     3 (551922.7 5269471, 551889.1 5270762)
## # … with 87 more rows
```

The lines have coordinates!

Why map just the nodes and edges? We can also map one of the node-level characteristics we measured above. For example, degree centrality.  To do this, we need to create a variable *degree* that calculates degree centrality within the *sea_gang_sfnetwork* object. 


```r
sea_gang_sfnetwork <- sea_gang_sfnetwork %>%
          mutate(degree = centrality_degree())
```

Now we can make a choropleth map of degree centrality with lines connecting tracts belonging to the same gang turfs.  I could not figure out how to do this using `tm_shape()` (maybe you can, super coder person).  Instead, I use `ggplot()`. We didn't really cover the use of `ggplot()` for mapping, only alluding to it in [Lab 4a](https://crd230.github.io/lab4a.html#Kernel_density_map). Our GWR reference textbook discusses the use  of `ggplot()` for mapping in [Chapter 8](https://geocompr.robinlovelace.net/adv-map.html).  We can use `ggplot()` to create our degree choropleth map using the following code.



```r
ggplot(sea.tracts) +
  geom_sf(aes(fill = degree)) +
  scale_fill_gradient(low= "white", high = "red",  name ="") +
  geom_sf(data = activate(sea_gang_sfnetwork, "edges") %>% st_as_sf(), col = 'black') + 
    labs(title = "Degree centrality of Seattle Gang Network") +
    theme( axis.text =  element_blank(),
    axis.ticks =  element_blank(),
    panel.background = element_blank())
```

![](lab10_files/figure-html/unnamed-chunk-63-1.png)<!-- -->

Cool, right?  With the tools we learned above, you can overlay the social network over all sorts of variable layers that might influence or be impacted by crime, crime diffusion and/or the creation of gang turfs.

As I mentioned above, **sfnetworks** is a work in progress, but carries a lot of promise.  Check out the package updates [here](https://rdrr.io/github/luukvdmeer/sfnetworks/f/NEWS.md) to see its development.  Once it gets on CRAN, it should be a go to package for combining spatial analysis with social network modelling.

And guess what? Your last badge of the  quarter!

<center>
![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/sfnetworklogo.png){ width=25% }

</center>

And with that, you're done! [Where'd all the time go?](https://www.youtube.com/watch?v=bmZQpbNK7t4)

***

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.


Website created and maintained by [Noli Brazil](https://nbrazil.faculty.ucdavis.edu/)


