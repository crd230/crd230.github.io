---
title: "Lab 9: ArcGIS StoryMaps"
subtitle: <h4 style="font-style:normal">CRD 230 - Spatial Methods in Community Research</h4>
author: <h4 style="font-style:normal">Professor Noli Brazil</h4>
date: <h4 style="font-style:normal">March 2, 2021</h4>
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






In this guide you will learn how to create a StoryMap using Esri's ArcGIS Online StoryMap platform. The objectives of the guide are as follows.

1. Learn how to navigate ArcGIS Online
2. Learn how to add content to your ArcGIS Online account
3. Learn how to create a StoryMap
4. Learn how to share your StoryMap

For this lab, download the files from Canvas (Files - Week 9 - Lab). There should be eight files - six photos (lametro.jpg, los_angeles_photo.jpg, pblk_histogram.jpg, phisp_histogram.jpg, stater_bros.jpg, and vons.jpg) and two zip files (la_tract_groc_dist and Los_Angeles_Metro_Stations). *la_tract_groc_dist.shp* is a shapefile of census tracts and the distance to their nearest grocery store in the City of Los Angeles. *Los_Angeles_Metro_Stations.shp* is a shapefile containing Los Angeles Metro Rail stops. We’ll create a StoryMap about grocery store spatial access in the City of Los Angeles.


<div style="margin-bottom:25px;">
</div>
## **Before you begin your StoryMap**
\

The main objective of this lab guide is to teach the technical nuts and bolts for creating an Esri StoryMap.  However, the real work is the planning that goes into preparing what your StoryMap will look like. Before you start putting your StoryMap together online, you should first sketch it out offline. Outline what each StoryMap "slide" will present. Figure out which visuals make the most sense.  Sketch out which StoryMap features work best with your story's narrative and flow. In creating a StoryMap, you should go through the following steps

1. Decide what story you wish to tell and which StoryMap elements you want to use to tell it.

2. [Plan the elements](https://www.esri.com/arcgis-blog/products/arcgis-storymaps/sharing-collaboration/planning-and-outlining-your-story-map-how-to-set-yourself-up-for-success/) of your story by making an outline or sketching a [story board](https://docs.google.com/document/d/19h5Wvea_y5C8PSn2-6ATMfNBcOuNXEkPNM_uQxslKbA/edit).

3. [Review the nine steps](https://storymaps.arcgis.com/stories/429bc4eed5f145109e603c9711a33407) for effective digital storytelling.

Remember that the power of a StoryMap is the ability to present your findings in a user-friendly, visually powerful way.  And as described by this week's reading (Lung-Amam and Dawkins, 2020), a large part of this power is the ability to use StoryMaps to give voices to historically disadvantaged groups in a community. Planning ahead will help you unlock this power. 


<div style="margin-bottom:25px;">
</div>
## **Sign up for ArcGIS Online**
\

StoryMaps are web applications that let authors combine beautiful maps with narrative text, striking images, and multimedia, including video. The applications are designed to be attractive and usable by anyone, which makes them great for education and outreach, either to the general public or to a specific audience.  We will be using Esri's version of StoryMaps in this course. 

[Esri's ArcGIS suite of software](https://itcatalog.ucdavis.edu/service/arcgis-geographic-software) is available to all UC Davis students.  To create an Esri StoryMap, we need to use ArcGIS online. [ArcGIS Online](https://doc.arcgis.com/en/arcgis-online/get-started/what-is-agol.htm) is an online, collaborative web GIS that allows you to use, create, and share maps, scenes, apps, layers, analytics, and data.  It provides a central location to store, manage, and share spatial data. We need to use it to create a StoryMap because it is the place that holds your shapefiles to display maps in your StoryMap.

Signing up for an ArcGIS online account is super easy.  Just follow these steps

1. Navigate to the UC Davis ArcGIS Online [splash page](https://ucdavis.maps.arcgis.com/home/index.html)

2. Click on "Sign In" located at the top right corner of the page.

3. Click on the blue button "Kerberos Login UC Davis". Instead of the blue button, you might get a screen like the one shown below.  If this is the case, use the Enterprise Login section to enter the UC Davis organization URL, "ucdavis.maps.ucdavis.edu".

<center>
![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig1.png)

</center>
\
\vspace{0.5 in}


4. You will be redirected to UC Davis' ADFS login page, where you can finish logging in by entering your UC Davis Kerberos credentials.  Type your UC Davis email address and password. You should be in!


<div style="margin-bottom:25px;">
</div>
## **Adding content to your account**
\

The next step is to collect the files you want to include in your StoryMap.  This will include

* Photos (e.g. jpeg, png)
* Shapefiles
* Videos 

and other types of media files and spatial data.  Photos can also include static maps that you create in R and saved as jpegs. 

In order to include an interactive map into your StoryMap, you will need to upload the shapefile onto your ArcGIS Online account. Remember from Handout 2 that a shapefile is actually more than a single file. In order to upload a shapefile onto ArcGIS Online, you'll need to put all the associated files into a zipped folder.  To zip files into a folder on a Mac, check this [site](https://support.apple.com/guide/mac-help/compress-uncompress-files-folders-mac-mchlp2528/mac).  To do it on Windows, check this [site](https://support.microsoft.com/en-us/help/14200/windows-compress-uncompress-zip-files). The *la_tract_groc_dist.zip* zipped folder contains all the spatial files associated with *la_tract_groc_dist.shp*.  Ditto for Los_Angeles_Metro_Stations.zip and *Los_Angeles_Metro_Stations.shp*.

To add these files onto your ArcGIS Online cloud, do the following

1. After you've signed in, click on "Content" at the top of page. 

2. On the Content page, click on "Add Item" on the top left of the screen. Click on "From my Computer"

3. Under "File:", click on the "Browse..." button. Navigate to the folder where you downloaded the files from Canvas.  Select the file *la_tract_groc_dist.zip*. Provide a descriptive title for the file (don't use the default). ArcGIS online prevents files with the same title names to be uploaded.  Therefore, for the purposes of this lab, just type in "Los Angeles Tract Grocery Distance (INSERT YOUR NAME HERE)". Leave "Shapefile" under Contents and the checkmark next to "Publish this file as a hosted layer."

4. Tags are required when adding new items.  These are like keywords in a sense.  Check this [Esri blog article](https://www.esri.com/arcgis-blog/products/arcgis-online/data-management/using-tags-effectively/) for some best practices for naming tags.  For now, just type in "Los Angeles".  Hit return/enter on your keyboard. Then click on Add Item.   This will lead you to an information page about the file you just uploaded.

5. You'll need to add each file one at a time.  Click on Content. Then follow steps 1-4 again to add Los_Angeles_Metro_Stations.zip.  Give the title "Los Angeles Metro Stations (INSERT YOUR NAME HERE)".

6. In the My Content page, you should see all the files you've uploaded.  Note that the spatial files will come in two forms: a shapefile and a feature layer. We already  covered what a shapefile is in Handout 2. A [feature layer](https://doc.arcgis.com/en/arcgis-online/reference/feature-layers.htm) is needed to map the file online. 

<div style="margin-bottom:25px;">
</div>
## **Create a Map**
\

You've uploaded the shapefile, but you need to create a map from the shapefile. That is, you are going to be doing the `tm_shape()` version of mapping on ArcGIS.  Follow the steps below

1. Click on "Map" located at the top menu.  You should get a screen that looks something like below.  If you get a window asking you about opening up Map Viewer Beta, click on "NOT RIGHT NOW" (but don't yell!).

<center>
![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig2.png)
</center>
\
\vspace{0.5 in}

2. Click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig3.png) located at the top left and select on "Search for layers".  The two shapefiles you uploaded should show up.  Click on the file you named for la_tract_groc_dist. Click on "Add to Map".  Click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig4.png) on the top right and then ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig5.png) next to "My Content" to make the left panels disappear.  Los Angeles tracts should pop up in your map.

3. On the left panel, click on Show Contents of Map ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9content.png) if it isn't already selected.  

4. Now, we want to shade each of the tracts by their distance to the nearest grocery store. Click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig6.png). For 1, select the variable *grocdist* from the pop down menu. This is the variable containing distance of the tract's centroid to the nearest grocery store.  We're going to shade the tracts based on this variable.

5. A number of options pop up that ask you how you want to shade your tracts.  Because *grocdist* is a numeric variable, we choose the first option "Counts and Amounts (Color)", which should already show a check mark.  You can click "Options" to change the color scheme and alter other visual features. For now, just leave the default settings.

6. Click on "Done" at the bottom.  You should get a map that looks like below.

<center>
![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig7.png)
</center>
\
\vspace{0.5 in}


7. Next, we want to make sure the legend is shown when you place the map in your StoryMap. Hover your mouse underneath la_tract_groc_dist (or whatever you named the file), click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig8.png) to have the legend show up.  

8. Click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9save.png) and the Save again. Provide a illustrative title ("Los Angeles Tract Distance to Nearest Grocery Store").  Add a tag ("Los Angeles"). Add a summary (optional). Leave the rest. Click on "Save Map".

9. If you click Home at the top left and then Content, you should should see the map you just created listed at the top with the  label "Web Map".

10. Create another map adding the following two layers: la_tract_groc_dist and Los_Angeles_Metro_Stations.  Click on Map.  Click on "New Map" at the top right to bring down a menu and then "Create New Map".  Map la_tract_groc_dist by going through steps 2-7 again.  

11. Add Los_Angeles_Metro_Stations on top of this map by going through steps 2-6 using Los_Angeles_Metro_Stations.  You should Los Angeles metro stations as points pop up in your map. If you click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig6.png) under Los_Angeles_Metro_Stations, you'll find ways to alter the color, shape and symbol of the points.  For now, just leave 1 as "Show location only" and 2 as "Location (Single symbol)".  You'll notice that for 2, you can create a heat map, which is a kernel density map. You should get a map that layers Los Angeles Metro stations on top of Los Angeles city tracts shaded by distance to nearest grocery store (see below).   

<center>
![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig9.png)
</center>
\
\vspace{0.5 in}

12. Follow steps 7-8 to save this map (I named it "Los Angeles Tracts and Metro Stations")

Click on Home and Content at the top right. You should now see the two "Web Maps' you created at the top.

<div style="margin-bottom:25px;">
</div>
## **Create your StoryMap**
\

StoryMaps are web applications that combine interactive maps with multimedia content and text to tell your story.   They work on mobile phones, tablets, and PCs.  Think of them as web-based power point presentations that allow you to interact with maps.

Go to Esri's [StoryMap splash page](https://storymaps.arcgis.com/stories).   Click on Start a Story. Your [journey](https://www.youtube.com/watch?v=OMD8hBsA-RI) has now begun.

1.  The first page is your title page.  You can construct the title page any way you deem fit. You can add an image or map to the background. It can be all text.  First, write in a title ("Spatial Access to Grocery Stores in Los Angeles").  You can also add a subtitle (Your name, perhaps).  Let's add an illustrative picture.  Click on "Add cover image or video" on the top right of the screen.  Browse to the folder you saved the Canvas files into.  Select the file los_angeles_photo.jpg and click on Add.  You should see a nice photo of the City of Angeles filling the background (can you guess where there is?).

2. If you scroll down, you'll notice a ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png) and next to that the words "Tell your story".  Clicking on this is like adding a slide on your PowerPoint presentation.  Click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png) and you'll see all the features you can add to your StoryMap.  We won't go through all of them due to time constraints, so I suggest playing around with the options on your own, but let's highlight the most popular features.  

<div style="margin-bottom:25px;">
</div>
### **Sidecar**
\

After clicking on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png), click on Sidecar and then select "Docked panel" (you can test what a "Floating panel" looks like on your own). A window should pop up telling you what a sidecar is. A sidecar has a large media panel on one side and a narrative panel on the other. As readers scroll through the narrative for each slide in the sidecar, the media changes to match the narrative. Here is an [ArcGIS tutorial](https://learn.arcgis.com/en/projects/build-a-sidecar-in-your-story/) on sidecars. And here are two [best](https://storymaps.arcgis.com/stories/82509aafc8ba435f8c1264122d299763) [practices](https://www.esri.com/arcgis-blog/products/arcgis-storymaps/mapping/6-ways-to-use-sidecar-in-the-new-arcgis-storymaps/) guides for using sidecars in StoryMaps. Sidecars generally look something like this

<center>
![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/sidecar.gif) 
</center>
\
\vspace{0.5 in}

1. Sidecars are great for showing photos. Add an image by clicking on "Add media" and then "Add image or video".  Click on "Browse your files" and add the photo vons.jpg (Southern Californians know what [Vons](https://www.vons.com/) is all about!). The photo should fill up the right hand side of the screen. Click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig10.png) to edit features of the placement of the photo.

2. On the left side panel, click on  ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png) and click on "Text". Then click on “Heading” from the pull down menu that appears. This will give you a heading or title for this particular slide (I just wrote “Title goes here”).  Underneath the title, click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png), and select "Text" and then select "Bulleted list” from the pull down menu. Here, you can add bulleted text describing the image on the right and other major points. You can also add a numbered list or just text. You might get something that looks like below. 

<center>
![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig11.png) 
</center>
\
\vspace{0.5 in}

3. Click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png)  on the bottom right corner of the screen.  This will add another slide to your sidecar.  This time add the photo stater_bros.jpg (another Southern California based [supermarket chain](https://www.staterbros.com/)) and add some text on the left panel like you did in the Vons slide.

4. You can also add interactive maps to your sidecar.  Click ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png)  on the bottom right corner.  Click on "Add media" and then  Add map". You should see the two maps you created earlier in your ArcGIS online account. Click on "Los Angeles Tract Distance to Nearest Grocery Store".  You should see a screen that looks like below.

<center>
![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig12.png) 
</center>
\
\vspace{0.5 in}

5. You can format how the map will look like on your slide.  You can zoom into Los Angeles by clicking on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig13.png)  on the bottom right. You can rename the layer.  You can add a legend by clicking on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig15.png) and sliding the button to the right. This ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig16.png) should pop up on the bottom left corner of the screen indicating a legend is added. You can also go back to ArcGIS Online to edit this map by clicking on "Edit map in ArcGIS".  Once you are done editing, click on "Place map" located at the bottom right of the screen.

6. On the left panel, add a heading and text describing the map.

7. Let's add another slide with a map. Click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png) and then click on "Add media" and then "Add map". Follow steps 4-6, but instead add the map "Los Angeles Tracts and Metro Stations".  You'll notice at the bottom of your sidecar all the slides you've added.  You can toggle back to the others if you want to edit them.

8.  Let's see what our sidecar looks like in action. Scroll back to the first slide.  Then scroll down.  You'll notice the text scrolling down with the image on the right staying in place. When you reach the next slide, the new image and text will pop up. You'll also see the first map pop up and then the second map with the stations pop up.  Note that although ArcGIS Online allows some interactive map formatting and editing, it does not always yield visually captivating maps.  If you feel a static map that you've created in R is better, upload that onto your StoryMap.  The benefit of an interactive map is that it allows you while presenting and users while viewing your StoryMap to explore the map.

Explore the use of a [Floating Panel sidecar](https://www.esri.com/arcgis-blog/products/arcgis-storymaps/mapping/employing-and-enjoying-sidecars-docked-and-floating-panel-layouts/) on your own. Floating panels are placed to minimize interference with the images as readers scroll.  Text within the sidecar sections is short (for longer text it’s usually advisable to use the docked panel layout). 

<div style="margin-bottom:25px;">
</div>
### **Text and photos**
\

A sidecar is a particular StoryMap tool that allows the user to present their maps/images/text in an organized, visually appealing fashion.  Alternatively, you can just simply add plain text and photos without them being in a feature.  

1. Scroll out of the sidecar (just scroll down until you are below it). Click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png) next to "Continue your story..." and select ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig17.png).  This will add a visual separator from the sidecar to signify the next stage of your StoryMap.

2. Beneath the separator, click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png) and select ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig18.png). Add the image phisp_histogram.jpg. This is a histogram of percent Hispanic for census tracts in Los Angeles.  Click Add.

3. Beneath the image, click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png) and select ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig20.png).  Then click "Heading" from the pull down menu that pops up. Type in the title "Percent Hispanic".  

4. Beneath the title, click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png) and select ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig20.png).   Add the text "This is a histogram of percent Hispanic".

5. Hover your mouse over the histogram. Click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig21.png).  You should see that the image shifted to the left and the text is now to the right of the image.

<center>
![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig22.png) 
</center>
\
\vspace{0.5 in}

6.  Click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png) beneath your text "This is a histogram of percent Hispanic".  Follow steps 2-5 and add the photo pblk_histogram.jpg and text.  You should get something that will look like

<center>
![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig23.png) 
</center>

<div style="margin-bottom:25px;">
</div>
### **Slideshow**
\


Another neat built-in StoryMap feature is the slideshow.  A slideshow offers a full-screen media and a floating narrative panel. The navigation for a slideshow is  horizontal.  A few ArcGIS guides on slideshows can be found [here](https://www.esri.com/arcgis-blog/products/arcgis-storymaps/constituent-engagement/slideshow-beta-a-new-immersive-block-in-arcgis-storymaps/), [here](https://storymaps.arcgis.com/collections/a21747b075c446eb930677a0b82c4a35) and [here](https://doc.arcgis.com/en/arcgis-storymaps/author-and-share/add-slideshows.htm). The flow of a sideshow will look something like

<center>
![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/slideshow.gif) 
</center>
\
\vspace{0.5 in}

Let's add a slideshow.

1. Underneath the text for your percent black panel "This is a histogram of percent black", click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png) and select ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig17.png) to add a separator.

2. Underneath the separator,  click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png) and select ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig24.png).  A window should pop up giving information about the slideshow feature.

3. In a slideshow, you can have an image, video or map in the background and floating text in the forefront.  Click on "Add media" and select "Add image or video". Click "Browse your files" and select the photo lametro.jpg. Click Add.

3. A photo of the beautiful Los Angeles transit system should fill the background of your slide.  Add some text (a heading and an explanation) directly into the white box located in the middle of the slide.

4. Click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9button.png) at the bottom right corner to add another slide.  Click on "Add media"" and then click on "Add a map".  Select the map "Los Angeles Tracts and Metro Stations".  You will find yourself in the same editing screen as the one earlier.  Click on "Place map" once you're done editing.  Los Angeles tracts and Metro stations should fill the background of your slide. This map is interactive - you  can zoom in and out and scroll around. Add  some text to the white box and you should get something like below.

<center>
![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig25.png) 
</center>
\
\vspace{0.5 in}

 
6. When you are presenting your slideshow, click on the arrows ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9arrows.png) on the right and left of the screen to move from slide to slide.


<div style="margin-bottom:25px;">
</div>
## **Preview your StoryMap**
\

You can continue adding more features to your StoryMap as you see fit, but you get the idea of the main functionalities of a StoryMap.  In the StoryMap we created above, you used multiple features, but you can stick with just one - e.g. just use a sidecar for the entire presentation.

Note that ArcGIS Online automatically saves your StoryMap as you are creating it. If you back to your ArcGIS Online Content page, you should see your StoryMap.  For example, I have

<center>
![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig26.png) 
</center>

To Preview what your StoryMap will look like once you share it to the rest of the world, click on, what else, "Preview"" at the top of your StoryMap.  Scroll through the presentation using the bar on the right and note any changes you want to make. Remember, a slideshow scrolls left to right whereas a sidecar strolls top to bottom.  Once you are done previewing, click on "Edit story" and you'll get sent back to the editing screen.  


<div style="margin-bottom:25px;">
</div>
## **Publish your StoryMap**
\

Once you are completely happy with your StoryMap, share it! 

1. Click on Publish at the top.  You have two sharing options. The first is to share your StoryMap to Everyone. The second is to share to "My Organization" which is just to UC Davis.  For this lab, click on  My Organization. Then click "Publish story".

2. The next page will likely ask you if would like to share the maps of Los Angeles you created.  You'll need to share them so that people can view your StoryMap, so click on "Yes, share these items".

3. You should get a message that states that your StoryMap is published. The website link is the link to your StoryMap.  As long as the individual is in your organization (i.e. UC Davis affiliate), they can access the map using the link.  This is link that you will submit on Canvas for your final project.  To view your peers StoryMaps, you have to be logged onto your ArcGIS Online account.  

4. To unpublish your StoryMap, click on Edit story. This will take you back to editing mode. Click on ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig27.png) and select "Unpublish story" to unshare it. You can also change the settings such that you are sharing to Everyone. If you share your StoryMap to the world, you'll find this ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig28.png) at the top of your StoryMap.  The first two symbols allows you to link your StoryMap through Facebook and Twitter. The last symbol ![](/Users/noli/Documents/UCD/teaching/CRD 230/Lab/crd230.github.io/lab9fig29.png) copies the link to your StoryMap, which you can share to anyone, even if they don't have an ArcGIS Online account.

If you are looking for other resources to learn more about StoryMaps, check out Esri's [step-by-step guide](https://storymaps.arcgis.com/stories/cea22a609a1d4cccb8d54c650b595bc4).  There are also a number of examples and best practices found on Esri's [official StoryMaps splash page](https://www.esri.com/en-us/arcgis/products/arcgis-storymaps/overview)


<div style="margin-bottom:25px;">
</div>
## **Classic Esri StoryMap**
\

In July 2019, Esri launched their new, modern platform for telling stories with maps. This is the platform we went through in this lab.  Before this, we had the classic Esri StoryMap template.  These templates can be found [here](https://storymaps-classic.arcgis.com/en/).  Esri's classic storytelling templates include: Cascade, Journal, Series, Shortlist, Swipe & Spyglass, and Tour. They were basically made-to-fill-in StoryMap presentations. Esri is planning to phase out support for the classic template by 2024. Which means, you can still use them, but the momentum is moving away from the classic template.  If you would like to learn more about the classic StoryMap template, see [this resource](https://storymaps.arcgis.com/stories/472a6ddd582b40b58a5a6af2c30a4573).  There are tutorials and guides for Classic StoryMaps, including [this](https://learn.arcgis.com/en/projects/get-started-with-story-maps/) and [this](https://storymaps-classic.arcgis.com/en/).

<div style="margin-bottom:25px;">
</div>
## **Other StoryMap Resources**
\

We've only just touched on StoryMap's tools, functions, and possibilities.  Check out the following resources for more help, ideas and inspiration.

* [Planning and outlining your story map: How to set yourself up for success](https://www.esri.com/arcgis-blog/products/arcgis-storymaps/sharing-collaboration/planning-and-outlining-your-story-map-how-to-set-yourself-up-for-success/)

* [Nine steps to great storytelling](https://storymaps.arcgis.com/stories/429bc4eed5f145109e603c9711a33407)

* [The Myriad Uses of StoryMaps](https://storymaps.arcgis.com/stories/1b38cf02f39849478d3123dcd9465022)

* [Skill For Good: Connecting skilled volunteers to nonprofits with storytelling needs](https://storymaps.arcgis.com/stories/af8237b89288422cac22405ceb0ee1ea)

* [Los Angeles City](https://lacontroller.org/data-stories-and-maps/) has some really cool examples of StoryMaps.

* So does [Dr. Willow Lung-Amam](http://www.willowlungamam.com/story-mapping
)

* Esri's favorite StoryMaps in [2018](https://collections.storymaps.esri.com/community-stories-2018/)

* Esri's favorite StoryMaps in [2019](https://www.esri.com/arcgis-blog/products/arcgis-storymaps/constituent-engagement/our-favorite-story-maps-of-2019/)

* Esri's favorite StoryMaps in [2020](https://www.esri.com/arcgis-blog/products/arcgis-storymaps/mapping/our-favorite-stories-of-2020/)

* University of Minnesota has some helpful guides on harnessing the full features of StoryMaps [here](http://storymaps-umn.opendata.arcgis.com/app/10e1f455dcbb4565b1f83fad44947dff) and [here](http://storymaps-umn.opendata.arcgis.com/app/3de403e07275427bb7425ad18f6b7936). 


***

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.


Website created and maintained by [Noli Brazil](https://nbrazil.faculty.ucdavis.edu/)
