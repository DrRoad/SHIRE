tabPanel("Data explorer",value ="de_pca", 
  
  fluidRow(
    column(11, style="margin-top: -40px;", uiOutput('pca_reportTitle'),
      uiOutput('pca_dataName'),hr())
  ),
  fluidRow( 
    column(11, uiOutput('pca_rawData'))
    ,column(1, style = "margin-left : -17px;",
      absolutePanel(class = "controls", fixed = TRUE,
        draggable = FALSE, top = 50, left = "auto", right = "auto", bottom = "auto",

        wellPanel(style = "background-color: Lavender",
          h3(style ="font-family:Impact","Insert data"),
          fileInput("file3", "Choose CSV File", multiple = FALSE, accept = c("text/csv","text/comma-separated-values,text/plain",".csv"), width = '200px'),
          checkboxInput("header", "Header", TRUE)
        )
      )
    )
  ),
  fluidRow(
    column(11, uiOutput('pca_preprocessor'))
  )
  # fluidRow(column(11, uiOutput('headItems'))),
  # fluidRow(column(11, uiOutput('listData'))),
  # fluidRow(column(11,style = "margin-bottom : 10px;", hidden(uiOutput('ar_infoButton')))),   
  # fluidRow(
  #   column(11,  style = "margin-top : -10px;",
  #       hidden(uiOutput("frequencyPlot"))
  #   )                                             
  # ),
  # fluidRow(column(11, hidden(uiOutput('ar_summary1')))),
  # fluidRow(
  #   column(11, hidden(uiOutput('ar_summary2'))),
  #   column(1, style = "margin-left : -17px;",
  #     absolutePanel(id = "controls2", fixed = TRUE,
  #       draggable = TRUE, top = 50, left = "auto", right = "auto", bottom = "auto",

  #       wellPanel(style = "background-color: Lavender",
  #         h3(style ="font-family:Impact","Insert data"),
  #         fileInput("file2", "Choose CSV File", multiple = FALSE, accept = c("text/csv","text/comma-separated-values,text/plain",".csv"), width = '200px'),
  #         checkboxInput("header", "Header", TRUE)
  #       )
  #     )
  #   )
  # )
)