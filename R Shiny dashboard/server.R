
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(leaflet)
library(sp)

shinyServer(
  
  function(input, output) {
    
    colm = reactive({
      
      as.numeric(input$var)
    
      })
    
    zipcode_data = reactive({
      
       if(input$zipcode != "None" ) {
        
       a = subset(kings_house_data_final, kings_house_data_final[, 7] == input$zipcode & kings_house_data_final$price  >= input$slider[1] &
                    kings_house_data_final$price  <= input$slider[2] )
       
       }
       
      else {
          
       a = subset(kings_house_data_final,  kings_house_data_final$price >= input$slider &
                    kings_house_data_final$price  <= input$slider[2] )
        
       }
      
      return(a) 
      
      
      })
    
    output$myboxplot = renderPlot({
      
      if(colm() != "2"){
      
      zipcode_data1 = zipcode_data()
      
      boxplot(log(zipcode_data1$price) ~ zipcode_data1[,colm()], main = "Box-Plot of King's County dataset", 
              xlab = names(kings_house_data_final[colm()]), ylab = "Log Price", col = "red")
    
      }})
    
    output$myaverageplot = renderPlot({
      
      if(colm() != "2"){
        
        zipcode_data1 = zipcode_data()
        
        aggregate = zipcode_data1 %>% group_by(zipcode_data1[, colm()]) %>% summarise(price = mean(price))
        
        aggregate = as.data.frame(aggregate)
        
        plot(log(aggregate$price) ~ aggregate[,1], main = "Trend Plot of King's County dataset", 
             xlab = names(kings_house_data_final[colm()]), ylab = "Average Log Price", col = "red", type = "o")
        
      }
    })
    
    
    output$myscatterplot = renderPlot({
      
      if(colm() == "2"){

      zipcode_data1 = zipcode_data()

      plot(zipcode_data1$price ~ zipcode_data1[,colm()], main = "Scatter Plot of King's County dataset",
           xlab = names(kings_house_data_final[colm()]), ylab = "Price", col = "red")

      }
    })
    
    output$myhistplot = renderPlot({
      
      if(colm() == "2"){
        
        zipcode_data1 = zipcode_data()
        
        
        hist(log(zipcode_data1[, colm()]), main = "Distribution of sqft living", 
             xlab = names(kings_house_data_final[colm()]), ylab = "Frequency", col = "red", type = "o")
        
      }
    })
    
    
    output$datatable = DT::renderDataTable({
      
      
      zipcode_data1 = zipcode_data()
      
      DT::datatable(zipcode_data1[c(7, colm(), 1)], options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
      
      
    })
    
    
    output$trendtable = DT::renderDataTable({
      
      zipcode_data1 = zipcode_data()
      
      aggregate = zipcode_data1 %>% group_by(zipcode_data1[, colm()]) %>% summarise(price = round(mean(price), 3))
      
      aggregate = as.data.frame(aggregate)
      
      colnames(aggregate) = c(names(kings_house_data_final[colm()]), "Average Price")
      
      DT::datatable(aggregate, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
      
    },caption = "Sample Data")
    
    
    output$mymap = renderLeaflet({
      
      zipcode_data1 = zipcode_data()
      
      lat_median = median(zipcode_data1$lat)
      long_median = median(zipcode_data1$long)
      
      
      factpal = colorFactor(palette = c("red", "blue", "green"),  zipcode_data1[, colm()])
      
      leaflet(zipcode_data1) %>% addTiles() %>%
        
        fitBounds(~min(long), ~min(lat), ~max(long), ~max(lat)) %>%  addProviderTiles("CartoDB.Positron") %>% 
        
        addCircles(lng = ~long, lat = ~lat, color = ~factpal(zipcode_data1[, colm()])) %>%
        
      #  setView(lng = long_median, lat = lat_median, zoom = 10) %>%
        
        addLegend("bottomright", pal = factpal, values = ~zipcode_data1[, colm()],
                  title = names(kings_house_data_final[colm()]),
                  opacity = 8)
      
    })
    
   
  })


   

