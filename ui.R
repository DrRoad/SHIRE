## app.R ##
if(! "TTR"%in% installed.packages()) install.packages('TTR')
if(! "mapproj"%in% installed.packages()) install.packages('mapproj')
if(! "maps"%in% installed.packages()) install.packages('maps')
if(! "quantmod"%in% installed.packages()) install.packages('quantmod')
if(! "shinydashboard"%in% installed.packages()) install.packages('shinydashboard')
if(! "xts"%in% installed.packages()) install.packages('xts')
library(shiny)
library(shinythemes)
library(TTR)
library(mapproj)
library(maps)
library(quantmod)
library(shinydashboard)
library(xts)


# Choices for drop-downs
plots <- c(
  "Histogram" = "hist",
  "Boxplot" = "boxplot",
  "Scatter" = "scatter"
)

ui <- fluidPage( style = "background-color:white",
  tags$head(
    tags$style(HTML("
     img
     {
      display: block;
      margin-left: auto;
      margin-right: auto;
      margin-bottom: 50px;
      margin-top : 50px;
     }
     .shiny-output-error { visibility: hidden; } 
     .shiny-output-error:before { visibility: hidden; }
     #controls {
        /* Appearance */
        background-color: Lavender;
        padding: 0px 0px 0px 0px;
        cursor: move;
        position: absolute;
        z-index:3;
        /* Fade out while not hovering */
        opacity: 0.65;
        zoom: 0.9;
        transition: opacity 500ms 1s;
      }
      #controls:hover {
        /* Fade in while hovering */
        opacity: 0.95;
        transition-delay: 0;
      }
  "))
),theme = shinytheme("flatly"),navbarPage(title = p(style =" font-family:Impact","Linear Regression"),
                           
   
  
      # Data exploration.
                         
       tabPanel("Data explorer",
               uiOutput("dataPage"),
                  fluidRow(
                        column(10, 
                          column(8,
                            column(6, uiOutput("plotType")),
                            column(6, uiOutput("variInput")),
                            uiOutput("plotAnal")
                          ),                    
                          column(4, uiOutput("factorAnal"))    
                        ),
                        column(2,
                          absolutePanel(id = "controls", fixed = TRUE,
                            draggable = TRUE, top = 80, left = "auto", right = 18, bottom = "auto",

                            wellPanel(style = "background-color: Lavender",
                              h3(style ="font-family:Impact","Insert data File"),
                              fileInput("file1", "Choose CSV File", multiple = FALSE, 
                                                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv"),
                                                  width = '200px'),
                              checkboxInput("header", "Header", TRUE)
                            )
                          )
                        )                                               
                    ),
                    fluidRow( 
                       column(10, hr(),wellPanel(style = "background-color: WhiteSmoke",dataTableOutput('dataTable')))
                    ),
                    fluidRow(
                      column(12, 
                        hr(),
                        tags$img(
                          height = "40px",
                          width = "auto",
                          align = "center",
                          src = "copyright.png") 
                      )  
                    )               
        ),
        # model generator.  

        tabPanel(title = "Model generator",
            
            sidebarLayout(
                
                sidebarPanel(
                  
                  
                  wellPanel(style ="background-color:white",
                    h4(strong("Value Selector")),
                    uiOutput("dvSelector"),
                    uiOutput("evChoice"),
                    conditionalPanel(
                        condition = "input.exvaris == 'select'",
                        uiOutput("evSelector")
                    ),           
                    br(),
                    h4(strong("Data Types")),
                    uiOutput("dataType")
                  )
                ),
                mainPanel(
                    h4(strong("Model Visualization")),
                    uiOutput("modelVis"),br(),
                    uiOutput("tunningBox"),
                    uiOutput("generateButton"),
                    br(),
                    fluidRow(
                      column(6,h4(strong("Model Logs"))),
                      column(6,h5(strong("p-value & Adjusted R squared")))
                    ),
                    fluidRow(
                      column(6,uiOutput("logs")),
                      column(6,uiOutput("modelEval"))      
                    ),
                    h5(strong("Model information")),
                    uiOutput("modelMeasure")
                )
                
              ),
              fluidRow(
                column(12, 
                  hr(),
                  tags$img(
                    height = "40px",
                    width = "auto",
                    align = "center",
                    src = "copyright.png") 
                )  
              )                                     
            )
))