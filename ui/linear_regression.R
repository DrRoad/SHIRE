# model generator.  

tabPanel(title = "Linear Regression",
    
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
