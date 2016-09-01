
insurance <- read.csv("insurance.csv")

server <- function(input, output) {
 
 output$hist <- renderPlot({
	hist(insurance$charges)
 })

 output$summary <- renderPrint({
   summary(insurance$charges)
 })
 
 output$stats <- renderPrint({
	summary(insurance)
 })


}
