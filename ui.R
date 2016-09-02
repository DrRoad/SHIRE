## app.R ##
library(shiny)

# Choices for drop-downs
vars <- c(
  "Charges" = "charges",
  "Age" = "age",
  "BMI" = "bmi",
  "Children" = "children"
)


 
ui <- fluidPage(navbarPage(title = p(style ="font-family:Impact","Linear Regression"),
    
    tabPanel(title = "Model producer",
             
             sidebarPanel(
               selectInput(
                 "plotType", "Plot Type",
                 c(Scatter = "scatter",
                   Histogram = "hist")),
               
               # Only show this panel if the plot type is a histogram
               conditionalPanel(
                 condition = "input.plotType == 'hist'",
                 selectInput(
                   "breaks", "Breaks",
                   c("Sturges",
                     "Scott",
                     "Freedman-Diaconis",
                     "[Custom]" = "custom")),
                 
                 # Only show this panel if Custom is selected
                 conditionalPanel(
                   condition = "input.breaks == 'custom'",
                   sliderInput("breakCount", "Break Count", min=1, max=1000, value=10)
                 )
               )
             )         
             
    ),

    
    # Data exploration.
    
    tabPanel("Data explorer",
   
     fluidRow(
       column(7, 
             
                column(5, selectInput(
                "plotType", "Plot Type",c( Histogram = "hist", Scatter = "scatter"),selected = "hist")
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