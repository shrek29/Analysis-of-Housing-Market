



#############################################################################################################################################################################


library(shiny)
library(dplyr)
library(leaflet)

source("source_file.R")

#Define UI for application
shinyUI(fluidPage(
  
  #Header for title panel  
  titlePanel(title = h4("King's County Housing data", align = "center")),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("zipcode", "1. Select the zipcode from the dataset", choices = c("None", vars)),
      br(),
      
      sliderInput("slider", "2. Select the price of the house", min = minprice , max = maxprice , value = c(minprice, maxprice)  ),
      br(),
      
      radioButtons("var", "3. Select the variable from the dataset", choices = c("view" = 4, "condition" = 5, "month" = 8, "floors" = 3, "sqft_living" = 2 )),
      br()
      
    ),
    
  
    
    mainPanel(
      
      tabsetPanel(type = "tab",
                  tabPanel("Plot",   
                           
                           fluidRow(
                    
                            column(6, plotOutput("myaverageplot")),
                    
                            column(6, plotOutput("myboxplot"))
                            
                    
                           ),
                  
                           fluidRow(
                             
                             column(6, plotOutput("myscatterplot")),
                  
                             column(6, plotOutput("myhistplot"))
                    
                             )
                          ),
                  
                  tabPanel("Data",
                           
                           fluidRow(
                             
                             DT::dataTableOutput("datatable"),
                             
                             DT::dataTableOutput("trendtable")
                             
                             )
                           ),
                           
                  tabPanel("Map",
                           
                           leafletOutput("mymap", height = 650)
                  ))
      
     
    )
  )
))
