library(shiny)
library(shinyjs)
library(shinythemes)


ui <- fluidPage( style = "background-color:white",
  tags$head(
    tags$style(HTML("
     
     body{
      background-attachment: fixed;
      background-image: url('intro.jpg');
      background-size: auto 100%;
      background-position: center top;
      background-color: rgb(245, 248, 250);
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
     #icon{
      margin-top : -13px;
     }
  "))
),theme = shinytheme("flatly"),navbarPage(title = img(id="icon", src="icon.PNG", height= 48, width= 100),
  
      # Data exploration.
                         
       tabPanel("Data explorer"
                           
        ),
        # model generator.  

        tabPanel(title = "Model generator"
            
        
          )
      )
)