if (!require('shiny')){
  install.packages('shiny')
  
}
library('shiny')

if (!require('shinydashboard')){
  install.packages('shinydashboard')
  
}
library('shinydashboard')

shinyUI(
  dashboardPage(
    dashboardHeader(title = "Shiny Dashboard - Zomato Ratings Analysis", titleWidth = 600),
    
    
    dashboardSidebar(
      # add menu items to the sidebar
      # menu items are like tabs when clicked open up a page in tab item
      sidebarMenu(
        menuItem(text = "About", tabName = "about", icon=icon("clipboard")),
        menuItem("Data & Insights ", tabName = "data", icon=icon("database"))
        )
    ),
    
    
    dashboardBody(
      # Also add some custom CSS to make the title background area the same
      # color as the rest of the header.
      tags$head(tags$style(HTML('
                                /* logo */
                                .skin-blue .main-header .logo {
                                background-color: #000000;
                                }
                                
                                /* logo when hovered */
                                .skin-blue .main-header .logo:hover {
                                background-color: #555555;
                                }
                                
                                /* navbar (rest of the header) */
                                .skin-blue .main-header .navbar {
                                background-color: #000000;
                                }        
                                
                                /* main sidebar */
                                .skin-blue .main-sidebar {
                                background-color: #555555;
                                }
                                
                                /* active selected tab in the sidebarmenu */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                                background-color: #AAAAAA;
                                }
                                
                                /* other links in the sidebarmenu */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu a{
                                background-color: #AAAAAA;
                                color: #FFFFFF;
                                }
                                
                                /* other links in the sidebarmenu when hovered */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover{
                                background-color: #ff69b4;
                                }
                                /* toggle button when hovered  */                    
                                .skin-blue .main-header .navbar .sidebar-toggle:hover{
                                background-color: #ff69b4;
                                }
                                '))),
      tabItems(
        tabItem(tabName = "about", tags$h2("All about ZOMATO..!!"),
                                  p("Zomato is an Indian restaurant search and discovery service. It provides information and reviews on restaurants,"),
                                  p("including images of menus where the restaurant does not have its own website. It helps customers to find cheap and better food locations and make their life easier."),
                                  p("It operates in across many countries and cities some of which are shown below."),
                                  plotOutput("plot1"),
                                  tags$h2("Cuisines To Choose From!"),
                                  p("Zomato deals with various frenchisies and local restuarants to offer diverse and rich cuisines options to the customer and give them a satisfying experience. Major cuisine options can be seen in the pictures below."),
                                  plotOutput("plot2"),
                                  p("Also below diagram shows the number of restuarants offering some of the major food options."),
                                  plotOutput("plot3")
                
                
                                  
                
                
                ),
        tabItem(tabName = "data", tags$h2("Data Available"),
                                  p("Data provided contains the information of around 10000 local outlets with the cuisines options and facilites provided."),
                                  p("We can find insights in the data and relate Ratings with the facilities offered and other features of the data."),
                                  p("Boruto Package can be used to find the important features in the data. Results are shown as below."),
                                  tableOutput("table1"),
                                  p("As confirmed by the above table, these features are important in prediction of ratings of outlets."),  
                                  p("Below table of resturants shows outlets offering online services and rated either Excellent or Very Good in NCT region (to make analysis easier)"),
                                  tableOutput("table2"),
                                  p("Above table shows that the outlets in Gurugram perform better if they offer online Services"),
                                  tags$h3("Value For money == Good for taste && Good for Pocket"),
                                  p("In this section we highlight value for money outlets across Delhi NCR.Below charts shows number of outlets offering value for money services to foodies in NCT."),
                                  tableOutput("table3"),
                                  p("Below chart shows value for money outlets in various NCR regions. Ratings considered:Very Good,Excellent"),
                
                                  plotOutput("plot4"),
                                  p("As depicted by the above charts, New Delhi region have the most number of outlets out of which around 52% are value for your money and 58% of outlets in Noida are value for your money out of 29 outlets in Noida.")
                
                
                
                
                
                
                )
      )
      )
    
      )
)