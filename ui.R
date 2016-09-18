## app.R ##
library(shiny)

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



ui <- fluidPage(navbarPage(title = p(style =" font-family:Impact","Linear Regression"),
                           
  # model generator 
                           
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
              h4(p(style ="font-family:Impact","Value Selector")),           
              uiOutput("modelPage"),
              #  Explanatory variables. 
              selectInput("exvaris", "EV(Explanatory variables):",c("all-except DV","except factors","select")),
              conditionalPanel(
                  condition = "input.exvaris == 'select'",
                  uiOutput("modelPage2"))
              ,
              actionButton("action","Generate Model ",icon("refresh")),
              br(),br(),
              h4(p(style ="font-family:Impact","Data Types")),
              verbatimTextOutput("str")
            )
          ),
          mainPanel(
            conditionalPanel(
              condition = "input$action == TRUE",
              plotOutput("model")
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