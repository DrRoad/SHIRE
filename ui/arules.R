
tabPanel("A-rules",value ="Arules",style ="padding-top: 20px; padding-bottom: 15px;", 
  
  sidebarLayout(
        
        sidebarPanel(
          
          wellPanel(style ="background-color:white",
            h4(strong("Apriori ",icon("grain", lib = "glyphicon"))),
            h4(strong("Value Selector")),br(),
            uiOutput("support"),
            uiOutput("confidence"),
            uiOutput("minlen")
          ),width=3
        ),
        mainPanel(
            h4(strong("Setting limits.")),
            fluidRow(
                column(8,style="margin-bottom:-15px;",uiOutput("ar_tunningBox")), 
                column(4,style="margin-bottom:-15px;",uiOutput("ar_generateButton"))
            ),
            h4(style="margin-top:25px;",strong("Visualization",icon("sunglasses", lib = "glyphicon"))),
            uiOutput("ar_modelVis"),
            fluidRow(
              column(6,h4(strong("Association rules.")))
            ),
            fluidRow(
              column(12,uiOutput("arules"))      
            ),
            br(),
            width=9
        )    
    ) 
)