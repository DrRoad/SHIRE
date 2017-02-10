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
library(arules)
library(arulesViz)
library(visNetwork)
library(igraph)


plots <- c(
    "Histogram" = "hist",
    "Boxplot" = "boxplot",
    "Scatter" = "scatter"
)
ar_plots <- c(
	"MinSupp" = "minSupp",
	"TopN" = "topN"
)
ar_orderBy <- c(
	"Support" = "support",
	"Confidence" = "confidence",
	"Lift" = "lift"
)
ar_howMany <- c(
	"5" = "5",
	"10" = "10",
	"15" = "15",
	"20" = "20",
	"30" = "30"
)

withBusyIndicatorUI <- function(button) {
  id <- button[['attribs']][['id']]
  div(
    `data-for-btn` = id,
    button,
    span(
      class = "btn-loading-container",
      hidden(
        img(src = "ajax-loader-bar.gif", class = "btn-loading-indicator"),
        icon("check", class = "btn-done-indicator")
      )
    ),
    hidden(
      div(class = "btn-err",
          div(icon("exclamation-circle"),
              tags$b("Error: "),
              span(class = "btn-err-msg")
          )
      )
    )
  )
}

withBusyIndicatorServer <- function(buttonId, expr) {
  
  
  	loadingEl <- sprintf("[data-for-btn=%s] .btn-loading-indicator", buttonId)
  
  # UX stuff: show the "busy" message, hide the other messages, disable the button
  doneEl <- sprintf("[data-for-btn=%s] .btn-done-indicator", buttonId)
  errEl <- sprintf("[data-for-btn=%s] .btn-err", buttonId)
  shinyjs::disable(buttonId)
  shinyjs::show(selector = loadingEl)
  shinyjs::hide(selector = doneEl)
  shinyjs::hide(selector = errEl)
  on.exit({
    shinyjs::enable(buttonId)
    shinyjs::hide(selector = loadingEl)
  })
  
  # Try to run the code when the button is clicked and show an error message if
  # an error occurs or a success message if it completes
  tryCatch({
    value <- expr
    shinyjs::show(selector = doneEl)
    shinyjs::delay(2000, hide(selector = doneEl, anim = TRUE, animType = "fade", time = 0.5))
    value
  }, error = function(err) { errorFunc(err, buttonId) })
}

errorFunc <- function(err, buttonId) {
  errEl <- sprintf("[data-for-btn=%s] .btn-err", buttonId)
  errElMsg <- sprintf("[data-for-btn=%s] .btn-err-msg", buttonId)
  errMessage <- gsub("^ddpcr: (.*)", "\\1", err$message)
  html(html = errMessage, selector = errElMsg)
  shinyjs::show(selector = errEl, anim = TRUE, animType = "fade")
}




ui <- fluidPage( style = "background-color:white",useShinyjs(),
  tags$head(tags$title("SHIRE"),
    tags$style(HTML("
      
	      body {
	      	  padding-top : 10px;
	          padding-right : 15px;
	          padding-left : 15px;
	          padding-bottom : 60px;
	          margin-top : -15px;
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
	      .shiny-output-error { visibility: hidden; } 
     	  .shiny-output-error:before { visibility: hidden; }
	      .navbar { 
	      	  padding-top : 5px;
	          margin-bottom : -5px;
	          margin-left : -30px;
	          margin-right: -30px;
	      }
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
	      .btn-loading-container {
		    margin-left: 10px;
		    font-size: 1.2em;
		  }
		  .btn-fileread-indicator {
		  	margin-top: 0px; 
		   
		    font-size: 1.2em;
		  }
		  .btn-loading-indicator {
		  	margin-top: -25px; 
		    margin-left: 150px;
		    font-size: 1.2em;
		  }
		  .btn-done-indicator {
		    color: green;
		  }
		  .btn-err {
		    margin-top: 10px;
		    color: red;
		  }
		  .controls {
	        /* Appearance */
	        background-color: Lavender;
	        padding: 0px 0px 0px 0px;
	        margin-left : -20px;
	        cursor: move;
	        position: absolute;
	        z-index:3;
	        /* Fade out while not hovering */
	        opacity: 0.65;
	        zoom: 0.9;
	        transition: opacity 500ms;
	      }
	      .controls:hover {
	        /* Fade in while hovering */
	        opacity: 0.95;
	        transition-delay: 0;
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
	          z-index : -1;
	      }
	      
	      
	  "))
    #menus > li:first-child { display: none; }

	),theme =  shinytheme("simplex"),
  	navbarPage(title = tags$a(href="/",img(id="icon", src="icon.PNG", height= 80, width= 110)),collapsible = TRUE, id = "menus", 
	  
	    # include the UI for each tab
	    source(file.path("ui", "main.R"),  local = TRUE)$value,
	    source(file.path("ui", "de_linear.R"),  local = TRUE)$value,
	    source(file.path("ui", "de_arules.R"),  local = TRUE)$value,
	    source(file.path("ui", "de_pca.R"),  local = TRUE)$value,
	    source(file.path("ui", "linear_regression.R"),  local = TRUE)$value,
	    source(file.path("ui", "logistic_regression.R"),  local = TRUE)$value,
	    source(file.path("ui", "naive_bayes.R"),  local = TRUE)$value,
	    source(file.path("ui", "neural_network.R"),  local = TRUE)$value,
	    source(file.path("ui", "decision_trees.R"),  local = TRUE)$value,
	    source(file.path("ui", "k-nearest.R"),  local = TRUE)$value,
	    source(file.path("ui", "svm.R"),  local = TRUE)$value,
	    source(file.path("ui", "random_forests.R"),  local = TRUE)$value,
	    source(file.path("ui", "boosting.R"),  local = TRUE)$value,
	    source(file.path("ui", "arules.R"),  local = TRUE)$value,
	    source(file.path("ui", "k-means.R"),  local = TRUE)$value,
	    source(file.path("ui", "pca.R"),  local = TRUE)$value,
	    
	    
	    fluidRow(
	      column(12, 
	        tags$img(id='footer',
	          height = "32px",
	          width = "auto",
	          src = "copyright.png"
	         ) 
	      )   
	    )

	    
	)
)




server <- function(input, output, session) {

# increase the limit of input file size.--------------------------
options(shiny.maxRequestSize=30*1024^2) 

shinyjs::hide(selector=".navbar li")
# main & 
# linear regression variables ------------------------------------
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
  childNum <- ""
  
  reacVars <- eventReactive(input$insertVariBox,{})
  evMethod <<- reactive(input$exvaris)
  selectedEvs <<- reactive(input$evSelected) 
  selectedDv <<- reactive(input$dfvari)
  modelCast <<- reactive(input$tunnedModel)
  plotSelected <<- reactive(input$plotType)
  variSelected <<- reactive(input$variable)
  factorSelected <<- reactive(input$factorSelector)
  techSelected <<- reactive(input$techniques1)
  techSelected2 <<- reactive(input$techniques2)
  
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
# arules variables  ------------------------------------------------
  trans <<- list()
  headItems <- c()
  #de_arules.R
  ar_minSuppSelected <<- reactive(input$ar_minSuppPoint)
  ar_topNSelected <<- reactive(input$ar_topNPoint)
  ar_plotSelected <<- reactive(input$ar_plotType) 

  #arules.R 
  ar_suppSelected <<- reactive(input$suppValue)
  ar_cnfSelected <<- reactive(input$cnfValue)
  ar_minlenSelected <<- reactive(input$minlenValue)
  rulesCast <<- reactive(input$tunnedRules)
  ar_orderBySelected <<- reactive(input$ar_orderBy)
  ar_howManySelected <<- reactive(input$ar_howMany)


  minSuppQuery <<- reactive({
    paste("itemFrequencyPlot(trans, support=",(ar_minSuppSelected()*0.01), paste(",main='Items above",gsub(" ","",paste(ar_minSuppSelected(),"%")), "Support')")) 
  })
  topNQuery <<- reactive({
  	paste("itemFrequencyPlot(trans, topN=", ar_topNSelected(), paste(",main='Top",ar_topNSelected(), "items')"))
    
  })	
  
# Include the logic (server) for each tab-----------------------------
  source(file.path("server", "main.R"),  local = TRUE)$value
  source(file.path("server", "de_linear.R"),  local = TRUE)$value
  source(file.path("server", "de_arules.R"), local =TRUE)$value
  source(file.path("server", "de_pca.R"), local =TRUE)$value
  source(file.path("server", "linear_regression.R"),  local = TRUE)$value
  source(file.path("server", "arules.R"), local = TRUE)$value
   
}




shinyApp(ui = ui, server = server)


    
   