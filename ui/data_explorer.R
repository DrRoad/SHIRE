tabPanel("Data explorer",
       uiOutput("dataPage"),
          fluidRow(
                column(10, 
                  column(8,
                    column(6, uiOutput("plotType")),
                    column(6, uiOutput("variInput")),
                    uiOutput("plotAnal")
                  ),                    
                  column(4, uiOutput("factorAnal"))    
                ),
                column(2,
                  absolutePanel(id = "controls", fixed = TRUE,
                    draggable = TRUE, top = 80, left = "auto", right = 18, bottom = "auto",

                    wellPanel(style = "background-color: Lavender",
                      h3(style ="font-family:Impact","Insert data File"),
                      fileInput("file1", "Choose CSV File", multiple = FALSE, 
                                          accept = c("text/csv","text/comma-separated-values,text/plain",".csv"),
                                          width = '200px'),
                      checkboxInput("header", "Header", TRUE)
                    )
                  )
                )                                               
            ),
            fluidRow( 
               column(10, hr(),wellPanel(style = "background-color: WhiteSmoke",dataTableOutput('dataTable')))
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
