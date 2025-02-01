ui <- fluidPage(
  titlePanel("TSH Level Distribution by Age and Sex"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("tsh_value", "Enter TSH Value:", value = 2, min = 0, max = 530, step = 0.1),
      p("Use the slider to filter TSH values."),
    ),
    
    mainPanel(
      plotOutput("histogram")
    )
  )
)