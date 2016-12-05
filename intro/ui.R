library(shiny)
library(shinyjs)
library(shinyBS)
library(shinythemes)


ui <- fluidPage( style = "background-color:white",
  tags$head(
    tags$style(HTML("
      strong{
          text-align: center;
          text-color: black;
      }
      img {
        display : block;
        margin: auto;
      }
      img#logo {
        margin-top : 12%;
        margin-bottom: 30px;

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
      div#init-text {
          opacity: 1;
          font-weight: normal;
          position: center;
      }
      

  "))
    #menus > li:first-child { display: none; }

),theme = shinytheme("simplex"),useShinyjs(),navbarPage(title = tags$a(href="/",img(id="icon", src="icon.PNG", height= 80, width= 110)),collapsible = TRUE, id = "menus",
  
      # Home                
      tabPanel("Welcome", 
        style = 
         "background-attachment: fixed;
          background-image: url('intro.jpg');
          background-size: auto 100%;
          background-position: center top;
          background-color: rgb(245, 248, 250);
          padding-right: 0px;
          margin-right : -30px;
          margin-left : -30px;
          align-items: center;",

        fluidRow( 
          column(12, align="center",
            tags$img(id ="logo",
              height = "100px",
              width = "auto",
              src = "logo.png"
            ),
            strong(p(style="color:#ffffff","Shire is a machine learning tool",br(),
            "for any data scientist or student who",br(),"want to utilize various Machine Learning techniques",br(),"by using Shiny of Rstudio."))

            ,selectInput("techniques", "Select technique", list(
              "Supervised" = c("Linear regression", "Logistic regression", "Naive Bayes classifier","Artificial neural network", "Decision trees","k-nearest neighbor", "Support vector machines", "Random Forests","Boosting
                "),
              "Unsupervised" = c("Association rule learning", "K-means algorithm","Principal Components Analysis")
              )
            ),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br()
          )
        ),

        fluidRow(
            column(12, 
              tags$img(
                height = "60px",
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