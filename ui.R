## app.R ##
library(shiny)

# Choices for drop-downs
plots <- c(
  "Histogram" = "hist",
  "Boxplot" = "boxplot",
  "Scatter" = "scatter"
  )


vars <- c(
  "Charges" = "charges",
  "Age" = "age",
  "BMI" = "bmi",
  "Children" = "children"
)


 
ui <- fluidPage(navbarPage(title = p(style ="font-family:Impact","Linear Regression"),
    
    tabPanel(title = "Model producer"),

    
    # Data exploration.
    
    tabPanel("Data explorer",
   
     fluidRow(
       column(7, 
             
                column(5, selectInput(
                "plotType", "Plot Type",plots)
                ),
                column(5, selectInput(
                    "variable", "Variables", vars)
                ),
                plotOutput("plot")
          ),
          
        column(5, p(style ="font-family:Impact","Summary"),
                  verbatimTextOutput("summary"),br(),
                  p(style ="font-family:Impact","Regional Data & Correlations"),
                  verbatimTextOutput("table"),
                  verbatimTextOutput("col")
          )
        
      ),br(),br(),br(),hr(),
     
     fluidRow(
         column(12, align = "center",dataTableOutput('dataTable')),
         hr()
       )
     
     
    )

))