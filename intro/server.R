 library(shiny)
 library(shinyjs)
 library(shinyBS)
server = function(input, output,session) {

	shinyjs::addClass(id = 'menus', class = "navbar-right")


	# bsModal("greeting", "Greeting", input$hello, size = "large",tags$h1("hello"))
    
	
    observe({
      toggle(condition = input$foo, selector = "#navbar li a[data-value=tab2]")
    })

   
    # observeEvent(input$techniques,{



    # })







}