## app.R ##
library(shiny)
library(shinythemes)

# Choices for drop-downs
plots <- c(
  "Histogram" = "hist",
  "Boxplot" = "boxplot",
  "Scatter" = "scatter"
)


vars <- c(
  "charges" = "charges",
  "age" = "age",
  "BMI" = "bmi",
  "children" = "children"
)



ui <- fluidPage(theme = shinytheme("flatly"),navbarPage(title = p(style =" font-family:Impact","Linear Regression"),
                           
  # model generator.  

  tabPanel(title = "Model generator",
       
      sidebarLayout(
          
          sidebarPanel(
            
            wellPanel(style = "background-color: white",
              fileInput("file1", "Choose CSV File",multiple = FALSE, 
                                accept = c("text/csv","text/comma-separated-values,text/plain",".csv"),
                                width = '200px'),
              checkboxInput("header", "Header", TRUE)
            ),
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
              verbatimTextOutput("test"),
              uiOutput("tunningBox"),
              uiOutput("generateButton"),
              br(),
              h4(strong("Model Accuracy")),
              uiOutput("modelMeasure"),br(),
              
              fluidRow(
                column(6,h4(strong("Model Logs"))),
                column(6,h5(strong("p-value $ Adjusted R squared")))
              ),
              fluidRow(
                column(6,uiOutput("logs")),
                column(6,uiOutput("modelEval"))      
              )
          )
          
        )                            
           
          
        ),
   
  
        # Data exploration.
                           
         tabPanel("Data explorer",
                  uiOutput("dataPage"),
                  fluidRow(
                          column(7, 
                                  column(5, selectInput("plotType", "Plot Type",plots)),
                                  column(5, 
                                         selectInput("variable", "Variables", vars)),
                                  plotOutput("plot")
                          ),
                          column(5, p(style ="font-family:Impact","Summary"),
                                             verbatimTextOutput("summary"),br(),
                                             p(style ="font-family:Impact","Regional Data & Correlations"),
                                             verbatimTextOutput("table"),
                                             verbatimTextOutput("col")
                  )),br(),br(),br(),hr(),
                                    
                  fluidRow(
                          column(12, align = "center",dataTableOutput('dataTable')),
                          hr()
                  )
         )
))