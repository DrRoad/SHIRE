
tabPanel("Data explorer",value ="report", 
  fluidRow(
    column(11, style="margin-top: -40px;", uiOutput('reportTitle'),
      uiOutput('dataName'),hr())
  ),
  fluidRow( 
    column(11, uiOutput('rawData'))
  ),   
  fluidRow(
    column(11,  
      column(8,
        uiOutput("plotAnal")
      ),                    
      column(4, uiOutput("factorAnal"))
    ),
    column(1, style = "margin-left : -17px;",
      absolutePanel(id = "controls", fixed = TRUE,
        draggable = FALSE, top = 50, left = "auto", right = "auto", bottom = "auto",

        wellPanel(style = "background-color: Lavender",
          h3(style ="font-family:Impact","Insert data"),
          fileInput("file1", "Choose CSV File", multiple = FALSE, accept = c("text/csv","text/comma-separated-values,text/plain",".csv"), width = '200px'),
          checkboxInput("header", "Header", TRUE)
        )
      )
    )                                             
  )
)
