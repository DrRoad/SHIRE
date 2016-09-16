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
                                    
           
           fluidRow(
             column(3,
                    fileInput("file1", "Choose CSV File",multiple = FALSE, 
                              accept = c("text/csv","text/comma-separated-values,text/plain",".csv"),
                              width = '200px')
             ),
             column(3,
                    checkboxInput("header", "Header", TRUE),
                    textOutput("result"))
           ),
           
           fluidRow(
                 column(6, uiOutput("modelPage")),
                 column(6, 
                        conditionalPanel(
                          condition = "input$action == TRUE",
                          plotOutput("model")
                        ))
           )
           
           
           
        ),
   
  
        # Data exploration.
                           
         tabPanel("Data explorer",
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