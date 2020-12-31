---
title: "Syllabus"
subtitle: <h4 style="font-style:normal">CRD 230 - Spatial Methods in Community Research</h4>
output: 
  html_document:
    toc: true
    toc_depth: 3
    toc_float: true
    theme: cosmo
---

<h4 style="font-style:normal">Winter 2021</h4>

<style>
h1.title {
  font-weight: bold;
}
</style>

\

The following is an abridged version of the course syllabus.  A full course syllabus can be found on the Canvas class website.


<div style="margin-bottom:25px;">
</div>
## **Lecture Times**

* Tuesday and Thursday, 4:10-6:00 pm
* Live (synchronous) Zoom sessions
    
Zoom link is located on Canvas and pdf syllabus.

<div style="margin-bottom:25px;">
</div>
## **Instructor**

Dr. Noli Brazil  
*Contact*: nbrazil.at.ucdavis.edu  
*Office hours*: Tuesday from 2:00-3:30 pm or by appointment, Zoom.  Please sign up for a slot [here](https://www.wejoinin.com/sheets/wlzxs). Out of courtesy to other students, please do not sign up for more than two 10-minute blocks.  If you do, I will keep only the first two blocks. Zoom link is located on Canvas and pdf syllabus.

<div style="margin-bottom:25px;">
</div>
## **Course Objectives**

In this course, students will gain

* A theoretical understanding of the role of space and place in community-level phenomenon
* An understanding of what kinds of spatial data are available and where to find them
* Proficiency in spatial analytic tools (R) to
    + Manage and process spatial data
    + Descriptively examine spatial data
    + Run spatial models for statistical inference
* An understanding of how these methods are employed in community research

<div style="margin-bottom:25px;">
</div>
## **Course Format**

The course is taught live (synchronously) online through Zoom. Most class sessions will adhere to the following flow: The first hour of each class will involve me lecturing about the week’s methods. The second hour of each class will involve us going through the week’s lab material using real data.  All lectures will be recorded and uploaded on Canvas.  Although attendance is not mandatory, please consider attending as many live sessions as possible, as they will provide greater engagement with the instructor, peers and the material. Read the class_zoom_guidelines.pdf on Canvas for complete information regarding Zoom classroom access, etiquette and expectations.

<div style="margin-bottom:25px;">
</div>
## **Required Readings**

Required reading material is composed of a combination of the following 

1.	Journal articles and research reports.

There is no single official textbook for the course.  Instead, I’ve selected journal articles and research reports.

2.	My handouts

For most topics, in lieu of an article or book chapter, I will provide lecture handouts on Canvas in advance of the assigned class.  


## **Additional Readings**

The other major course material are lab guides, which will be released at the beginning of Tuesday's lecture on the class website.  Many of the R lab guides will closely follow two textbooks.  These textbooks are not required, but are great resources. 

The first textbook provides the foundation for using R

* (RDS) Wickham, Hadley & Garret Grolemund. (2017). R for Data Science. Sebastopol, CA: O’Reilly Media.

The textbook is free online at: http://r4ds.had.co.nz/introduction.html  

The second textbook covers spatial data in R

* (GWR) Lovelace, Robin, Jakub Nowosad & Jannes Muenchow. Geocomputation with R. CRC Press.

The textbook is free online at: https://geocompr.robinlovelace.net/

<div style="margin-bottom:25px;">
</div>
## **Course Software**

[R](https://www.r-project.org/) is the only statistical language used in this course, as it has become an increasingly popular program for data analysis in the social sciences. We will use [RStudio](https://www.rstudio.com/) as a user friendly interface for R. R is freeware and you can download it on your personal laptop and desktop computers (along with RStudio, which is a user friendly interface for R).   Note that although the course does not require students to have experience with R, this class does not devote too much time introducing students to the program.  In other words, this is a not an introduction to R programming.  The lab guides will provide as much detail as possible to execute tasks and functions, but you will likely run into tasks that will require you to go beyond the guides.  My suggestion is to (1) look up RDS or GWR as they are excellent resources and (2) if (1) fails search online.  As such, you are expected to do as much independent learning of the software as I teach in the labs.

<div style="margin-bottom:25px;">
</div>
## **Course Requirements** 

1. Assignments (4 x 15%: 60%)

Students are required to complete four homework assignments during the quarter which are due approximately every 2 weeks (Assignment 1 will be due in 1 week so it will be shorter).  The assignments will largely correspond to the material covered in lectures and labs.  Each assignment will ask students to apply methods in R.  Collaboration of ideas among participants is encouraged, but the assignments must be completed independently. For each assignment, you will need to submit an R Markdown Rmd and its knitted file on Canvas.  Complete assignment guidelines can be found here: https://crd230.github.io/hw_guidelines.html.  

Late submissions will be deducted 10% per 24 hours until 72 hours after the submission due time.  After 72 hours your submission will not be graded.  No exception unless you provide documentation of your illness or bereavement before the due date.  If you cannot upload the assignment on Canvas due to technical issues, you must email it as an attachment to me by the submission due time.

2. Course project (40%)

Students will conduct a research project using methods discussed in class on a topic of their choosing.  A full description of the project can be found in the file final_project_description.pdf located on Canvas. All students must submit a Prospectus. Students have two final project options: (1) StoryMap presentation and a Policy Brief; (2) Final paper and a presentation of any format.  Students will present their projects during a live Zoom session. If you cannot present on that day/time, please let me know, and plan on submitting and uploading on Canvas a pre-recorded presentation.  See the agenda for the due dates for each of the deliverables.


<div style="margin-bottom:25px;">
</div>	
## **Course Agenda**
\

The schedule is subject to revision throughout the quarter.  Please see the full syllabus for a more detailed version of the agenda

<table class="table table-striped table-hover table-responsive" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Date </th>
   <th style="text-align:left;"> Topic </th>
   <th style="text-align:left;"> Readings </th>
   <th style="text-align:left;"> Assignment </th>
   <th style="text-align:left;"> Project </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 5em; "> 5-Jan </td>
   <td style="text-align:left;"> Introduction to class </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 7-Jan </td>
   <td style="text-align:left;"> Introduction to R </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 12-Jan </td>
   <td style="text-align:left;"> Introduction to the U.S. Census </td>
   <td style="text-align:left;"> Handout 1 </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 14-Jan </td>
   <td style="text-align:left;"> Data wrangling and visualization </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 19-Jan </td>
   <td style="text-align:left;"> Introduction to spatial data </td>
   <td style="text-align:left;"> Handout 2 </td>
   <td style="text-align:left;width: 13em; "> HW 1 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 21-Jan </td>
   <td style="text-align:left;"> Neighborhoods </td>
   <td style="text-align:left;"> Sharkey and Faber (2014) </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 26-Jan </td>
   <td style="text-align:left;"> Open Data </td>
   <td style="text-align:left;"> Handout 3 </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 28-Jan </td>
   <td style="text-align:left;"> Big Data </td>
   <td style="text-align:left;"> Handout 3 </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 2-Feb </td>
   <td style="text-align:left;"> Spatial accessibility </td>
   <td style="text-align:left;"> Handout 4 </td>
   <td style="text-align:left;width: 13em; "> HW 2 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 4-Feb </td>
   <td style="text-align:left;"> Spatial accessibility </td>
   <td style="text-align:left;"> Handout 4 </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 9-Feb </td>
   <td style="text-align:left;"> Segregation </td>
   <td style="text-align:left;"> Handout 5a; Logan and Stults (2011) </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 11-Feb </td>
   <td style="text-align:left;"> Neighborhood Opportunity/Disadvantage </td>
   <td style="text-align:left;"> Handout 5b </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 16-Feb </td>
   <td style="text-align:left;"> Spatial Autocorrelation </td>
   <td style="text-align:left;"> Handout 6 </td>
   <td style="text-align:left;width: 13em; "> HW 3 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 18-Feb </td>
   <td style="text-align:left;"> Spatial Autocorrelation </td>
   <td style="text-align:left;"> Handout 6 </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 23-Feb </td>
   <td style="text-align:left;"> Linear regression </td>
   <td style="text-align:left;"> Handout 7 </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;"> Proposal </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 25-Feb </td>
   <td style="text-align:left;"> Spatial regression </td>
   <td style="text-align:left;"> Handout 7 </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 2-Mar </td>
   <td style="text-align:left;"> Introduction to StoryMaps </td>
   <td style="text-align:left;"> Lung-Amam &amp; Dawkins (2019) </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 4-Mar </td>
   <td style="text-align:left;"> Social Network Analysis </td>
   <td style="text-align:left;"> Handout 8 </td>
   <td style="text-align:left;width: 13em; "> HW 4 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 9-Mar </td>
   <td style="text-align:left;"> Social Network Analysis </td>
   <td style="text-align:left;"> Handout 8 </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 11-Mar </td>
   <td style="text-align:left;"> No class </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 16-Mar </td>
   <td style="text-align:left;"> Presentations </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;"> Presentation </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 5em; "> 18-Mar </td>
   <td style="text-align:left;"> Final Project report due </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;width: 13em; ">  </td>
   <td style="text-align:left;"> Final report </td>
  </tr>
</tbody>
</table>


***

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.

Website created and maintained by [Noli Brazil](https://nbrazil.faculty.ucdavis.edu/)
