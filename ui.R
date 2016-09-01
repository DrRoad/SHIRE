## app.R ##
library(shiny)

 
ui <- fluidPage(navbarPage(title = p(style ="font-family:Impact","Linear Regression"),
    
    tabPanel(title = "Making Model ",
      plotOutput("norm"),
      actionButton("renorm", "Resample")
    ),

    
    # Data exploration.
    
    tabPanel(
      title = "Data exploration",
     
      column(6, wellPanel(align = "center",
          plotOutput("hist"),br(),
          verbatimTextOutput("summary")
        ))
    ),

    
    ###
    tabPanel(title = "Chi Squared data",
      plotOutput("chisq"),
      actionButton("rechisq", "Resample")
    )

))