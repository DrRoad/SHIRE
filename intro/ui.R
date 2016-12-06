library(shiny)
library(shinyjs)
library(shinyBS)
library(shinythemes)


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
      #icon{
        margin-top : -30px;
      }
      #techniques {
          align : left;
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
      #question {
        font-size : 15px;
        text-align: left;
      }
      #footer
      {
          position:fixed;
          left : 15px;
          right : 15px;
          bottom:10px;
      }
  "))
    #menus > li:first-child { display: none; }

),theme = shinytheme("simplex"),useShinyjs(),navbarPage(title = tags$a(href="/",img(id="icon", src="icon.PNG", height= 80, width= 110)),collapsible = TRUE, id = "menus", 
  
      # Home                
      tabPanel("Welcome", style="margin-bottom: -5px;",
        fluidRow(
          column(12,align='center',
            
            tags$div(id="title", 
              tags$img(id ="logo",
                  height = "100px",
                  width = "auto",
                  src = "logo.png"
              ),br(),br(),
              strong(p(style="color:#ffffff","Shire is a machine learning tool",br(),
              "for any data scientist or student who",br(),"want to utilize various Machine Learning techniques",br(),"by using Shiny of Rstudio."))

              ,selectInput("techniques", tags$div(id="question", style ="align: right;",strong("Select a technique _____________________",icon("question-sign", lib = "glyphicon"))), list(
                "SUPERVISED" = c("Linear regression", "Logistic regression", "Naive Bayes classifier","Artificial neural network", "Decision trees","k-nearest neighbor", "Support vector machines", "Random Forests","Boosting
                  "),
                "UNSUPERVISED" = c("Association rule learning", "K-means algorithm","Principal Components Analysis")
                )),
                bsTooltip("question", 'If you need a target value for any new input, "SUPERVISED" techniques will be needed. Contrary, if you need to find the structure or relationships between different inputs, you need to use "UNSUPERVISED" techniques.',
                  "right", options = list(container = "body"))
            )
          )
        ),

        fluidRow(
            column(12, 
              tags$img(id='footer',
                height = "35px",
                width = "auto",
                src = "copyright.png"
               ) 
            )   
         )
      ),

      # Greeting 
      tabPanel("About"
      )
            

  )
)