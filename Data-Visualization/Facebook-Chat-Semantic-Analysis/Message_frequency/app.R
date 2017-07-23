#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(rsconnect)

rsconnect::setAccountInfo(name="jaypkim", token="5BE582B55E3AC240FA7BD944494F47A7", secret="UEncZgqzamx5iqBxicrd25Ds8Ry5TGTkpPhxbwov")


# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("Facebook Daily Chat Frequency"),
   
   # Sidebar with a slider input for number of bins 
   sidebarPanel(
         sliderInput("time",
                     "Year",
                     min = 2011,
                     max = 2014,
                     value = 2011)
      )
      ,
    mainPanel(
         imageOutput("year")
    )
))


# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
   output$year <- renderImage({
     list(
     src = paste("chat_freq_", input$time, ".png", sep =""),
      # Return a list
           alt = "Year number")}, deleteFile = FALSE)})

# Run the application 
shinyApp(ui = ui, server = server)
deployApp()

