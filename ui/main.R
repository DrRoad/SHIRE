
tabPanel("Welcome", style="margin-bottom: -5px;",
  fluidRow(
    column(12, align='center', 
      tags$div(id="title", 
        tags$img(id ="logo",
            height = "100px",
            width = "auto",
            src = "logo.png"
        ),br(),br(),
        strong(p(style="color:#ffffff","Shire is a machine learning tool",br(),
        "for any data scientist or student who",br(),"want to utilize various Machine Learning techniques",br(),"by using Shiny of Rstudio."))
      ,
      column(6, offset =3,
        column(6,align='center',
          selectInput("techniques1", 
            tags$div(id="supervised",icon("leaf", lib = "glyphicon"),strong("Supervised")), c("Learnings"="nothing","Linear regression" = "linear", "* Logistic regression"="logistic", "* Naive Bayes classifier"="naive","* Artificial neural network"="neural", "* Decision trees"="decision","* k-nearest neighbor"="k-nearest", "* Support vector machines"="SVM", "* Random Forests"="forest","* Boosting
              "="boosting")
          )
        ),
        column(6, align='center',
           selectInput("techniques2", 
            tags$div(id="unsupervised",icon("leaf", lib = "glyphicon"),strong("Unsupervised")), c("Learnings"="nothing","* Association rule"="Arules", "* K-means algorithm"="k-means","* PCA"="PCA")           
            )
        )
      ),    
      bsTooltip("supervised", 'If you need a target value for any new input, "SUPERVISED" techniques will be needed. ',
            "left", options = list(container = "body")),
      bsTooltip("unsupervised", 'If you want to find the relationships between different inputs, you need to use "UNSUPERVISED" techniques.',
            "right", options = list(container = "body"))         
      )
    )
  )
)


      

