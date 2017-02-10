
tabPanel("Data explorer",value ="de_arules", 
  
  fluidRow(
    column(11, style="margin-top: -40px;", uiOutput('reportTitle2'),
      uiOutput('dataName2'),hr())
  ),
  fluidRow(column(11, uiOutput('headItems'))),
  fluidRow(column(11, uiOutput('listData'))),
  fluidRow(column(11,style = "margin-bottom : 10px;", hidden(uiOutput('ar_infoButton')))),   
  fluidRow(
    column(11,  style = "margin-top : -10px;",
        hidden(uiOutput("frequencyPlot"))
    )                                             
  ),
  fluidRow(column(11, hidden(uiOutput('ar_summary1')))),
  fluidRow(
    column(11, hidden(uiOutput('ar_summary2')))
    ,
    column(1, style = "margin-left : -17px;",
      absolutePanel(class = "controls", fixed = TRUE,
        draggable = FALSE, top = 50, left = "auto", right = "auto", bottom = "auto",

        wellPanel(style = "background-color: Lavender",
          h3(style ="font-family:Impact","Insert data"),
          fileInput("file2", "Choose CSV File", multiple = FALSE, accept = c("text/csv","text/comma-separated-values,text/plain",".csv"), width = '200px'),
          checkboxInput("header", "Header", TRUE)
        )
      )
    )
  )
)