ui <- fluidPage(
  titlePanel("TSH Level Distribution by Age and Sex"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Distribution of TSH Levels"),
      numericInput("tsh_value", 
                   "Input TSH Value (in mU/L):", 
                   value = 2, 
                   min = 0, 
                   max = 530, 
                   step = 0.25),
      p("Use the slider to view TSH values."),
      
      radioButtons("sex", 
                   "Select Sex for Distribution:",
                   choices = c("All", "M", "F"), 
                   selected = "All"),
      p("Use the buttons to filter by sex in the distribution."),
      
      br(),
      
      h3("Compare Your TSH Level to the Expected Range"),
      numericInput("user_age", "Enter your age:", value = 30, min = 0, max = 120),
      numericInput("user_tsh", "Enter your TSH value:", value = 2, min = 0, max = 530),
      selectInput("comparison_age_range", 
                  "Select an Age Range for Comparison:",
                  choices = c("Babies < 1", "Children 1-6", "Children 7-11", 
                              "Ages 12-20", "Adults 21-99")),
      actionButton("compare_button", "Compare to Others"),
      br()
    ),
    
    mainPanel(
      textOutput("no_labs_available_message"),
      plotOutput("TSHhistogram"),
      textOutput("comparison_message")  
    )
  )
)







