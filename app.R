library(shiny)
library(shinyjs)
library(shinyBS)
library(shinythemes)
library(TTR)
library(mapproj)
library(maps)
library(quantmod)
library(shinydashboard)
library(xts)

plots <- c(
  "Histogram" = "hist",
  "Boxplot" = "boxplot",
  "Scatter" = "scatter"
)

ui <- fluidPage( style = "background-color:white",
  tags$head(tags$title("SHIRE"),
    tags$style(HTML("
      
	      body {
	          padding-right : 0px;
	          padding-left : 0px;
	          background-attachment: fixed;
	          background-image: url('intro.jpg');
	          background-size: auto 100%;
	          background-position: center top;
	          background-color: rgb(245, 248, 250);
	      }
	      strong{
	          text-align: center;
	          text-color: black;
	      }
	      img {
	        display : block;
	        margin: auto;
	      }
	      .navbar { 
	          margin-bottom : 0px;
	          margin-left : -15px;
	          margin-right: -15px;
	      }
	      .shiny-output-error { visibility: hidden; } 
	      .shiny-output-error:before { visibility: hidden; }
	      .navbar.navbar.navbar-fixed-top.app-navbar {
	            background-color: #ffffff;
	            border-bottom-color: #bbb;
	      }
	      .text-center {
	          text-align: center;
	      }
	      .optgroup > div:first-child{
	        font-weight: bold;
	      }
	      .optgroup > div:second-child{
	        display : none;
	      }
	      #icon{
	        margin-top : -30px;
	      }
	      div#init-text {
	          opacity: 1;
	          font-weight: normal;
	          position: center;
	      }
	      #title {
	        position : fixed; 
	        top : 28%;
	        left: 15px;
	        right : 15px;
	        color:#000000;
	        z-index : 1;
	      }
	      #supervised {
	        font-size : 15px;
	      }
	      #unsupervised {
	        font-size : 15px;
	      }
	      #footer
	      {
	          position:fixed;
	          left : 15px;
	          right : 15px;
	          bottom:10px;
	      }
	      #controls {
	        /* Appearance */
	        background-color: Lavender;
	        padding: 0px 0px 0px 0px;
	        margin-top : -1%;
	        margin-right: -7%;
	        
	        cursor: move;
	        position: absolute;
	        z-index:3;
	        /* Fade out while not hovering */
	        opacity: 0.65;
	        zoom: 0.9;
	        transition: opacity 500ms;
	      }
	      #controls:hover {
	        /* Fade in while hovering */
	        opacity: 0.95;
	        transition-delay: 0;
	      }
	  "))
    #menus > li:first-child { display: none; }

	),theme = shinytheme("simplex"),useShinyjs(),
  	navbarPage(title = tags$a(href="/",img(id="icon", src="icon.PNG", height= 80, width= 110)),collapsible = TRUE, id = "menus", 
	  
	    # include the UI for each tab
	    source(file.path("ui", "main.R"),  local = TRUE)$value,
	    source(file.path("ui", "data_explorer.R"),  local = TRUE)$value,
	    source(file.path("ui", "linear_regression.R"),  local = TRUE)$value

	    
	)
)




server <- function(input, output, session) {

  data <- data.frame()
  vars <- c()
  commandLogs <- c()
  evalLogs <- c()
  model <- ""
  tempModel <- ""
  modelResult<- list()
  modelCount <- 1
  modelCount2 <- 1
  r.square <- c()
  p.value <- c()
  except_factors <- c()
  factors <- c()

  reacVars <- eventReactive(input$insertVariBox,{})
  evMethod <<- reactive(input$exvaris)
  selectedEvs <<- reactive(input$evSelected) 
  selectedDv <<- reactive(input$dfvari)
  modelCast <<- reactive(input$tunnedModel)
  plotSelected <<- reactive(input$plotType)
  variSelected <<- reactive(input$variable)
  factorSelected <<- reactive(input$factorSelector)
  #New Column Section ###
  #튜닝변수 설정.
  newName <<- reactive(input$newMemName)
  newDes <<- reactive(input$newMemDes)

  summaryQuery <<- reactive({
    paste(gsub(' ','',paste('summary(data$', variSelected(),')')))
  })
  boxplotQuery <<- reactive({
    paste(gsub(' ','',paste('boxplot(data$', variSelected())),',main="', paste("Boxplot of", variSelected()),'",notch= TRUE',')')
  })
  histQuery <<- reactive({
    paste(gsub(' ', '',paste('hist(data$',variSelected())),',main ="', paste("Histogram of",variSelected()),'")')
  })


  # Include the logic (server) for each tab
  source(file.path("server", "main.R"),  local = TRUE)$value
  source(file.path("server", "data_explorer.R"),  local = TRUE)$value
  source(file.path("server", "linear_regression.R"),  local = TRUE)$value
   
}

shinyApp(ui = ui, server = server)


    
   