 library(shiny)
 library(shinyjs)
 
 server = function(input, output) {
    observe({
      toggle(condition = input$foo, selector = "#navbar li a[data-value=tab2]")
    })
  }