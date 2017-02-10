
tabPanel("PCA",value ="PCA",style ="padding-top: 20px; padding-bottom: 15px;",
  
    sidebarLayout(
        
        sidebarPanel(
            width= 3
        ),
        mainPanel(
            # h4(strong("Model Visualization")),
            # uiOutput("modelVis"),br(),
            # uiOutput("tunningBox"),
            # uiOutput("generateButton"),
            # br(),
            # fluidRow(
            #   column(6,h4(strong("Model Logs"))),
            #   column(6,h5(strong("p-value & Adjusted R squared")))
            # ),
            # fluidRow(
            #   column(6,uiOutput("logs")),
            #   column(6,uiOutput("modelEval"))      
            # ),
            # h5(strong("Model information")),
            # uiOutput("modelMeasure"),
            # br()
            # ,
            width=9
        )
        
    ) 
  # fluidRow(
  #   column(11, style="margin-top: -40px;", uiOutput('pca_reportTitle'),
  #     uiOutput('pca_dataName'),hr())
  # )
  # fluidRow( 
  #   column(11, uiOutput('rawData'))
  # ),   
  # fluidRow(
  #   column(11,  
  #     column(8,
  #       uiOutput("plotAnal")
  #     ),                    
  #     column(4, uiOutput("factorAnal"))
  #   ),
  #   column(1, style = "margin-left : -17px;",
  #     absolutePanel(id = "controls", fixed = TRUE,
  #       draggable = TRUE, top = 50, left = "auto", right = "auto", bottom = "auto",

  #       wellPanel(style = "background-color: Lavender",
  #         h3(style ="font-family:Impact","Insert data"),
  #         fileInput("file1", "Choose CSV File", multiple = FALSE, accept = c("text/csv","text/comma-separated-values,text/plain",".csv"), width = '200px'),
  #         checkboxInput("header", "Header", TRUE)
  #       )
  #     )
  #   )                                             
  # )
)
