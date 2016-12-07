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
        text-align: left;
      }
      #unsupervised {
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
          column(12, align='center', 
            tags$div(id="title", 
              tags$img(id ="logo",
                  height = "100px",
                  width = "auto",
                  src = "logo.png"
              ),br(),br(),
              strong(p(style="color:#ffffff","Shire is a machine learning tool",br(),
              "for any data scientist or student who",br(),"want to utilize various Machine Learning techniques",br(),"by using Shiny of Rstudio."))
            ,
            column(6, offset =3,
              column(6,align='center',
                selectInput("techniques1", 
                  tags$div(id="supervised",icon("leaf", lib = "glyphicon"),strong("Supervised")), c("Linear regression", "Logistic regression", "Naive Bayes classifier","Artificial neural network", "Decision trees","k-nearest neighbor", "Support vector machines", "Random Forests","Boosting
                    ")
                )
              ),
              column(6, align='center',
                 selectInput("techniques2", 
                  tags$div(id="unsupervised",icon("leaf", lib = "glyphicon"),strong("Unsupervised")), c("Association rule", "K-means algorithm","PCA")           
                  )
              )
            ),    
            bsTooltip("supervised", 'If you need a target value for any new input, "SUPERVISED" techniques will be needed. ',
                  "left", options = list(container = "body")),
            bsTooltip("unsupervised", 'If you want to find the relationships between different inputs, you need to use "UNSUPERVISED" techniques.',
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
      ),

      tabPanel("Linear Regression"
      )


            

  )
)