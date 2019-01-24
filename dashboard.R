library(shiny)
library(shinydashboard)
library(highcharter)
library(leaflet)
library(dplyr)
library(scales)
library(treemap)
library(viridis) 
library(kableExtra)
source("goals.R")
load("./Data/rds/opportunity_index_map.rds")

# opportunity map path####
opportunity_index_map$dependencies[[1]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/lib/leaflet-providers"))
opportunity_index_map$dependencies[[2]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/leaflet-providers-plugin"))

# change the thousand separator in highcharts into "comma"####
hcoptslang <- getOption("highcharter.lang")
hcoptslang$thousandsSep <- ","
options(highcharter.lang = hcoptslang)

# neighborhood rent rds file upload here####
neighborhoodRent <- readRDS("Data/rds/neighborhoodRent.rds")

# design webpage sidebar menu items ####
fluidPage(
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Welcome", tabName = "welcome", icon = icon("home")),
    menuItem("How did we get here?", tabName = "how", icon = icon("bar-chart")),
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Goals of Growing SLC", tabName = "goals", icon = icon("road")),
    menuItem("City Affordable Housing Map", tabName = "map", icon = icon("map")),
    br()
  )
),

# welcome page design ####
body <- dashboardBody( 
  # Dashboard favicon and title
  tags$head(
    tags$link(rel = "icon", type = "image/png", href = "house.png"),
    tags$link(href = "dashboard.css", rel = "stylesheet"),
    tags$title("SLC Housing")
  ),
  
  tabItems(
    tabItem(
       tabName="welcome",
       
      fluidRow(box(class = "welcomeHeader", width = 12,
              h1(class = "boxText", class = "headerText", "SALT LAKE CITY "),
              h2(class = "boxText", "A THRIVING CITY OF OPPORTUNITY"),
              h2(class = "boxText", "FOR EVERYONE")
       )),
       fluidRow(box(class = "boxWelcome", width = 6, height = 300,
                h2(class = "boxText", "Salt Lake City is experiencing a systemic housing crisis that has implications for every resident and business.")
       ),
       
       box(width = 6, solidHeader = FALSE,
            p("Resolving the crisis will require a community wide effort. Salt Lake City’s Housing and Neighborhood Development Division worked collaboratively 
         to draft a plan to address the root causes of affordability, create long-term solutions for increasing needed housing supply, 
         and expand opportunities throughout the City. The 5 year plan is called Growing SLC, and was unanimously adopted by City Council in December 2017. 
         This site is a critical component that provides data on housing market performance and progress towards fulfilling the objectives of the plan.
         (Please note, that this plan serves as our State of Utah required biennial Moderate Income Housing Plan.)"),
           br(),
           br()
       )
     ), br(),br(),
     p(a(tags$b("Want to Check Out The Plan? Click Here"), target="_blank", href="http://www.slcdocs.com/hand/Growing_SLC_Final_Attachments.pdf"))
     ),
    
    
# design dashboard page ####
    # dashboard header and intro text####
    tabItem(tabName = "dashboard",
           fluidRow(box(class = "dashboardHeader", width = 12,
                        h1(class = "boxText", class = "headerText", "DASHBOARD "),
                        h2(class = "boxText", "GROWING PAINS & HOUSING GAINS:"),
                        h2(class = "boxText", "A LOOK AT LONG-TERM HOUSING FOR EVERYONE")
            )),
            fluidRow(
              column(width = 12,
              p("Salt Lake City’s housing market has been experiencing a boom since the end of the Great Recession. However, even with a large increase in construction, vacancy rates are at an all-time low, driving up housing prices across the city.  
                The growth in population and employment supports a vibrant city in which many want to live and work, but it is increasingly becoming a city out of reach for many of our residents and workers."),
              p("The Growing SLC Housing Plan, unanimously adopted by the City Council in December 2017, aims to address the root causes of housing affordability, increase the much-needed housing supply, and expand opportunities for residents throughout the City."),
              p("The affordable housing crisis has implications for every Salt Lake City resident and business. Resolving this crisis requires a thorough understanding of the issue and tracking of our progress. 
                Together, we can work to solve these challenges and support solutions to support a city that offers a high quality of life and inclusiveness. "),
              p("Growing SLC includes the objective of providing residents, community advocates, business leaders, and elected officials with high quality data to drive decision-making. This site provides a public-facing set of housing metrics to
                provide insights into key market characteristics. The following indicators illustrate important data on housing and will track updates on progress over time to drive decisions, understand impact, and help inform solutions to 
                Salt Lake City’s housing crisis.")
            )),
            # create 2 boxes for SLC housing stock makeup ####
            fluidRow(
              column(width = 12,
              fluidRow(h2("Salt Lake City Housing Stock Makeup:", class = "dashboardTitle"),
                       h2("Older and Primarily Single Family", class = "dashboardTitle")
              ),
              p("A majority of Salt Lake City’s housing stock was built before 1940, indicating greater chances that dilapidation, blight, and unsafe conditions may exist. About half of the housing is single-family detached, which consumes large lots and is generally unaffordable for many low-income households. The other half consists primarily of apartments, duplexes, and condos. "),              box(highchartOutput("plot10", height = 500)),
              box(highchartOutput("plot14", height = 500))
            )),
            br(),br(), br(),
            # Opportunity chart and texts ####
            fluidRow(
              column(width = 12,
              fluidRow(
                       h2("Salt Lake City Opportunity Index", class = "dashboardTitle")
              ),
                       p("Neighborhood-level data help define the need for services as well as measure access to
                        opportunity for the local population. Measuring and mapping the access to
                        various opportunities, we can begin to understand some of the empirical differences 
                        between neighborhoods. Once we have grasp on this, the City can begin making strategic 
                        investments to help expand the opportunities throughout the city."),
                        p("This map displays a 
                        variety of indicators that are important in guiding these investments, including employment rate, 
                         income level, household cost burden, rate of homeownership, and educational attainment. 2 represents low areas of opportunity, and 8 represents high areas of opportunity."),
              box(opportunity_index_map,width = NULL)
            )),
            # 3 boxes for housing type by tenure charts ####
            fluidRow(
              column(width = 12,
              fluidRow(
              h2("Salt Lake City Housing Type by Tenure: 2014", class = "dashboardTitle")
              ),
              p("About 51% of Salt Lake City households are renters and 49% owners. The percentage of renters has grown slightly over time from 50% in 2010.
               As can be seen below, the stock of rental housing is more than 50% multifamily, while the stock of owner-occupied housing is 83% single family. 
               The vast majority of rental units (80%) has only two bedrooms, which makes finding affordable housing difficult for families."),
              p("This graph shows the type of housing units by type, attached (more than 10 units), attached (fewer than 10 units) and single family detached."),
              column(width=4, box(highchartOutput("plot11", height = 400), width=NULL)),
              column(width=4,box(highchartOutput("plot12", height = 450), width=NULL)),
              column(width=4,box(highchartOutput("plot13", height = 400), width=NULL)),
              p("Datasource: BBC Housing Market Study 2016")
            )),
            br(),br(), br(),
            # create a box for Affordable ratio in comparison with all multifamily units ####
            fluidRow(
              column(width = 12,
              fluidRow(
              h2("Salt Lake City's Multi-Family Units: Affordable vs. Market Rate", class = "dashboardTitle")
              ),
              p("Salt Lake City has seen a rapidly escalating multifamily market with rents at all-time highs and vacancy rates at historic lows. 
                However, while the market rate apartment inventory continues to grow, affordable multi-family units have lost ground, even with the addition of new units.
                The percentage affordable is much lower as a share of total housing stock as only a small number of single-family homes are long-term affordable."),
              box(highchartOutput("plot1", height = 600), width=NULL),
              p("Datasource: HAND and ACS 2016")
            )),
            br(),br(), br(),
            # create a box for SLC new residential housing stock ####
            fluidRow(
              column(width = 12,
              fluidRow(
              h2("Salt Lake City's New Residential Construction", class = "dashboardTitle")
              ),
              p("Salt Lake City is experiencing tremendous residential growth with new homes and apartment buildings being constructed. 
                However, this growth is not keeping pace with demand and increases in housing costs are far outpacing incomes."),
              p("The graph shows the number and type of new residential units coming up in Salt Lake City in 2017."),
              box(highchartOutput("plot3", height = 450), width=NULL),
              p("Datasource: Ivory Boyer database")
            )),
            br(),br(), br(),
            # create a box for yearly construction trend ####
            fluidRow(
              column(width = 12,
              h2("Salt Lake City's Yearly Construction Trend", class = "dashboardTitle"),
              p("The following chart shows the construction trend within most recent 5 years."),
              br(),
              box(highchartOutput("plot4", height = 400), width=NULL),
              p("Datasource: Ivory Boyer database and HAND")
            )),
            br(),br(), br(),
            fluidRow(
              column(width = 12,
              fluidRow(
                       h2("Salt Lake City's Greatest Housing Needs", class = "dashboardTitle")
              ),
              p("1. 7,500 affordable rental units to meet the needs of the city’s lowest income renters (those earning $20,000 and less per year)."),
              p("2. Additional residential housing product to entice in-commuters to relocate to the city, encourage current residents—particularly 
                millennials—to remain in the city and provide more homeownership opportunities for underserved renters.")
            )),
            # average rent chart box and affordability calculator box ####
            fluidRow(
              column(width = 12,
                     fluidRow(
                     h2("Average Rent by Neighborhood", class = "dashboardTitle")
                     ),
                     p("Many previously “affordable” units throughout the city are currently being leased at higher rental rates due to market demand. 
                       In the fastest growing areas of the city, such as Downtown and Sugarhouse, affordable units are being sold and converted to housing for residents with higher incomes."),
                     p("In Salt Lake City, nearly one half of the renters are cost burdened, and nearly one quarter are extremely cost-burdened (spend more than 50% of their income on rent)."),
                     p("The graph below shows average rent by neighborhood. The data comes from Rent Jungle, which pulls listings from over 12,000 property management and owner websites on a nightly basis.
                       Please note that the graph and calculator do not include all city neighborhoods, and mainly the cost-burden areas of the city.")
              )
            ),
            fluidRow(
              column(width = 8,
                     box(highchartOutput("plot5", height=500), width=NULL)
              ),
              column(width = 4, wellPanel(
                selectInput("neighborhood_type", "Rent Burden Calculator",
                            neighborhoodRent$neighboarhood)
              ),
              htmlOutput('a_out')
              )
            ),
            br(),br(), br(),
            # create a box for historical vacancy rates ####
            fluidRow(
              column(width = 12,
                     fluidRow(
                     h2("Historical Vacancy Rates for Salt Lake City and Downtown", class = "dashboardTitle")
                     ),
                     p("With rental vacancy rates at historic lows, the rental market has become increasingly competitive. 
                       The city requires a larger supply of rentals to not only accommodate demand, but to address the needs of lower income renters."),
                     p("The graph below shows Salt Lake City's most recent three-year vacancy rates. 
                       Data shown here is based on rentals with square footages between approximately 800 SF and 1,000 SF. CBRE collects and interprets this data to offer their perspective on the trends of the real estate market."),
                     box(highchartOutput("plot6", height=400), width=NULL),
                     p("Datasource: CBRE, inc")
              )
              ),
            br(),br(), br(),
            # create a box for the comparison of home prices and median income ####
            fluidRow(
              column(width = 12,
                     fluidRow(
                     h2("The Growing Affordability Gap: Home Prices Vs. Income", class = "dashboardTitle")
                     ),
                     p("Like many housing markets across the country, Salt Lake City has experienced substantial increases in home values 
                       since early 2012. By the end of 2014, the median sale price of $235,000 exceeded the 2007 peak median sale price of $223,751."),
                     p("Unfortunately, incomes have not risen at the same rate as housing prices."),
                     p("The graph shows the historical trend of median sale prices in Salt Lake City from 2008 to 2017."),
                     box(highchartOutput("plot9", height=500), width=NULL),
                     p("Datasource: UtahRealEstate.com")
              )
            ),
          br(),br(), br(),
          # create a box for cost burden chart ####
          fluidRow(
            column(width = 12,
                 fluidRow(
                  h2("Cost Burden: Salt Lake City", class = "dashboardTitle")
                  ),
                 p("In addition to income, it is important to consider residents' housing expenses relative to their income. Residents spending 30 percent or more of their income on housing are said to be 'cost burdened'
                   and residents spending 50 percent or more of their income on housing are said to be 'severely cost burdened'."),
                 p("Nearly half (49%) of all renters (18,672 households) in Salt Lake City are cost burdened. Twenty-three percent of renters are severely cost burdened. Owners are far less likely to be cost-burdened:
                   in Salt Lake City 22 percent of owners (7,599 households) are cost burdened and 8 percent are severely cost burdened."),
                 p("The graph displays housing costs as a percentage of monthly income for Salt Lake City households."),
                 box(highchartOutput("plot15", height=400), width=NULL),
                 p("Datasource: 2014 ACS and BBC Research & Consulting")
            )
          ),
          br(),br(), br(),
          # create 2 boxes for income affordability charts ####
          fluidRow(
            column(width = 12,
                   fluidRow(
                            h2("INCOME NEEDED TO AFFORD MEDIAN HOME PRICES IN 2017", class = "dashboardTitle")
                   ),
                   p("In order to afford the median home price in Salt Lake City in 2017 (includes all types, single family, condominiums, 
                     twin homes, and townhomes), a household needs to make roughly $65,000 annually. This is around 87% AMI of SLC median 
                     income for a household of 4. With home price increases rapidly outpacing income increases, more and more Salt Lake City 
                     households are getting priced out of homeownership."),
                   box(highchartOutput("plot16", height=400), width=NULL),
                   p("Datasource: HUD and UtahRealEstate.com")
            )
          ),
          br(),br(), br(),
          fluidRow(
            column(width = 12,
                   box(highchartOutput("plot17", height=400), width=NULL),
                   p("Datasource: HUD and UtahRealEstate.com")
           )
         )
    ),
    # design "how did we get here" page boxes ####
    tabItem(tabName = "how",
          # get header for "how" webpage ####  
         fluidRow(box(class = "howHeader", width = 12,
                      h1(class = "boxText", class = "headerText", "HOW DID WE GET HERE? "),
                      h4(class = "boxText", "Salt Lake City is experiencing a housing crisis where affordable housing"),
                      h4(class = "boxText", "is becoming more scarce. Challenges in our housing market will have"),
                      h4(class = "boxText", "widespread implications for every resident and business.")
          )),
          # insert introductory texts and snapshot ####  
          fluidRow(box( width = 6, 
                      p("In the face of these challenges, Salt Lake City Housing and Neighborhood Development Division (HAND) 
                           sees the opportunity to find meaningful and lasting solutions that can bring stability to residents by 
                           providing housing that is safe, secure and affordable and provide opportunities for more of our workforce 
                           to call Salt Lake City home."),
                      p("The  Growing SLC Five Year Housing Plan (Growing SLC)  is a response to these challenges and proposes a fundamental shift to how housing is prioritized in the city. 
                       This site provides data on the housing market performance and progress towards fulfilling the objectives of the Growing SLC.")
                            ),
                    box(width = 6, 
                        h2("Snapshot Salt Lake: Summary", class = "howTitle"),
                        p(tags$b("View A Snapshot: "), a(tags$b("Here."), target="_blank", href="Growing_SLC_Snapshot.pdf")),
                        p("Data is the key to understanding how our city is growing and developing, what barriers and challenges exist when solving the affordable housing crisis, 
                            and how system design can create a more equitable place to live. This section will focus on the story the data shows about the city’s growth and development 
                            and how that affects the residents of the city. ")
                    )),
            br(),br(), 
            # create a box for SLC AMI chart ####
            fluidRow(
              column(width=12,
                     fluidRow(
                     h2("Salt Lake City is facing a housing crisis", class = "howTitle")
                     ),
                     br(),
                     p("Area Median Income (the midpoint of a region’s income distribution) is a metric used to help understand the relationship between income and housing affordability. 
                       Residents with household income that is less than 60% of AMI (about $45,000) are more likely to struggle to make housing payments. 
                       Per federal agency definitions, affordable means spending no more than 30% of income on housing costs. Households are considered cost-burdened when housing costs 
                       absorb more than 30% of their income and severely cost-burdened when housing costs take up more than 50% of their income. In Salt Lake City, 
                       nearly half of renter households are cost-burdened and nearly a quarter are severely cost-burdened. This means that those households face difficult tradeoffs 
                       with their remaining income and are more likely to confront housing instability. Additionally, Salt Lake City has about 12,000 renter households that make 
                       less than $20,000 annually and a gap of nearly 7,500 units affordable to those households."), 
                     br(),
                     box(highchartOutput("graph1", height = 600), width=NULL),
                     p("Datasource: HUD 2017")
                     )
              ),
            br(),br(), br(),
            # create a box for wages for industries chart #### 
            fluidRow(
              column(width=12,
                     fluidRow(
                     h2("SLC's Average Annual Wages for the Top 10 Industries", class = "howTitle")
                     ),
                     br(),
                     p(" This tree map represents top 10 industries in Salt Lake City with respective average annual wages and the AMI percentages for each industry."),
                     p("Income is one of the most significant barriers to meeting the housing needs of Salt Lake City’s residents. 
                       The area median income for residents in Salt Lake City is nearly $20,000 less than that of the County as a whole, at $46,711. 
                       In addition, only two of the five largest employment industries in Salt Lake City pay wages high enough to afford the city’s median home price of $271,000."), 
                     br(),
                     p("Datasource: HUD 2017"),
                     box(highchartOutput("graph2", height = 600), width=NULL)
                     )
              ),
            br(),br(), br(),
            # create a box for comparison between wages and rents chart ####
            fluidRow(
              column(width=12,
                     fluidRow(
                              h2("Salt Lake City has significant gaps in its housing market", class = "howTitle")
                     ),
                     br(),
                     p("Although Salt Lake City is amid an unprecedented building boom, it has yet to keep pace with the rising numbers of people who want to call the city home. 
                       New construction has not been sufficient to meet market gaps or keep pace with job growth."),
                     p("Rising rents and vacancy rates of 2% are driving more and more city residents to either seek housing elsewhere or live burdened with housing costs that exceed 30%, 
                       and in some cases, more than 50%, of their household income."),
                     p("As a comparison, a single person household in Salt Lake County has an Area Median Income (AMI) of $51,690; 
                       the AMI for a family of four is $73,800. The graph shows a $470 average monthly gap between affordable rent 
                       for a one-person household and a one-bedroom average rent plus utilities, and $610 average monthly affordable gap 
                       between affordable rent for a four-person household and three-bedroom average rent plus utilities."),
                     br(),
                     box(highchartOutput("graph3", height = 500), width=NULL),
                     p("Datasource: CBRE 2016"),
                     p("In addition to the gap of affordable rentals, another key challenge that Salt Lake City faces in its housing market 
                       is a very high percentage of in-commuters (84% of its workforce) which is in part tied to the lack of residential housing product 
                       that is affordable and appealing to the workforce. This high rate of in-commuting contributes to air quality issues, congestion, 
                       and adds a strain on the city’s daytime resources."),
                     fluidRow(class="welcomeBox",
                              img(src='commuters.png',class="center") 
                     )
                     )
            ),
           br(),br(), br(),
           # 2 boxes for wage increases in comparison to home prices increases and rent increases ####
           fluidRow(
             column(width=12,
             fluidRow(
             h2("Wage increases are not keeping pace with housing cost escalation", class = "howTitle")
             ),
             p("In recent years, rent and home price growth has substantially exceeded income growth which has led to increasingly difficult housing decisions and tradeoffs."),
             p("This steep rise in prices has created a market in which most homes for sale are only affordable for those in high-income brackets."),
             p("Home sale prices increased 33% between 2011 and 2014, while homeowner wages increased only 8%. The rent increase of 26% is adding great pressure for renters who have only a 4% wage increase."),
             box(highchartOutput("graph4", height = 400)),
             box(highchartOutput("graph5", height = 400)),
             p("Datasource: BBC Housing Market Study 2016")
             ))
       ),
   # design "goals" page ####
    tabItem(tabName = "goals",
            # goals page header####
           fluidRow(box(class = "goalsHeader", width = 12,
                        br(),
                        br(),
                        h1(class = "boxText", class = "headerText", "GOALS OF GROWING"),
                        h1(class = "boxText", class = "headerText", "SALT LAKE CITY"),
                        br(),
                        br()
            )),
            fluidRow(
              column(width=10,
                # goal 1 texts, objectives texts and tables"####     
                h2("Goal 1: INCREASE HOUSING OPTIONS: REFORM CITY PRACTICES TO PROMOTE A RESPONSIVE, AFFORDABLE, HIGH-OPPORTUNITY HOUSING MARKET", class = "goalsTitle"),
                p("In order to respond to Salt Lake City’s changing demographics and the housing needs of its diverse communities, 
                  it is critical to begin to look within the City for real and responsive change that will encourage the market to 
                  develop the housing and infrastructure needed to accommodate our growing community. This goal focuses on the need 
                  to increase the diversity of housing types and opportunities in the city by seeking policy reforms that can 
                  enhance the flexibility of the land-use code and create an efficient and predictable development process for community growth. 
                  Strategic policy decisions that integrate the transportation system, development related infrastructure, financial institutions, 
                  and data, as well as innovative design and construction methods, can break down social and economic segregation, thus building a city for everyone."),
                  p(class = "objective", "Objective 1: Review and modify land-use and zoning regulations to reflect the affordability needs of a growing, pioneering city"),
                    tableOutput("goal11"),  class = "styleAttribute",
                  p(class = "objective", "Objective 2: Remove impediments in City processes to encourage housing development."),
                    tableOutput("goal12"),
                  p(class = "objective", "Objective 3: Lead in the construction of innovative housing solutions."),
                    tableOutput("goal13"),
                  p(class = "objective", "Objective 4: Provide residents, community advocates, business leaders, and elected officials with high-quality data to drive decision-making."),
                    tableOutput("goal14"),
                 # goal 2 texts, objectives texts and tables"####
                 h2("Goal 2: AFFORDABLE HOUSING: INCREASE HOUSING OPPORTUNITIES AND STABILITY FOR COST-BURDENED HOUSEHOLDS", class = "goalsTitle"),
                 p("This goal is dedicated to serving and addressing the needs of those most vulnerable in our community. 
                    It is driven by a strong belief that housing stability is good for the entire city, adding income to 
                    small businesses, creating food stability for children, and allowing residents to enrich their neighborhoods. 
                    Salt Lake City needs to pursue a combination of strategies outlined in the objectives below to achieve this goal.
                    There is no singular initiative that will resolve this crisis, it must be addressed with a range of strategies 
                    to best fit the diverse needs of our entire community."),
                    p(class = "objective", "Objective 1: Prioritize the development of new affordable housing with an emphasis on households earning 40% AMI and below."),
                      tableOutput("goal21"),
                    p(class = "objective", "Objective 2: Pursue funding for affordable housing opportunities."),
                      tableOutput("goal22"),
                    p(class = "objective", "Objective 3: Stabilize very low-income renters."),
                      tableOutput("goal23"),
                    p(class = "objective", "Objective 4: Secure and preserve long-term affordability."),
                      tableOutput("goal24"),
                    p(class = "objective", "Objective 5: Work with landlords to improve their housing stock and rent to very low-income households earning 40% AMI and below."),
                      tableOutput("goal25"),
                    p(class = "objective", "Objective 6: Increase home ownership opportunities."),
                      tableOutput("goal26"),
                  # goal 3 texts, objectives texts and tables"####
                  h2("Goal 3: EQUITABLE & FAIR HOUSING: BUILD A MORE EQUITABLE CITY", class = "goalsTitle"),
                  p("Equity is not only about eliminating discrimination, it is also about 
                     increasing access to opportunity. One of the guiding principles of 
                     Plan Salt Lake is to create an equitable city by ensuring 
                     “access to all city amenities for all citizens while treating everyone equitably 
                     with fairness, justice, and respect.” The City will accomplish this by working to 
                     eliminate housing discrimination, strategically investing in neighborhoods that 
                     stand the most to gain, and building a city that meets needs of a diverse population."),
                     p(class = "objective", "Objective 1: Eliminate incidences of housing discrimination in Salt Lake City."),
                       tableOutput("goal31"),
                     p(class = "objective", "Objective 2: Align resources and invest in strategic expansion of opportunity throughout all neighborhoods of the city and access to existing areas of opportunity."),
                       tableOutput("goal32"),
                     p(class = "objective", "Objective 3: Implement life cycle housing principles in neighborhoods throughout the city."),
                       tableOutput("goal33")
              )
              )
            ),
# design "map" page ####
tabItem(tabName = "map",
        # goals page header####
        fluidRow(box(class = "goalsHeader", width = 12,
                     br(),
                     br(),
                     h1(class = "boxText", class = "headerText", "CITY AFFORDABLE HOUSING MAP"),
                     br(),
                     br()
        )),
        fluidRow(
          column(width=10,
                 #iframe issue
                 tags$iframe(width = "640", height = "480",
                             src = "https://www.google.com/maps/d/embed?mid=1EMGku5Mg6FCNp87ZZNv4UPwCzmmQtfVZ&zoom=9")
                 )
                 )
          )
      
    )
    )
    )

# Put items together into a dashboardPage ####
ui <- dashboardPage(title = "Housing and Neighorhood Development",
  dashboardHeader(title = tags$a(href='http://www.slcgov.com/hand',
                                 tags$img(src='handlogo.png', class="logoImage"))),
  sidebar,
  body
)

# Server ####
server <- function(input, output) {
  # create a bar chart and a column chart in combination to show affordable units in multifamily units ####
  multi <- readRDS("Data/rds/multi.rds")
  output$plot1<-renderHighchart({
    multifamily_plot<-highchart() %>%
      hc_title(text = "Affordable Units in Total Multi-Family Units") %>%
      hc_xAxis(categories = c("Affordable units", "Total Multi-family units")) %>%
      hc_yAxis(title = list(text = "Number of Units")) %>%
      hc_plotOptions(series = list(colorByPoint = TRUE),
                     column = list(dataLabels = list(enabled = TRUE), 
                                   colors=c("#2EADC5", "#2A3236")))%>%
      hc_add_series(data=c(subset(multi, `Project Name` == "total")$`Affordable Units`, 
                           subset(multi,`Project Name` == "total")$`Multifamily Units Total`), 
                    type="column", name="Multifamily units" ) %>%
      print(multifamily_plot)
  })
  # create a column chart for new residential units ####
  library(readxl)
  permit17 <- read_excel("Data/SLC_new_units.xlsx", sheet = "Sheet1")
  permitSinVsMul<- permit17 %>%
    select(`Duplexes and Twin Homes`, `Condominiums / Townhomes`, `Apartments (3 or more units)`) %>%
    mutate(multifamily=`Duplexes and Twin Homes`+`Condominiums / Townhomes`+`Apartments (3 or more units)`)
  
  output$plot3<-renderHighchart({
    permit_all<-highchart() %>%
      hc_chart(type="column") %>%
      hc_title(text = "New Residential Units in 2017") %>%
      hc_yAxis(title = list(text = "Number of Units")) %>%
      hc_xAxis(categories = c("January-March", "April-June",
                              "July-September", "October-December")) %>%
      hc_plotOptions(column=list(datalabels = list(enabled = FALSE),
                                 stacking = "normal", enableMouseTracking=TRUE,
                                 colors=c("#FBAA20","#2EADC5","#36B885","#2A3236"))) %>%
      
      hc_series(list(name="Single-Family", data=permit17$`Single-family Units`, color="#FBAA20"),
                list(name="Duplexes and Twin Homes", data=permit17$`Duplexes and Twin Homes`, color="#36B885"),
                list(name="Condominiums / Townhomes", data=permit17$`Condominiums / Townhomes`, color="#2EADC5"),
                list(name="Apartments", data=permit17$`Apartments (3 or more units)`, color="#2A3236")
      )
    print(permit_all)
  })
  # create a column chart for yearly constructioin trend ####
  constructionTrend <- readRDS("Data/rds/constructionTrend.rds")
  output$plot4<-renderHighchart({
    yearly_construction_trend<-highchart() %>%
    hc_chart(type="column") %>%
      hc_title(text = "Salt Lake City's Yearly Construction Trend: 2013-2017") %>%
      hc_yAxis(title = list(text = "Number of homes")) %>%
      hc_xAxis(categories = constructionTrend$year) %>%
      hc_series(list(name="Single-family", data=constructionTrend$`single family home numbers`, color="#FBAA20"),
                list(name="Duplexes and twin homes", data=constructionTrend$`duplex and twin home numbers`, color="#36B885"),
                list(name="Condominiums / Townhomes", data=constructionTrend$`condominium/townhouse numbers`, color="#2EADC5"),
                list(name="Apartments (3 or 4 units)", data=constructionTrend$`apartment (3 or 4 units) numbers`, color="#315C5F"),
                list(name="Apartments (1-3 floors)", data=constructionTrend$`apartment (1-3 floor) numbers`, color="#676866"),
                list(name="Apartments (4+ floors)", data=constructionTrend$`apartment (4+ floor) numbers`, color="#2A3236")
      )%>%
      print(yearly_construction_trend)  
  })
  # create a bar chart for rent by neighborhood ####
  output$plot5<-renderHighchart({
    rent_plot<-highchart() %>%
      hc_chart(type="bar") %>%
      hc_title(text = "Salt Lake City Average Rent by Neighborhood") %>%
      hc_yAxis(title = list(text = "Rent in dollars"),
               labels=list(format= "${value}")) %>%
      hc_xAxis(categories=neighborhoodRent$neighboarhood) %>%
      hc_series(list(name="Average rent", color="#2EADC5",
                     data=neighborhoodRent$a_rent)
                )%>%
      print(rent_plot)
  }
  )
  # create a column chart for vacancy rate ####
  historicalVacancy <- readRDS("Data/rds/historicalVacancy.rds")
  output$plot6<-renderHighchart({
    historical_vacancy<-highchart() %>%
      hc_title(text= "Salt Lake County Historical Vacancy Rate") %>%
      hc_xAxis(categories = c("Salt Lake City", "Downtown")) %>%
      hc_yAxis(labels=list(format= "{value}%"))%>%
      hc_series(list(name="2014 vacancy rates", type="column", color="#2A3236",
                     data=c(subset(historicalVacancy, county=="Salt Lake City")$vacancy2014, 
                            subset(historicalVacancy,county=="Downtown")$vacancy2014)),
                list(name="2015 vacancy rates", type="column", color="#2EADC5",
                     data=c(subset(historicalVacancy, county=="Salt Lake City")$vacancy2015,
                            subset(historicalVacancy, county=="Downtown")$vacancy2015)),
                list(name="2016 vacancy rates", type="column", color="#36B885",
                     data=c(subset(historicalVacancy, county=="Salt Lake City")$vacancy2016,
                            subset(historicalVacancy, county=="Downtown")$vacancy2016))
      )%>%
      print(historical_vacancy)
  }
  )
  # create column chart of median sale price with a line cross that shows median income ####
  incomeMed <- readRDS("Data/rds/incomeMed.rds")
  medianSale <- readRDS("Data/rds/medianSale.rds")
  output$plot9<-renderHighchart({
    historical_median_sale<-highchart() %>%
      hc_title(text="Salt Lake City Median Sale Price vs Median Income: 2008 - 2017") %>%
      hc_yAxis(labels=list(format="${value}")) %>%
      hc_xAxis(categories=incomeMed$year, labels=list(align="left")) %>%
      hc_plotOptions(
        line = list(dataLabels = list(enabled = TRUE)),
        column = list(dataLabels = list(enabled = TRUE))
      )%>%
      hc_add_series(name="median sale prices: all types of home", data=medianSale$All, type="column",
                    dataLabels=list(enabled=TRUE,format= "${point.y:,.0f}"), colorByPoint=FALSE,
                    color="#676866") %>%
      hc_add_series(name="median household income", data=round(incomeMed$median, -2), type="line",
                    dataLabels=list(enabled=TRUE, format="${point.y:,.0f}"),
                    color="#FBAA20", markerOptions=list(enabled=FALSE,lineWidth=2))
    print(historical_median_sale)
  }
  )
  # a pie chart for housing stock by owner vs renter ####
  output$plot10<-renderHighchart({ 
    ownerRenter4<-highchart()%>%
      hc_chart(type="pie")%>%
      hc_title(text="Salt Lake City Housing by Owner vs Renter: 2014")%>%
      hc_plotOptions(series = list(showInLegend = TRUE, colors=c("#2EADC5", "#2A3236"))) %>% 
      hc_add_series_labels_values(labels = c("Owners", "Renters"), 
                                  values =c(34691, 41232), size=200, dataLabels = list(enabled = FALSE))%>%
      hc_tooltip(pointFormat = paste('{point.y} households'))%>%
      print(ownerRenter4)
  }
  )
  # 3 pie charts created for housing by tenure ####
  allUnitsRatio <- readRDS("Data/rds/allUnitsRatio.rds")
  output$plot11<-renderHighchart({ 
    ownerRenter1<-highchart()%>%
      hc_chart(type="pie") %>%
      hc_title(text = "Salt Lake City: All Units") %>%
      hc_add_series_labels_values(labels = c("Attached: 10 or more units", "Attached: fewer than 10 units", "Single family detached"), 
                                  values =allUnitsRatio$ratio, size=150, dataLabels = list(enabled = FALSE),
                                  colors=c("#FBAA20","#2EADC5","#2A3236"))%>%
      hc_tooltip(pointFormat = paste('{point.y}%  of all units'))%>%
      print(ownerRenter1)
  }
  )
  
  ownersUnitsRatio <- readRDS("Data/rds/ownersUnitsRatio.rds")
  output$plot12<-renderHighchart({ 
    ownerRenter2<-highchart()%>%
      hc_chart(type="pie") %>%
      hc_title(text = "Salt Lake City: Owners Units") %>%
      hc_plotOptions(series = list(showInLegend = TRUE)) %>% 
      hc_add_series_labels_values(labels = c("Attached: 10 or more units", "Attached: fewer than 10 units", "Single family detached"), 
                                  values =ownersUnitsRatio$ratio, size=150, dataLabels = list(enabled = FALSE),
                                  colors=c("#FBAA20","#2EADC5","#2A3236"))%>%
      hc_tooltip(pointFormat = paste('{point.y}%  of owners'))%>%
      print(ownerRenter2)
  }
  )
  
  rentersUnitsRatio <- readRDS("Data/rds/rentersUnitsRatio.rds")
  output$plot13<-renderHighchart({ 
    ownerRenter3<-highchart()%>%
      hc_chart(type="pie") %>%
      hc_title(text = "Salt Lake City: Renters Units") %>%
      hc_add_series_labels_values(labels = c("Attached: 10 or more units", "Attached: fewer than 10 units", "Single family detached"), 
                                  values =rentersUnitsRatio$ratio, size=150, dataLabels = list(enabled = FALSE),
                                  colors=c("#FBAA20","#2EADC5","#2A3236"))%>%
      hc_tooltip(pointFormat = paste('{point.y}%  of renters'))%>%
      print(ownerRenter3)
  }
  )
  # create a bar chart to show housing stock age ####
  houseAge <- readRDS("Data/rds/houseAge.rds")
  output$plot14<-renderHighchart({ 
    age<-highchart()%>%
      hc_chart(type="bar")%>%
      hc_title(text="Age of Housing Stock: Salt Lake City, 2014")%>%
      hc_xAxis(categories = c("Built 2000 or later", "Built 1980 to 1999", 
                              "Built 1960 to 1979", "Built 1940 to 1959", "Built 1939 or earlier")) %>%
      hc_yAxis(labels=list(format= "{value}%")) %>%
      hc_series(list(name ="Salt Lake City", colorByPoint=TRUE, colors=c("#FBAA20","#2EADC5","#36B885","#315C5F","#2A3236"),
                     data=houseAge$percentage, dataLabels=list(enabled=TRUE,format= "{point.y}%"))
                )
    print(age)
  }
  )
  # create a bar chart to show cost burden of SLC ####
  costBurden <- readRDS("Data/rds/costBurden.rds")
  output$plot15<-renderHighchart({
    cost_burden<-highchart()%>%
      hc_chart(type="bar")%>%
      hc_title(text="Cost Burden: Salt Lake City")%>%
      hc_xAxis(title = list(text = "Percent of Income Spent on Housing"), categories = c("Less than 15%", "15% to 29.9%", "30% to 49.9%", "50% and more")) %>%
      hc_yAxis(title = list(text = "Proportion of Renters/Owners"), labels=list(format= "{value}%")) %>%
      hc_series(list(name ="Owners with a mortgage", color = "#2EADC5",
                     data=costBurden$owners_with_a_mortgage, dataLabels=list(enabled=TRUE,format= "{point.y}%")),
                list(name ="Renters",  color="#FBAA20",
                     data=costBurden$renters, dataLabels=list(enabled=TRUE,format= "{point.y}%")),
                list(name ="Owners without a mortgage", color = "#2A3236",
                     data=costBurden$owners_without_a_mortgage, dataLabels=list(enabled=TRUE,format= "{point.y}%"))
      )
    print(cost_burden)
  }
  )
  # create column chart of 60% AMI with a line cross that shows income needed to afford median sale price ####
  incomeLevels <- readRDS("Data/rds/incomeLevels.rds")
  output$plot16<-renderHighchart({
    incomeAffordability<-highchart() %>%
      hc_title(text="Income affordability (60% AMI): Salt Lake City 2017") %>%
      hc_yAxis(labels=list(format="${value}"), plotLines=list(list(label=list(text="income needed to afford median home sale price: $65 500"),
                                                                   color="#FBAA20", value=65500, width=2))) %>%
      hc_xAxis(categories=c("1 person", "2 people", "3 people", 
                                         "4 people", "5 people", "6 people",
                                         "7 people", "8 people"), labels=list(align="left")) %>%
      hc_add_series(name="60% AMI for various household sizes", data=round(incomeLevels$moderatelyLow, -2), type="column",
                   dataLabels=list(enabled=TRUE,format = "${point.y:,.0f}"), color="#315C5F"
                    ) %>%
    print(incomeAffordability)
  }
  )
  incomeAffordability <- readRDS("Data/rds/incomeAffordability.rds")
  output$plot17<-renderHighchart({ 
    incomeAffordability<-highchart()%>%
      hc_chart(type="bar")%>%
      hc_title(text="Income Affordability vs Median Home Price: Salt Lake City, 2017")%>%
      hc_xAxis(categories = c("Affordable to own (60% AMI)","Affordable to own (80% AMI)", "Median home price")) %>%
      hc_yAxis(labels=list(format= "${value}")) %>%
      hc_plotOptions(pointPadding = 0) %>%
      hc_series(list(name ="home price", colors=c("#2EADC5", "#36B885", "#2A3236"), 
                     data=c(incomeAffordability$`60Affordability`, incomeAffordability$`80Affordability`, incomeAffordability$MedianSale), 
                     colorByPoint=TRUE, dataLabels=list(enabled=TRUE,format= "${point.y:,.0f}"))
      )
    
    print(incomeAffordability)
  }
  )
  # create a bar chart for city AMI in "how did we get here" page ####
  output$graph1<-renderHighchart({
    AMI_plot<-highchart() %>%
      hc_chart(type="bar") %>%
      hc_title(text = "Salt Lake City Metropolitan Statistical Area Income Levels in 2017") %>%
      hc_yAxis(title = list(text = "Income in dollars")) %>%
      hc_xAxis(categories = c("1 person", "2 people", "3 people", 
                              "4 people", "5 people", "6 people",
                              "7 people", "8 people"),
               title = list(text = "Household sizes")) %>%
      hc_series(list(name="Extremely low income 30% AMI $", data=incomeLevels$extremelyLowAMI, color="#FBAA20"),
                list(name="Very low income 50% AMI $", data=incomeLevels$veryLow, color = "#2EADC5"),
                list(name="Moderately low income 60% AMI $", data=incomeLevels$moderatelyLow, color = "#36B885"),
                list(name="Low income 80% AMI $", data=incomeLevels$low, color = "#315C5F"),
                list(name="100% AMI $", data=incomeLevels$X100..AMI, color = "#2A3236")
      )%>%
      print(AMI_plot)
  }
  )
  # create a treemap for income in industries in SLC ####
  
  # industry ami and median income in "How"
  industryChart<-read.csv("Data/industryC.csv")
  tm <- treemap(industryChart, index =c("ami","profession"),
                vSize = "income", vColor = "income",
                type = "value", palette = c("#315C5F", "#343F44", "#676866", "#FBAA20", "#2EADC5", "#2A3236")
                #  rev(viridis(10))
                , colorByPoint = TRUE,
                draw = FALSE)
  
  output$graph2<-renderHighchart({
  Industry_hc<-highchart(height = 500) %>% 
    hc_add_series_treemap(tm, allowDrillToNode = TRUE,
                          layoutAlgorithm = "squarified",
                          name = "AMIdata") %>%
    hc_title(text = "AMI Percentage by Industry") %>% 
    hc_tooltip(pointFormat = "Average annual wage: ${point.value:.0f}<br>
               {point.name}")
  print(Industry_hc)
  }
  )
  # create a column chart for average rents and affordability ####
  averageRentsVsAffordability <- readRDS("Data/rds/averageRentsVsAffordability.rds")
  output$graph3<-renderHighchart({
    affordability1<-highchart() %>%
      hc_chart(type="column") %>%
      hc_title(text= "Salt Lake City Average Rents vs Affordability (80% AMI)") %>%
      hc_xAxis(categories = c("one-person household and 1Br average rent + utilities", 
                              "four-person household and 3Br average rent + utilities")) %>%

      hc_yAxis(labels=list(format= "${value}"))%>%
      hc_series(list(name ="Affordable rent", color = "#2EADC5",
                     data=averageRentsVsAffordability$`affordable_rent`, dataLabels=list(enabled=TRUE,format= "${point.y}")),
                list(name = "Average rent", color = "#2A3236",
                     data=averageRentsVsAffordability$`average_rent`, dataLabels=list(enabled=TRUE,format= "${point.y}"))

      ) %>%
      print(affordability1)
  }
  )
  # create two chart for the comparison between wage increase and home sale and rent increase ####
  wageIncreaseVsHomeSalePrice <- readRDS("Data/rds/wageIncreaseVsHomeSalePrice.rds")
  output$graph4<-renderHighchart({
    wageVsPrice<-highchart() %>%
    hc_chart(type="column") %>%
      hc_title(text = "Wage Increase vs Home Sale Price Increase: 2011-2014") %>%
      hc_yAxis(title = list(text = "increase in percentage"),
               labels=list(format= "{value}%")) %>%
      hc_xAxis(categories = c("Increase in homeowner wages", "Increase in home sale prices")) %>%
      hc_series(list(name="increase rate", data=wageIncreaseVsHomeSalePrice$percentage,
                     colorByPoint=TRUE)) %>%
      hc_plotOptions(series = list(boderWidth = 0, colors=c("#36B885", "#2A3236"),
                                   dataLabels = list(enabled = TRUE, format="{y}%") )) %>%
      print(wageVsPrice)
  }
  )
  wageIncreaseVsRent <- readRDS("Data/rds/wageIncreaseVsRent.rds")
  output$graph5<-renderHighchart({
    wageVsRent<-highchart() %>%
      hc_chart(type="column") %>%
      hc_title(text = "Wage Increase vs Rent Increase: 2011-2016") %>%
      hc_yAxis(title = list(text = "increase in percentage"),
               labels=list(format= "{value}%")) %>%
      hc_xAxis(categories = c("Increase in renter wages", "Increase in rent prices")) %>%
      hc_series(list(name="increase rate", data=wageIncreaseVsRent$percentage,
                     colorByPoint=TRUE)) %>%
      hc_plotOptions(series = list(boderWidth = 0, colors=c("#FBAA20", "#2A3236"),
                                   dataLabels = list(enabled = TRUE, format="{y}%") )) %>%
      print(wageVsRent)
  }
  )
  # leaflet ####
  output$home <- renderLeaflet({
    home_map
  })
  
  output$rent <- renderLeaflet({
    rent_map
  })
  
  output$a_out <- renderText({
    paste0("Cost-burderned household income: ", "<b>", dollar(as.numeric(neighborhoodRent$a_rent[which(neighborhoodRent$neighboarhood==input$neighborhood_type)]) * 12 / .3), "</b>", ";",
          "<br>","Severely cost-burdened income: ", "<b>", dollar(as.numeric(neighborhoodRent$a_rent[which(neighborhoodRent$neighboarhood==input$neighborhood_type)]) * 12 / .5), "</b>", ";", 
          "<br>", "HUD defines cost-burdened families as those “who pay more than 30 percent of their income for housing” and “may have difficulty affording necessities such as food, clothing, transportation, and medical care.” Severe rent burden is defined as paying more than 50 percent of one’s income on rent. The median rent in ", as.character(input$neighborhood_type), " is ", 
           dollar(neighborhoodRent$a_rent[which(neighborhoodRent$neighboarhood==input$neighborhood_type)]), 
           ". Therefore, a household with income below ", dollar(as.numeric(neighborhoodRent$a_rent[which(neighborhoodRent$neighboarhood==input$neighborhood_type)]) * 12 / .3), " would be considered cost-burdened. Below ", dollar(as.numeric(neighborhoodRent$a_rent[which(neighborhoodRent$neighboarhood==input$neighborhood_type)]) * 12 / .5), " would be severely rent burdened.")
  })
# Goal 1 #### 
 output$goal11 <- function() {
   Goal11 %>%
     knitr::kable("html") %>%
     kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"), full_width=T,position = "center") %>%
     column_spec(2, width = "50em")%>%
     column_spec(1, width = "10em") %>%
     column_spec(3, width = "30em") 
   }
 output$goal12 <- function() {
   Goal12 %>%
     knitr::kable("html") %>%
     kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"),full_width=T,position = "center")%>%
     column_spec(2, width = "50em")%>%
     column_spec(1, width = "10em") %>%
     column_spec(3, width = "30em") 
 }
 output$goal13 <-function() {
   Goal13 %>%
     knitr::kable("html") %>%
     kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"),full_width=T,position = "center")%>%
     column_spec(2, width = "50em")%>%
     column_spec(1, width = "10em") %>%
     column_spec(3, width = "30em") 
 }
 output$goal14 <- function() {
   Goal14 %>%
     knitr::kable("html") %>%
     kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"),full_width=T,position = "center")%>%
     column_spec(2, width = "50em")%>%
     column_spec(1, width = "10em") %>%
     column_spec(3, width = "30em") 
 }
 #Goal 2 #### 
 output$goal21 <- function() {
   Goal21 %>%
     knitr::kable("html") %>%
     kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"),full_width=T,position = "center")%>%
     column_spec(2, width = "50em")%>%
     column_spec(1, width = "10em") %>%
     column_spec(3, width = "30em") 
 }
 output$goal22 <- function() {
   Goal22 %>%
     knitr::kable("html") %>%
     kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"),full_width=T,position = "center")%>%
     column_spec(2, width = "50em") %>%
    column_spec(1, width = "10em") %>%
    column_spec(3, width = "30em") 
 }
 output$goal23 <- function() {
   Goal23 %>%
     knitr::kable("html") %>%
     kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"),full_width=T,position = "center")%>%
     column_spec(2, width = "50em")%>%
     column_spec(1, width = "10em") %>%
     column_spec(3, width = "30em") 
 }
 output$goal24 <- function() {
   Goal24 %>%
     knitr::kable("html") %>%
     kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"),full_width=T,position = "center")%>%
     column_spec(2, width = "50em")%>%
     column_spec(1, width = "10em") %>%
     column_spec(3, width = "30em") 
 }
 output$goal25 <- function() {
   Goal25 %>%
     knitr::kable("html") %>%
     kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"),full_width=T,position = "center")%>%
     column_spec(2, width = "50em")%>%
     column_spec(1, width = "10em") %>%
     column_spec(3, width = "30em") 
 }
 output$goal26 <- function() {
   Goal26 %>%
     knitr::kable("html") %>%
     kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"),full_width=T,position = "center")%>%
     column_spec(2, width = "50em")%>%
     column_spec(1, width = "10em") %>%
     column_spec(3, width = "30em") 
 }
 #Goal 3 #### 
 output$goal31 <- function() {
   Goal31 %>%
     knitr::kable("html") %>%
     kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"),full_width=T,position = "center")%>%
     column_spec(2, width = "50em")%>%
     column_spec(1, width = "10em") %>%
     column_spec(3, width = "30em") 
 }
 output$goal32 <- function() {
   Goal32 %>%
     knitr::kable("html") %>%
     kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"),full_width=T,position = "center")%>%
     column_spec(2, width = "50em")%>%
     column_spec(1, width = "10em") %>%
     column_spec(3, width = "30em") 
 }
 output$goal33 <- function() {
   Goal33 %>%
     knitr::kable("html") %>%
     kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"),full_width=T,position = "center")%>%
     column_spec(2, width = "50em")%>%
     column_spec(1, width = "10em") %>%
     column_spec(3, width = "30em") 
 }
 

}
# shinyApp ####
shinyApp(ui, server)
