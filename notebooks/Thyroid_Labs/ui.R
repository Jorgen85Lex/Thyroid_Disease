ui <- fluidPage(
  titlePanel("TSH Level Distribution by Age and Sex"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("tsh_value", 
                  "Enter TSH Value:",
                  value = 2,
                  min = 0, 
                  max = 530,
                  step = 0.1),
      p("Enter a numeric input to filter TSH values"),
      
      radioButtons("sex", 
                   "Select Sex:",
                   choices = c("All", "M", "F"), 
                   selected = "All"),
      p("Use the radio buttons to filter by sex."),
    ),
    
    mainPanel(
      plotOutput("histogram")
    )
  )
)