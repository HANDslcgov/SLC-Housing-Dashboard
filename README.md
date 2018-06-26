# User Manuel

 ⋅⋅⋅This file is the user instruction for the SLC housing dashboard app. 

## What is this?

⋅⋅* This is a R Shiny dashboard app. and Highcharts library is used to create all the charts and graphs in the dashboard.
⋅⋅* For more information, see the [shiny dashboard official website] (https://shiny.rstudio.com) for how to build shiny dashboards and  [Highcharts official website] (https://www.highcharts.com) for highcharts's features, details and API.

## Main parts of the dashboard app

⋅⋅* The main body of the dashboard includes Welcome, How did we get here, Dashboard, and Goals of Growing SLC. Welcome page is the landing page that has introductory texts and a hyper link to the Growing SLC plan. How did we get here page has textual description and visualization of the housing crisis of SLC, including a hyper link to Snapshot SLC. On the Dashboard page is mainly the visualization of various aspects of SLC housing in the form of charts and graphs. Goals of Growing SLC shows the progress  and stages of of Growing SLC plan. The codes are in dashboard.R.
⋅⋅* The styling and formatting codes are in dashboard.css where there are codes that define the framework layout, color design, textual formatting, as well as other customized special designs.
⋅⋅* Data file is where all the data is stored. “Raw” data are in the form of either .csv or .xlsx and the data loaded to the app are .rds files.
⋅⋅* startup.R has the code to process “raw” data and transform into .rds files.
⋅⋅* goals.R is written to process data that are used in the progress table on the Goals of Growing SLC page. 

## How to install and run it?

⋅⋅⋅ Install R libraries, such as shiny(), shinydashboard(), and run it on shiny server.

## Where are the data files for the graphs?

### 1. How did we get here:

⋅⋅* Data for the graph “Salt Lake City Metropolitan Statistical Area Income Levels in 2017” is from HUD and is in Data/incomeLevels.csv;
⋅⋅* Data for the graph “AMI Percentage by Industry” is from HUD and is in Data/industryC.csv;
⋅⋅* Data for the graph “Salt Lake City Average Rents vs Affordability (80% AMI)” is from CBRE and is in Data/averageRentsVsAffordability.csv;
⋅⋅* Data for the graph “Wage Increase vs Home Sale Price Increase: 2011-2014” is from BBC Housing Market Study and is in Data/wageIncreaseVsHomeSalePrice.csv;
⋅⋅* Data for the graph “Wage Increase vs Rent Increase: 2011-2016” is from BBC Housing Market Study and is in Data/wageIncreaseVsRent.csv;

### 2. Dashboard:

⋅⋅* Data for the graph “Salt Lake City Housing by Owner vs Renter: 2014” is from Growing SLC and its values are coded in the script;
⋅⋅* Data for the graph “Age of Housing Stock: Salt Lake City, 2014” is from Growing SLC and is in Data/houseAge.csv;
⋅⋅* Data for the graph “Salt Lake City Opportunity Index” is from HAND and is in OppurtunityIndex.csv;
⋅⋅* Data for the graph “Salt Lake City: All Units” is from Growing SLC and is in Data/allUnits.csv;
⋅⋅* Data for the graph “Salt Lake City: Owners Units” is from Growing SLC and is in Data/ownersUnits.csv;
⋅⋅* Data for the graph “Salt Lake City: Renters Units” is from Growing SLC and is in Data/rentersUnits.csv;
⋅⋅* Data for the graph “Affordable Units in Total Multi-Family Units” is from HAND and ACS and is in Data/Multifamily.xlsx;
⋅⋅* Data for the graph “New Residential Units in 2017” is from Ivory Boyer Database and is in Data/SLC_new_units.xlsx;
⋅⋅* Data for the graph “Salt Lake City's Yearly Construction Trend: 2013-2017” is from Ivory Boyer Database and HAND and is in Data/yearly_construction_permit_total.xlsx;
⋅⋅* Data for the graph “Salt Lake City Average Rent by Neighborhood” is from Rent Jungle and is in Data/rentAve.csv;
⋅⋅* Data for the graph “Salt Lake County Historical Vacancy Rate” is from CBRE and is in Data/vacancyHis.csv;
⋅⋅* Data for the graph “Salt Lake City Median Sale Price vs Median Income: 2008 - 2017” is from UtahRealEstate.com and are in Data/incomeMedian.csv and Data/medianSale.csv;
⋅⋅* Data for the graph “Cost Burden: Salt Lake City” is from 2014 ACS and BBC Research & Consulting and is in Data/costBurden.csv;
⋅⋅* Data for the graph “Income affordability (60% AMI): Salt Lake City 2017” is from HUD and UtahRealEstate.com and is in Data/incomeLevels.csv;
⋅⋅* Data for the graph “Income Affordability vs Median Home Price: Salt Lake City, 2017” is from HUD and UtahRealEstate.com and is in Data/incomeAffordability.xlsx;

### 3. Goals of Growing SLC:

⋅⋅⋅ All the files are in Data/Goals.

## How to update data files and use them in the app?

⋅⋅⋅ Just need to update data in the .cvs or .xlsx files. startup.R will turn files into .rds and the dashboard app can use these updated data.

