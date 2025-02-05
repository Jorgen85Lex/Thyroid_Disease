ui <- fluidPage(
  titlePanel("TSH Level Distribution by Age and Sex"),
  
  sidebarLayout(
    sidebarPanel(
      # TSH
      sliderInput("tsh_value", 
                  "Input TSH Value (in mU/L):",
                  min = 0, 
                  max = 530,
                  value = 2,
                  step = 0.25),
      p("Use the slider to view TSH values."),
      br(),
      
      radioButtons("sex", 
                   "Select Sex:",
                   choices = c("All", "M", "F"), 
                   selected = "All"),
      p("Use the buttons to select a sex."),
      
      tabsetPanel(
        tabPanel("Comparison",
                 numericInput("user_age", "Enter your age:", value = 30, min = 0, max = 120),
                 numericInput("user_tsh", "Enter your TSH value:", value = 2, min = 0, max = 530),
                 actionButton("compare_button", "Compare to others"),
                 br(),

                 selectInput("age_range", "Select an Age Range:",
                             choices = c("All", "Babies < 1", "Children 1-6", "Children 7-11", 
                                         "Ages 12-20", "Adults 21-99"), 
                             selected = "All"),
                 textOutput("comparison_message")
        ),
        tabPanel("Distribution",
                 textOutput("no_labs_available_message"),
                 plotOutput("TSHhistogram")
        )
      )
    ),
    
    mainPanel(
      plotOutput("TSHhistogram"),
      textOutput("comparison_message")
    )
  )
)



