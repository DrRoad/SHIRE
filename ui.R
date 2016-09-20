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
              uiOutput("modelPage2"),
              conditionalPanel(
                  condition = "input.exvaris == 'select'",
                  uiOutput("modelPage3"))
              ,
              uiOutput("modelPage4"),
              br(),br(),
              h4(p(style ="font-family:Impact","Data Types")),
              uiOutput("modelPage5"),
              br(),
              h4(p(style ="font-family:Impact","Model logs")),
              br()
            )
          ),
          mainPanel(
              h4(p(style ="font-family:Impact","Model Visualization")),
              uiOutput("modelPage6"),br(),
              textInput("tunnedModel", "Tunning Model", "Model"),
              uiOutput("generateButton"),
              br(),
              h4(p(style ="font-family:Impact","Model Accuracy")),
              uiOutput("modelPage7")
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